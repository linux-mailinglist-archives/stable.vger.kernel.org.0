Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956D563584D
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236362AbiKWJy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:54:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237374AbiKWJxT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:53:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847BCED5EA
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:49:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 214DC619EB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E742C433C1;
        Wed, 23 Nov 2022 09:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196990;
        bh=2S8U6BkVtzf6K1UqOHV7ulTUcH68aHr8EkjVh7Pl4Ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1+LKvf8sQEobOERgrWKIteQHSUgpKp77L+ncPM6sd6iRbOTXldoTvDG/TXSFYgPX
         faosLqjyQ76s11MSBc6LnsBtECgiKdZ5xfkUo0wa2H8YqDPktcq6JJ+IhBJzfcvm9S
         kSNpiB0OpYxgH+wHYYtNEXMK6vPSY71234DwVvOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Fabio Estevam <festevam@gmail.com>,
        =?UTF-8?q?Steffen=20B=C3=A4tz?= <steffen@innosonix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Fabio Estevam <festevam@denx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 166/314] net: dsa: make dsa_master_ioctl() see through port_hwtstamp_get() shims
Date:   Wed, 23 Nov 2022 09:50:11 +0100
Message-Id: <20221123084633.100383793@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit ed1fe1bebe18884b11e5536b5ac42e3a48960835 ]

There are multi-generational drivers like mv88e6xxx which have code like
this:

int mv88e6xxx_port_hwtstamp_get(struct dsa_switch *ds, int port,
				struct ifreq *ifr)
{
	if (!chip->info->ptp_support)
		return -EOPNOTSUPP;

	...
}

DSA wants to deny PTP timestamping on the master if the switch supports
timestamping too. However it currently relies on the presence of the
port_hwtstamp_get() callback to determine PTP capability, and this
clearly does not work in that case (method is present but returns
-EOPNOTSUPP).

We should not deny PTP on the DSA master for those switches which truly
do not support hardware timestamping.

Create a dsa_port_supports_hwtstamp() method which actually probes for
support by calling port_hwtstamp_get() and seeing whether that returned
-EOPNOTSUPP or not.

Fixes: f685e609a301 ("net: dsa: Deny PTP on master if switch supports it")
Link: https://patchwork.kernel.org/project/netdevbpf/patch/20221110124345.3901389-1-festevam@gmail.com/
Reported-by: Fabio Estevam <festevam@gmail.com>
Reported-by: Steffen Bätz <steffen@innosonix.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/dsa_priv.h |  1 +
 net/dsa/master.c   |  3 +--
 net/dsa/port.c     | 16 ++++++++++++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index d9722e49864b..acea875c05e5 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -201,6 +201,7 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 }
 
 /* port.c */
+bool dsa_port_supports_hwtstamp(struct dsa_port *dp, struct ifreq *ifr);
 void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
 			       const struct dsa_device_ops *tag_ops);
 int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age);
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 2851e44c4cf0..46b1f0455a7b 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -204,8 +204,7 @@ static int dsa_master_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		 * switch in the tree that is PTP capable.
 		 */
 		list_for_each_entry(dp, &dst->ports, list)
-			if (dp->ds->ops->port_hwtstamp_get ||
-			    dp->ds->ops->port_hwtstamp_set)
+			if (dsa_port_supports_hwtstamp(dp, ifr))
 				return -EBUSY;
 		break;
 	}
diff --git a/net/dsa/port.c b/net/dsa/port.c
index a8895ee3cd60..9ac87063cca8 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -109,6 +109,22 @@ static bool dsa_port_can_configure_learning(struct dsa_port *dp)
 	return !err;
 }
 
+bool dsa_port_supports_hwtstamp(struct dsa_port *dp, struct ifreq *ifr)
+{
+	struct dsa_switch *ds = dp->ds;
+	int err;
+
+	if (!ds->ops->port_hwtstamp_get || !ds->ops->port_hwtstamp_set)
+		return false;
+
+	/* "See through" shim implementations of the "get" method.
+	 * This will clobber the ifreq structure, but we will either return an
+	 * error, or the master will overwrite it with proper values.
+	 */
+	err = ds->ops->port_hwtstamp_get(ds, dp->index, ifr);
+	return err != -EOPNOTSUPP;
+}
+
 int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age)
 {
 	struct dsa_switch *ds = dp->ds;
-- 
2.35.1



