Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DF56AF17D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjCGSoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233150AbjCGSoS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:44:18 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE9DB56DE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:34:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 28BB8CE1C94
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F88C433D2;
        Tue,  7 Mar 2023 18:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213689;
        bh=5RL0GqMdf3jzFmUMakrlGo00EiTjcWwEOi0v3a7tL3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YvhjsPx4uwkodn8OMsWvsOVjleJk3v/CuAxH4jiqtLfsNtUcKDxfHACsPEg9YSy7X
         egbvSJMB/FCBn93s0b7bxbKS53YaLl/tHGGI6/rKw1BBtgVtOtGGdM2vZYX4t5FRx3
         oMSHp4vqINgQtGudek6SZk3VHYaIkLpqbEofl1XA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zong-Zhe Yang <kevin_yang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 587/885] wifi: rtw89: debug: avoid invalid access on RTW89_DBG_SEL_MAC_30
Date:   Tue,  7 Mar 2023 17:58:41 +0100
Message-Id: <20230307170027.885129933@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit c074da21dd346e0cfef5d08b0715078d7aea7f8d ]

Only 8852C chip has valid pages on RTW89_DBG_SEL_MAC_30. To other chips,
this section is an address hole. It will lead to crash if trying to access
this section on chips except for 8852C. So, we avoid that.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230119063529.61563-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/debug.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/debug.c b/drivers/net/wireless/realtek/rtw89/debug.c
index 730e83d54257f..50701c55ed602 100644
--- a/drivers/net/wireless/realtek/rtw89/debug.c
+++ b/drivers/net/wireless/realtek/rtw89/debug.c
@@ -594,6 +594,7 @@ rtw89_debug_priv_mac_reg_dump_select(struct file *filp,
 	struct seq_file *m = (struct seq_file *)filp->private_data;
 	struct rtw89_debugfs_priv *debugfs_priv = m->private;
 	struct rtw89_dev *rtwdev = debugfs_priv->rtwdev;
+	const struct rtw89_chip_info *chip = rtwdev->chip;
 	char buf[32];
 	size_t buf_size;
 	int sel;
@@ -613,6 +614,12 @@ rtw89_debug_priv_mac_reg_dump_select(struct file *filp,
 		return -EINVAL;
 	}
 
+	if (sel == RTW89_DBG_SEL_MAC_30 && chip->chip_id != RTL8852C) {
+		rtw89_info(rtwdev, "sel %d is address hole on chip %d\n", sel,
+			   chip->chip_id);
+		return -EINVAL;
+	}
+
 	debugfs_priv->cb_data = sel;
 	rtw89_info(rtwdev, "select mac page dump %d\n", debugfs_priv->cb_data);
 
-- 
2.39.2



