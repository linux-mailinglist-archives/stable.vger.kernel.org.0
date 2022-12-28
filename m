Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6F7657D5F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbiL1Pmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbiL1Pm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:42:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C1117044
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:42:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B0E2B8172B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1CCC433D2;
        Wed, 28 Dec 2022 15:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242146;
        bh=VfFYS3P/YwmDM0aWfN8kmbrIPtkCvXK+TmZw2A0TAnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AkZXJA/pQDQWehcnpmpWJarGXEmTPnHwcCGKhkeXo12TWuMsCIwmhNClvFF8ZhdWp
         fBREy4mqS4fL1GU8gBOxHwy9DMtN/kqOe8gJZ0NXaFIEPM0elefLR+A9y0yTQgY65m
         gvoDqSvcMX5ml3dvHEfQY+LJyqsWsyHF/RpoLeN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0334/1146] wifi: rtw89: Fix some error handling path in rtw89_core_sta_assoc()
Date:   Wed, 28 Dec 2022 15:31:13 +0100
Message-Id: <20221228144339.233463537@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 81c0b8928437ddfe87b0024c5bd817bc331d8524 ]

'ret' is not updated after a function call in rtw89_core_sta_assoc().
This prevent error handling from working.

Add the missing assignment.

Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/7b1d82594635e4406d3438f33d8da29eaa056c5a.1668354547.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index bc2994865372..ad420d7ec8af 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -2527,7 +2527,7 @@ int rtw89_core_sta_assoc(struct rtw89_dev *rtwdev,
 	}
 
 	/* update cam aid mac_id net_type */
-	rtw89_fw_h2c_cam(rtwdev, rtwvif, rtwsta, NULL);
+	ret = rtw89_fw_h2c_cam(rtwdev, rtwvif, rtwsta, NULL);
 	if (ret) {
 		rtw89_warn(rtwdev, "failed to send h2c cam\n");
 		return ret;
-- 
2.35.1



