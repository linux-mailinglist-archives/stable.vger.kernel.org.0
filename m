Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC52658361
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbiL1Qrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235007AbiL1QrN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:47:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969B81099
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:41:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E52C9CE136B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1C7C433D2;
        Wed, 28 Dec 2022 16:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245709;
        bh=GuXTu5/hidCC2R7hOxAOtJdnLMXTgANkXwXB3AxJ2ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cODfe/eqTw2MJTV41JYDbPWV+MpRsaVrN9N0E5FJfiZKkS6W3ftQiaXSI6Rs3YuEB
         U6+4mFALVUZ1q0PLvbNMtg1UAePpIM0yYlJG7qSMIKkSvQl6GygdXqMLe22mJETsfX
         3++vA8h6tWkPmYlmXUVH3VH/kc6iTdrBDA8X7K+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maksim Kiselev <bigunclemax@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0909/1146] net: dsa: mv88e6xxx: avoid reg_lock deadlock in mv88e6xxx_setup_port()
Date:   Wed, 28 Dec 2022 15:40:48 +0100
Message-Id: <20221228144354.917454331@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit a7d82367daa6baa5e8399e6327e7f2f463534505 ]

In the blamed commit, it was not noticed that one implementation of
chip->info->ops->phylink_get_caps(), called by mv88e6xxx_get_caps(),
may access hardware registers, and in doing so, it takes the
mv88e6xxx_reg_lock(). Namely, this is mv88e6352_phylink_get_caps().

This is a problem because mv88e6xxx_get_caps(), apart from being
a top-level function (method invoked by dsa_switch_ops), is now also
directly called from mv88e6xxx_setup_port(), which runs under the
mv88e6xxx_reg_lock() taken by mv88e6xxx_setup(). Therefore, when running
on mv88e6352, the reg_lock would be acquired a second time and the
system would deadlock on driver probe.

The things that mv88e6xxx_setup() can compete with in terms of register
access with are the IRQ handlers and MDIO bus operations registered by
mv88e6xxx_probe(). So there is a real need to acquire the register lock.

The register lock can, in principle, be dropped and re-acquired pretty
much at will within the driver, as long as no operations that involve
waiting for indirect access to complete (essentially, callers of
mv88e6xxx_smi_direct_wait() and mv88e6xxx_wait_mask()) are interrupted
with the lock released. However, I would guess that in mv88e6xxx_setup(),
the critical section is kept open for such a long time just in order to
optimize away multiple lock/unlock operations on the registers.

We could, in principle, drop the reg_lock right before the
mv88e6xxx_setup_port() -> mv88e6xxx_get_caps() call, and
re-acquire it immediately afterwards. But this would look ugly, because
mv88e6xxx_setup_port() would release a lock which it didn't acquire, but
the caller did.

A cleaner solution to this issue comes from the observation that struct
mv88e6xxxx_ops methods generally assume they are called with the
reg_lock already acquired. Whereas mv88e6352_phylink_get_caps() is more
the exception rather than the norm, in that it acquires the lock itself.

Let's enforce the same locking pattern/convention for
chip->info->ops->phylink_get_caps() as well, and make
mv88e6xxx_get_caps(), the top-level function, acquire the register lock
explicitly, for this one implementation that will access registers for
port 4 to work properly.

This means that mv88e6xxx_setup_port() will no longer call the top-level
function, but the low-level mv88e6xxx_ops method which expects the
correct calling context (register lock held).

Compared to chip->info->ops->phylink_get_caps(), mv88e6xxx_get_caps()
also fixes up the supported_interfaces bitmap for internal ports, since
that can be done generically and does not require per-switch knowledge.
That's code which will no longer execute, however mv88e6xxx_setup_port()
doesn't need that. It just needs to look at the mac_capabilities bitmap.

Fixes: cc1049ccee20 ("net: dsa: mv88e6xxx: fix speed setting for CPU/DSA ports")
Reported-by: Maksim Kiselev <bigunclemax@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Maksim Kiselev <bigunclemax@gmail.com>
Link: https://lore.kernel.org/r/20221214110120.3368472-1-vladimir.oltean@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 937cb22cb3d4..3b8b2d0fbafa 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -689,13 +689,12 @@ static void mv88e6352_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 
 	/* Port 4 supports automedia if the serdes is associated with it. */
 	if (port == 4) {
-		mv88e6xxx_reg_lock(chip);
 		err = mv88e6352_g2_scratch_port_has_serdes(chip, port);
 		if (err < 0)
 			dev_err(chip->dev, "p%d: failed to read scratch\n",
 				port);
 		if (err <= 0)
-			goto unlock;
+			return;
 
 		cmode = mv88e6352_get_port4_serdes_cmode(chip);
 		if (cmode < 0)
@@ -703,8 +702,6 @@ static void mv88e6352_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 				port);
 		else
 			mv88e6xxx_translate_cmode(cmode, supported);
-unlock:
-		mv88e6xxx_reg_unlock(chip);
 	}
 }
 
@@ -831,7 +828,9 @@ static void mv88e6xxx_get_caps(struct dsa_switch *ds, int port,
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 
+	mv88e6xxx_reg_lock(chip);
 	chip->info->ops->phylink_get_caps(chip, port, config);
+	mv88e6xxx_reg_unlock(chip);
 
 	if (mv88e6xxx_phy_is_internal(ds, port)) {
 		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
@@ -3307,7 +3306,7 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 		struct phylink_config pl_config = {};
 		unsigned long caps;
 
-		mv88e6xxx_get_caps(ds, port, &pl_config);
+		chip->info->ops->phylink_get_caps(chip, port, &pl_config);
 
 		caps = pl_config.mac_capabilities;
 
-- 
2.35.1



