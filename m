Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1CF6213D4
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbiKHNyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234679AbiKHNyQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:54:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D20721A6
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:54:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC4C4B81AE8
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FCEC43470;
        Tue,  8 Nov 2022 13:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915652;
        bh=70A0BMttabRFUwbNBoBO+vOEa4Ih14RbeOPICurCA68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YBjOnrBtcCVoqZfvTgalhgPXIwTD1wmjIG9sJ7i0Lzu26qdEVk56vfIMWAyP65rJR
         CeIhOIPTmg/MLsEJgEcoYoMdocV6dvsmjuurQmMnuLJw4IwEMEfg36DBmKsrqPlLi1
         ogGQmI+8lUjo4XfD+Y89ei81I0CSEDW776Nmbelo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/118] nfc: fdp: drop ftrace-like debugging messages
Date:   Tue,  8 Nov 2022 14:38:20 +0100
Message-Id: <20221108133341.633848667@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit 9571289ddf71694de0e023afc5e88d90cfd067b5 ]

Now that the kernel has ftrace, any debugging calls that just do "made
it to this function!" and "leaving this function!" can be removed.
Better to use standard debugging tools.

This allows also to remove several local variables and entire
fdp_nci_recv_frame() function (whose purpose was only to log).

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20210531073522.6720-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8e4aae6b8ca7 ("nfc: fdp: Fix potential memory leak in fdp_nci_send()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/fdp/fdp.c | 31 -------------------------------
 drivers/nfc/fdp/fdp.h |  1 -
 drivers/nfc/fdp/i2c.c | 12 +-----------
 3 files changed, 1 insertion(+), 43 deletions(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index 4dc7bd7e02b6..52c60d11849c 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -238,9 +238,6 @@ static int fdp_nci_open(struct nci_dev *ndev)
 {
 	int r;
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
-	struct device *dev = &info->phy->i2c_dev->dev;
-
-	dev_dbg(dev, "%s\n", __func__);
 
 	r = info->phy_ops->enable(info->phy);
 
@@ -249,19 +246,12 @@ static int fdp_nci_open(struct nci_dev *ndev)
 
 static int fdp_nci_close(struct nci_dev *ndev)
 {
-	struct fdp_nci_info *info = nci_get_drvdata(ndev);
-	struct device *dev = &info->phy->i2c_dev->dev;
-
-	dev_dbg(dev, "%s\n", __func__);
 	return 0;
 }
 
 static int fdp_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 {
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
-	struct device *dev = &info->phy->i2c_dev->dev;
-
-	dev_dbg(dev, "%s\n", __func__);
 
 	if (atomic_dec_and_test(&info->data_pkt_counter))
 		info->data_pkt_counter_cb(ndev);
@@ -269,16 +259,6 @@ static int fdp_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 	return info->phy_ops->write(info->phy, skb);
 }
 
-int fdp_nci_recv_frame(struct nci_dev *ndev, struct sk_buff *skb)
-{
-	struct fdp_nci_info *info = nci_get_drvdata(ndev);
-	struct device *dev = &info->phy->i2c_dev->dev;
-
-	dev_dbg(dev, "%s\n", __func__);
-	return nci_recv_frame(ndev, skb);
-}
-EXPORT_SYMBOL(fdp_nci_recv_frame);
-
 static int fdp_nci_request_firmware(struct nci_dev *ndev)
 {
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
@@ -489,8 +469,6 @@ static int fdp_nci_setup(struct nci_dev *ndev)
 	int r;
 	u8 patched = 0;
 
-	dev_dbg(dev, "%s\n", __func__);
-
 	r = nci_core_init(ndev);
 	if (r)
 		goto error;
@@ -598,9 +576,7 @@ static int fdp_nci_core_reset_ntf_packet(struct nci_dev *ndev,
 					  struct sk_buff *skb)
 {
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
-	struct device *dev = &info->phy->i2c_dev->dev;
 
-	dev_dbg(dev, "%s\n", __func__);
 	info->setup_reset_ntf = 1;
 	wake_up(&info->setup_wq);
 
@@ -611,9 +587,7 @@ static int fdp_nci_prop_patch_ntf_packet(struct nci_dev *ndev,
 					  struct sk_buff *skb)
 {
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
-	struct device *dev = &info->phy->i2c_dev->dev;
 
-	dev_dbg(dev, "%s\n", __func__);
 	info->setup_patch_ntf = 1;
 	info->setup_patch_status = skb->data[0];
 	wake_up(&info->setup_wq);
@@ -786,11 +760,6 @@ EXPORT_SYMBOL(fdp_nci_probe);
 
 void fdp_nci_remove(struct nci_dev *ndev)
 {
-	struct fdp_nci_info *info = nci_get_drvdata(ndev);
-	struct device *dev = &info->phy->i2c_dev->dev;
-
-	dev_dbg(dev, "%s\n", __func__);
-
 	nci_unregister_device(ndev);
 	nci_free_device(ndev);
 }
diff --git a/drivers/nfc/fdp/fdp.h b/drivers/nfc/fdp/fdp.h
index 9bd1f3f23e2d..ead3b21ccae6 100644
--- a/drivers/nfc/fdp/fdp.h
+++ b/drivers/nfc/fdp/fdp.h
@@ -25,6 +25,5 @@ int fdp_nci_probe(struct fdp_i2c_phy *phy, struct nfc_phy_ops *phy_ops,
 		  struct nci_dev **ndev, int tx_headroom, int tx_tailroom,
 		  u8 clock_type, u32 clock_freq, u8 *fw_vsc_cfg);
 void fdp_nci_remove(struct nci_dev *ndev);
-int fdp_nci_recv_frame(struct nci_dev *ndev, struct sk_buff *skb);
 
 #endif /* __LOCAL_FDP_H_ */
diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index ad0abb1f0bae..5e300788be52 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -49,7 +49,6 @@ static int fdp_nci_i2c_enable(void *phy_id)
 {
 	struct fdp_i2c_phy *phy = phy_id;
 
-	dev_dbg(&phy->i2c_dev->dev, "%s\n", __func__);
 	fdp_nci_i2c_reset(phy);
 
 	return 0;
@@ -59,7 +58,6 @@ static void fdp_nci_i2c_disable(void *phy_id)
 {
 	struct fdp_i2c_phy *phy = phy_id;
 
-	dev_dbg(&phy->i2c_dev->dev, "%s\n", __func__);
 	fdp_nci_i2c_reset(phy);
 }
 
@@ -197,7 +195,6 @@ static int fdp_nci_i2c_read(struct fdp_i2c_phy *phy, struct sk_buff **skb)
 static irqreturn_t fdp_nci_i2c_irq_thread_fn(int irq, void *phy_id)
 {
 	struct fdp_i2c_phy *phy = phy_id;
-	struct i2c_client *client;
 	struct sk_buff *skb;
 	int r;
 
@@ -206,9 +203,6 @@ static irqreturn_t fdp_nci_i2c_irq_thread_fn(int irq, void *phy_id)
 		return IRQ_NONE;
 	}
 
-	client = phy->i2c_dev;
-	dev_dbg(&client->dev, "%s\n", __func__);
-
 	r = fdp_nci_i2c_read(phy, &skb);
 
 	if (r == -EREMOTEIO)
@@ -217,7 +211,7 @@ static irqreturn_t fdp_nci_i2c_irq_thread_fn(int irq, void *phy_id)
 		return IRQ_HANDLED;
 
 	if (skb != NULL)
-		fdp_nci_recv_frame(phy->ndev, skb);
+		nci_recv_frame(phy->ndev, skb);
 
 	return IRQ_HANDLED;
 }
@@ -288,8 +282,6 @@ static int fdp_nci_i2c_probe(struct i2c_client *client)
 	u32 clock_freq;
 	int r = 0;
 
-	dev_dbg(dev, "%s\n", __func__);
-
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
 		nfc_err(dev, "No I2C_FUNC_I2C support\n");
 		return -ENODEV;
@@ -351,8 +343,6 @@ static int fdp_nci_i2c_remove(struct i2c_client *client)
 {
 	struct fdp_i2c_phy *phy = i2c_get_clientdata(client);
 
-	dev_dbg(&client->dev, "%s\n", __func__);
-
 	fdp_nci_remove(phy->ndev);
 	fdp_nci_i2c_disable(phy);
 
-- 
2.35.1



