Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72FD1498A5C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343718AbiAXTCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345655AbiAXTAs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:00:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D561AC061361;
        Mon, 24 Jan 2022 10:58:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 941DBB8122C;
        Mon, 24 Jan 2022 18:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6681C340E5;
        Mon, 24 Jan 2022 18:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050692;
        bh=PqIes5aqMi82sgamTCFW7C3quXpYhrox4Cg+Dwcr4wg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Du6mV6bFt+PRmELFiFAYojpzSXTNo+tmT8HSIgRMSJfp+yTJvVHTxaVZw6yflFl7L
         Qd4vxZSswmOhJQxXXZ1Jvn8d9voOL/XRRovp2KWOBL+cd+niVmw5aNgTuJ0VEnDaPp
         W1TA2faLZZuvL2kS7cyJ5ePXP03an7e9urT9u89I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 050/157] fsl/fman: Check for null pointer after calling devm_ioremap
Date:   Mon, 24 Jan 2022 19:42:20 +0100
Message-Id: <20220124183934.378195759@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit d5a73ec96cc57cf67e51b12820fc2354e7ca46f8 ]

As the possible failure of the allocation, the devm_ioremap() may return
NULL pointer.
Take tgec_initialization() as an example.
If allocation fails, the params->base_addr will be NULL pointer and will
be assigned to tgec->regs in tgec_config().
Then it will cause the dereference of NULL pointer in set_mac_address(),
which is called by tgec_init().
Therefore, it should be better to add the sanity check after the calling
of the devm_ioremap().

Fixes: 3933961682a3 ("fsl/fman: Add FMan MAC driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fman/mac.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 81021f87e4f39..93b7ed361b82e 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -96,14 +96,17 @@ static void mac_exception(void *handle, enum fman_mac_exceptions ex)
 		__func__, ex);
 }
 
-static void set_fman_mac_params(struct mac_device *mac_dev,
-				struct fman_mac_params *params)
+static int set_fman_mac_params(struct mac_device *mac_dev,
+			       struct fman_mac_params *params)
 {
 	struct mac_priv_s *priv = mac_dev->priv;
 
 	params->base_addr = (typeof(params->base_addr))
 		devm_ioremap(priv->dev, mac_dev->res->start,
 			     resource_size(mac_dev->res));
+	if (!params->base_addr)
+		return -ENOMEM;
+
 	memcpy(&params->addr, mac_dev->addr, sizeof(mac_dev->addr));
 	params->max_speed	= priv->max_speed;
 	params->phy_if		= priv->phy_if;
@@ -114,6 +117,8 @@ static void set_fman_mac_params(struct mac_device *mac_dev,
 	params->event_cb	= mac_exception;
 	params->dev_id		= mac_dev;
 	params->internal_phy_node = priv->internal_phy_node;
+
+	return 0;
 }
 
 static int tgec_initialization(struct mac_device *mac_dev)
@@ -125,7 +130,9 @@ static int tgec_initialization(struct mac_device *mac_dev)
 
 	priv = mac_dev->priv;
 
-	set_fman_mac_params(mac_dev, &params);
+	err = set_fman_mac_params(mac_dev, &params);
+	if (err)
+		goto _return;
 
 	mac_dev->fman_mac = tgec_config(&params);
 	if (!mac_dev->fman_mac) {
@@ -171,7 +178,9 @@ static int dtsec_initialization(struct mac_device *mac_dev)
 
 	priv = mac_dev->priv;
 
-	set_fman_mac_params(mac_dev, &params);
+	err = set_fman_mac_params(mac_dev, &params);
+	if (err)
+		goto _return;
 
 	mac_dev->fman_mac = dtsec_config(&params);
 	if (!mac_dev->fman_mac) {
@@ -220,7 +229,9 @@ static int memac_initialization(struct mac_device *mac_dev)
 
 	priv = mac_dev->priv;
 
-	set_fman_mac_params(mac_dev, &params);
+	err = set_fman_mac_params(mac_dev, &params);
+	if (err)
+		goto _return;
 
 	if (priv->max_speed == SPEED_10000)
 		params.phy_if = PHY_INTERFACE_MODE_XGMII;
-- 
2.34.1



