Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 880EC621449
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234879AbiKHN7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:59:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234884AbiKHN7k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:59:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C7962399
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:59:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7801B816DD
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9F5C433C1;
        Tue,  8 Nov 2022 13:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915976;
        bh=OVvLQmdwABQpBx2FCNJifhz3oQas8ZeEXzyCZg7H0g0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dP1zapR66GSIx48ibOvW8zZAzWNxiR0QDAtCtEFBNL1BlU7X3Iofl2pAt74BY24oo
         HD7QW4aPFnd0HQrJQE8uYr3NX5xuSh+hWoBRK0CLLXfMSwfxn2lYw8uNwb8i29ENsl
         XNHCgCULEuNwlJaexp/5ZumO6ivSo7piMCGm0fgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiko Thiery <heiko.thiery@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/144] net: dsa: fall back to default tagger if we cant load the one from DT
Date:   Tue,  8 Nov 2022 14:38:24 +0100
Message-Id: <20221108133346.421696606@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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

[ Upstream commit a2c65a9d0568b6737c02b54f00b80716a53fac61 ]

DSA tagging protocol drivers can be changed at runtime through sysfs and
at probe time through the device tree (support for the latter was added
later).

When changing through sysfs, it is assumed that the module for the new
tagging protocol was already loaded into the kernel (in fact this is
only a concern for Ocelot/Felix switches, where we have tag_ocelot.ko
and tag_ocelot_8021q.ko; for every other switch, the default and
alternative protocols are compiled within the same .ko, so there is
nothing for the user to load).

The kernel cannot currently call request_module(), because it has no way
of constructing the modalias name of the tagging protocol driver
("dsa_tag-%d", where the number is one of DSA_TAG_PROTO_*_VALUE).
The device tree only contains the string name of the tagging protocol
("ocelot-8021q"), and the only mapping between the string and the
DSA_TAG_PROTO_OCELOT_8021Q_VALUE is present in tag_ocelot_8021q.ko.
So this is a chicken-and-egg situation and dsa_core.ko has nothing based
on which it can automatically request the insertion of the module.

As a consequence, if CONFIG_NET_DSA_TAG_OCELOT_8021Q is built as module,
the switch will forever defer probing.

The long-term solution is to make DSA call request_module() somehow,
but that probably needs some refactoring.

What we can do to keep operating with existing device tree blobs is to
cancel the attempt to change the tagging protocol with the one specified
there, and to remain operating with the default one. Depending on the
situation, the default protocol might still allow some functionality
(in the case of ocelot, it does), and it's better to have that than to
fail to probe.

Fixes: deff710703d8 ("net: dsa: Allow default tag protocol to be overridden from DT")
Link: https://lore.kernel.org/lkml/20221027113248.420216-1-michael@walle.cc/
Reported-by: Heiko Thiery <heiko.thiery@gmail.com>
Reported-by: Michael Walle <michael@walle.cc>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Michael Walle <michael@walle.cc>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20221027145439.3086017-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/dsa2.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 64a56db3de58..34763f575c30 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1253,9 +1253,9 @@ static enum dsa_tag_protocol dsa_get_tag_protocol(struct dsa_port *dp,
 static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
 			      const char *user_protocol)
 {
+	const struct dsa_device_ops *tag_ops = NULL;
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_switch_tree *dst = ds->dst;
-	const struct dsa_device_ops *tag_ops;
 	enum dsa_tag_protocol default_proto;
 
 	/* Find out which protocol the switch would prefer. */
@@ -1278,10 +1278,17 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
 		}
 
 		tag_ops = dsa_find_tagger_by_name(user_protocol);
-	} else {
-		tag_ops = dsa_tag_driver_get(default_proto);
+		if (IS_ERR(tag_ops)) {
+			dev_warn(ds->dev,
+				 "Failed to find a tagging driver for protocol %s, using default\n",
+				 user_protocol);
+			tag_ops = NULL;
+		}
 	}
 
+	if (!tag_ops)
+		tag_ops = dsa_tag_driver_get(default_proto);
+
 	if (IS_ERR(tag_ops)) {
 		if (PTR_ERR(tag_ops) == -ENOPROTOOPT)
 			return -EPROBE_DEFER;
-- 
2.35.1



