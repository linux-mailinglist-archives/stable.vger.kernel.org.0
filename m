Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B34D6AE8FA
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbjCGRTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:19:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbjCGRTJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:19:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C23B838AA
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:14:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE631614E8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3EBEC4339B;
        Tue,  7 Mar 2023 17:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209291;
        bh=7HH2XDgwJrAY4oC5piNukxwTtOSSCQ8UeNceIwipvGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LYTpBmF9RSMsoxtc1E31RZAcuiALytV9KEECiaZMo9E7TtO8t2w4sSGIrZchlz4qU
         kBT28Unrdy2djKnTaUv1X/+1vZropqvEtjsygm8KcFPkGB2909AqcFyMc8R21PQ1h7
         MxrxHGE6TvaUCbsAmttpEQSPPjs3nRnX9+fw/G2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0154/1001] wifi: rtl8xxxu: Fix assignment to bit field priv->pi_enabled
Date:   Tue,  7 Mar 2023 17:48:46 +0100
Message-Id: <20230307170028.738244582@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit 9e32b4a709f0f7b7adf5d9939c3bd47c78c4f003 ]

Just because priv->pi_enabled is only one bit doesn't mean it works
like a bool. The value assigned to it loses all bits except bit 0,
so only assign 0 or 1 to it.

This affects the RTL8188FU, but fixing the assignment didn't make
a difference for my device.

Fixes: c888183b21f3 ("wifi: rtl8xxxu: Support new chip RTL8188FU")
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/4368d585-11ec-d3c7-ec12-7f0afdcedfda@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c
index 2c4f403ba68f3..97e7ff7289fab 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c
@@ -1122,7 +1122,7 @@ static void rtl8188fu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
 
 	if (t == 0) {
 		val32 = rtl8xxxu_read32(priv, REG_FPGA0_XA_HSSI_PARM1);
-		priv->pi_enabled = val32 & FPGA0_HSSI_PARM1_PI;
+		priv->pi_enabled = u32_get_bits(val32, FPGA0_HSSI_PARM1_PI);
 	}
 
 	/* save RF path */
-- 
2.39.2



