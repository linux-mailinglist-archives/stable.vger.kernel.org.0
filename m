Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E754CF920
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239858AbiCGKDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240466AbiCGKBD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:01:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8566419;
        Mon,  7 Mar 2022 01:48:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A397608C0;
        Mon,  7 Mar 2022 09:48:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB16C340E9;
        Mon,  7 Mar 2022 09:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646499;
        bh=s2eekJYXb2Eohk+dVatEAsJSSu7Uj3FGTmgAXy0tyKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2tssteNlhNtteZm+6ennOLJ1pPAFd3JVNIX9NFXrrn8Z8Js6+RQBaBEYOc/7sSox8
         pXEcE/ZeNAtBoTziDKlhNnbAqekvG6VW2NoIH0pgLNRpC3+8LwQLGjQJr+ufwawZKS
         EA7T/u1o5wm7HNoHOrbc6YuTsMGhDGvcyY4/aWNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Casper Andersson <casper.casan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 222/262] net: sparx5: Fix add vlan when invalid operation
Date:   Mon,  7 Mar 2022 10:19:26 +0100
Message-Id: <20220307091709.335425325@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
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

From: Casper Andersson <casper.casan@gmail.com>

[ Upstream commit b3a34dc362c03215031b268fcc0b988e69490231 ]

Check if operation is valid before changing any
settings in hardware. Otherwise it results in
changes being made despite it not being a valid
operation.

Fixes: 78eab33bb68b ("net: sparx5: add vlan support")

Signed-off-by: Casper Andersson <casper.casan@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/microchip/sparx5/sparx5_vlan.c   | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
index 4ce490a25f33..8e56ffa1c4f7 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
@@ -58,16 +58,6 @@ int sparx5_vlan_vid_add(struct sparx5_port *port, u16 vid, bool pvid,
 	struct sparx5 *sparx5 = port->sparx5;
 	int ret;
 
-	/* Make the port a member of the VLAN */
-	set_bit(port->portno, sparx5->vlan_mask[vid]);
-	ret = sparx5_vlant_set_mask(sparx5, vid);
-	if (ret)
-		return ret;
-
-	/* Default ingress vlan classification */
-	if (pvid)
-		port->pvid = vid;
-
 	/* Untagged egress vlan classification */
 	if (untagged && port->vid != vid) {
 		if (port->vid) {
@@ -79,6 +69,16 @@ int sparx5_vlan_vid_add(struct sparx5_port *port, u16 vid, bool pvid,
 		port->vid = vid;
 	}
 
+	/* Make the port a member of the VLAN */
+	set_bit(port->portno, sparx5->vlan_mask[vid]);
+	ret = sparx5_vlant_set_mask(sparx5, vid);
+	if (ret)
+		return ret;
+
+	/* Default ingress vlan classification */
+	if (pvid)
+		port->pvid = vid;
+
 	sparx5_vlan_port_apply(sparx5, port);
 
 	return 0;
-- 
2.34.1



