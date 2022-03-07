Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBF644CFA5E
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbiCGKQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241303AbiCGKKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:10:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED0329CBD;
        Mon,  7 Mar 2022 01:52:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E958CB810A8;
        Mon,  7 Mar 2022 09:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5C0C340F3;
        Mon,  7 Mar 2022 09:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646771;
        bh=u//V4rLROZ+2Eueqd7C40Ei0MbMJtazySQEOq/suhPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZefrhKD4FS12r4QIgQ8IKI1JO7z8C8O/d7WUJuXWLKxVXzA4W4KTztg7UKgvIDR64
         jzq33geoukdPwigWTK5KaNpewkCPhLYwRQs8kFNbwx2rLIT16uaOCsMFNDQAglKhHj
         1bBNXNk9IEQKHS5V7OTaX01uxjKXKdErraPINnpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Svenning=20S=C3=B8rensen?= <sss@secomea.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 088/186] net: dsa: microchip: fix bridging with more than two member ports
Date:   Mon,  7 Mar 2022 10:18:46 +0100
Message-Id: <20220307091656.545913586@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Svenning Sørensen <sss@secomea.com>

commit 3d00827a90db6f79abc7cdc553887f89a2e0a184 upstream.

Commit b3612ccdf284 ("net: dsa: microchip: implement multi-bridge support")
plugged a packet leak between ports that were members of different bridges.
Unfortunately, this broke another use case, namely that of more than two
ports that are members of the same bridge.

After that commit, when a port is added to a bridge, hardware bridging
between other member ports of that bridge will be cleared, preventing
packet exchange between them.

Fix by ensuring that the Port VLAN Membership bitmap includes any existing
ports in the bridge, not just the port being added.

Fixes: b3612ccdf284 ("net: dsa: microchip: implement multi-bridge support")
Signed-off-by: Svenning Sørensen <sss@secomea.com>
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/ksz_common.c |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -26,7 +26,7 @@ void ksz_update_port_member(struct ksz_d
 	struct dsa_switch *ds = dev->ds;
 	u8 port_member = 0, cpu_port;
 	const struct dsa_port *dp;
-	int i;
+	int i, j;
 
 	if (!dsa_is_user_port(ds, port))
 		return;
@@ -45,13 +45,33 @@ void ksz_update_port_member(struct ksz_d
 			continue;
 		if (!dp->bridge_dev || dp->bridge_dev != other_dp->bridge_dev)
 			continue;
+		if (other_p->stp_state != BR_STATE_FORWARDING)
+			continue;
 
-		if (other_p->stp_state == BR_STATE_FORWARDING &&
-		    p->stp_state == BR_STATE_FORWARDING) {
+		if (p->stp_state == BR_STATE_FORWARDING) {
 			val |= BIT(port);
 			port_member |= BIT(i);
 		}
 
+		/* Retain port [i]'s relationship to other ports than [port] */
+		for (j = 0; j < ds->num_ports; j++) {
+			const struct dsa_port *third_dp;
+			struct ksz_port *third_p;
+
+			if (j == i)
+				continue;
+			if (j == port)
+				continue;
+			if (!dsa_is_user_port(ds, j))
+				continue;
+			third_p = &dev->ports[j];
+			if (third_p->stp_state != BR_STATE_FORWARDING)
+				continue;
+			third_dp = dsa_to_port(ds, j);
+			if (third_dp->bridge_dev == dp->bridge_dev)
+				val |= BIT(j);
+		}
+
 		dev->dev_ops->cfg_port_member(dev, i, val | cpu_port);
 	}
 


