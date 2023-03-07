Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D19F66AE908
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbjCGRUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbjCGRUJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:20:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EB093E32
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:15:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 646F0B819B2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91242C433D2;
        Tue,  7 Mar 2023 17:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209325;
        bh=Xw3BmJbFwmIAQMUqpUyKUWO9WW/VIV62NGEnLbp7tRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c/zRr+e46NtVR9c9y5QfEHTQxMYKUbU4TU4nCQsPOSdrPpG/QoN0AE441QFihIa5I
         ld2ZXWgRsU3/9jztIkNA/EJRxwmVgwBwowJvR/2XoxstiD4kHwcgty8SyQR3CdJQMg
         4K1ZguiBHyjagW6osMBPuYq3JruI4LpH5nGBx1NM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0155/1001] wifi: rtl8xxxu: Fix assignment to bit field priv->cck_agc_report_type
Date:   Tue,  7 Mar 2023 17:48:47 +0100
Message-Id: <20230307170028.785245943@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit 639c26faf9b15922bc620af341545d6c5d6aab2d ]

Just because priv->cck_agc_report_type is only one bit doesn't mean
it works like a bool. The value assigned to it loses all bits except
bit 0, so only assign 0 or 1 to it.

This affects the RTL8192EU, but rtl8xxxu already can't connect to any
networks with this chip, so it probably didn't bother anyone.

Fixes: 2ad2a813b803 ("wifi: rtl8xxxu: Fix the CCK RSSI calculation")
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/7bb4858c-5cef-9cae-5e08-7e8444e8ba89@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 3ed435401e570..799b03ec19806 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4208,10 +4208,12 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		 * should be equal or CCK RSSI report may be incorrect
 		 */
 		val32 = rtl8xxxu_read32(priv, REG_FPGA0_XA_HSSI_PARM2);
-		priv->cck_agc_report_type = val32 & FPGA0_HSSI_PARM2_CCK_HIGH_PWR;
+		priv->cck_agc_report_type =
+			u32_get_bits(val32, FPGA0_HSSI_PARM2_CCK_HIGH_PWR);
 
 		val32 = rtl8xxxu_read32(priv, REG_FPGA0_XB_HSSI_PARM2);
-		if (priv->cck_agc_report_type != (bool)(val32 & FPGA0_HSSI_PARM2_CCK_HIGH_PWR)) {
+		if (priv->cck_agc_report_type !=
+		    u32_get_bits(val32, FPGA0_HSSI_PARM2_CCK_HIGH_PWR)) {
 			if (priv->cck_agc_report_type)
 				val32 |= FPGA0_HSSI_PARM2_CCK_HIGH_PWR;
 			else
-- 
2.39.2



