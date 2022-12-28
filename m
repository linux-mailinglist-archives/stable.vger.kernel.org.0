Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5A046578BB
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbiL1Oxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbiL1Oxf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:53:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0596CF1
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:53:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48C2AB81707
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF44DC433EF;
        Wed, 28 Dec 2022 14:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239211;
        bh=WaD9wFw7pS3mCGugtKAx4RaTcROSvwI6ifkjG1pPutY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2yOAepTMTjRA2y2QLQZu3XJ8Y84qBSEp1v002x7ExAbAd/OxxJmK/vtoANGUa/9T
         bb6LYV4Jdd2wMwmVRMZ1h+x47jnbpq5hhohtb7kSOx/4EH9aRFEDO8Y1BtSw/2oEbl
         fuR8sSX6bXXNp1Nj8uSuo+WihvNxFtoIKWnvkHE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 143/731] wifi: rtl8xxxu: Fix reading the vendor of combo chips
Date:   Wed, 28 Dec 2022 15:34:10 +0100
Message-Id: <20221228144300.694761702@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit 6f103aeb5e985ac08f3a4a049a2c17294f40cff9 ]

The wifi + bluetooth combo chips (RTL8723AU and RTL8723BU) read the
chip vendor from the wrong register because the val32 variable gets
overwritten. Add one more variable to avoid this.

This had no real effect on RTL8723BU. It may have had an effect on
RTL8723AU.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/24af8024-2f07-552b-93d8-38823d8e3cb0@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c    | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index e74c885a04e5..2a4ecbb0fce6 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -1607,18 +1607,18 @@ static void rtl8xxxu_print_chipinfo(struct rtl8xxxu_priv *priv)
 static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 {
 	struct device *dev = &priv->udev->dev;
-	u32 val32, bonding;
+	u32 val32, bonding, sys_cfg;
 	u16 val16;
 
-	val32 = rtl8xxxu_read32(priv, REG_SYS_CFG);
-	priv->chip_cut = (val32 & SYS_CFG_CHIP_VERSION_MASK) >>
+	sys_cfg = rtl8xxxu_read32(priv, REG_SYS_CFG);
+	priv->chip_cut = (sys_cfg & SYS_CFG_CHIP_VERSION_MASK) >>
 		SYS_CFG_CHIP_VERSION_SHIFT;
-	if (val32 & SYS_CFG_TRP_VAUX_EN) {
+	if (sys_cfg & SYS_CFG_TRP_VAUX_EN) {
 		dev_info(dev, "Unsupported test chip\n");
 		return -ENOTSUPP;
 	}
 
-	if (val32 & SYS_CFG_BT_FUNC) {
+	if (sys_cfg & SYS_CFG_BT_FUNC) {
 		if (priv->chip_cut >= 3) {
 			sprintf(priv->chip_name, "8723BU");
 			priv->rtl_chip = RTL8723B;
@@ -1640,7 +1640,7 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 		if (val32 & MULTI_GPS_FUNC_EN)
 			priv->has_gps = 1;
 		priv->is_multi_func = 1;
-	} else if (val32 & SYS_CFG_TYPE_ID) {
+	} else if (sys_cfg & SYS_CFG_TYPE_ID) {
 		bonding = rtl8xxxu_read32(priv, REG_HPON_FSM);
 		bonding &= HPON_FSM_BONDING_MASK;
 		if (priv->fops->tx_desc_size ==
@@ -1688,7 +1688,7 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 	case RTL8188E:
 	case RTL8192E:
 	case RTL8723B:
-		switch (val32 & SYS_CFG_VENDOR_EXT_MASK) {
+		switch (sys_cfg & SYS_CFG_VENDOR_EXT_MASK) {
 		case SYS_CFG_VENDOR_ID_TSMC:
 			sprintf(priv->chip_vendor, "TSMC");
 			break;
@@ -1705,7 +1705,7 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 		}
 		break;
 	default:
-		if (val32 & SYS_CFG_VENDOR_ID) {
+		if (sys_cfg & SYS_CFG_VENDOR_ID) {
 			sprintf(priv->chip_vendor, "UMC");
 			priv->vendor_umc = 1;
 		} else {
-- 
2.35.1



