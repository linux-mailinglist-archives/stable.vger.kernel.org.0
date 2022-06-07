Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9054D541828
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379323AbiFGVJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378972AbiFGVIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:08:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC3B212C9C;
        Tue,  7 Jun 2022 11:50:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2085FCE2425;
        Tue,  7 Jun 2022 18:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37872C385A2;
        Tue,  7 Jun 2022 18:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627846;
        bh=wB+eyMgg/Fjs26R7DtFWaZpsqYjiQcyeIh3vo3CFVwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T8dgnHJXG9BSyC23mVW6ynHmxacys7s9+dDL257xATTzF+XCCFs7IYU4aXC3wA6cj
         EXvdy85rNz7mqaGOrG58ZakHcq7UGPQDexKY8Gmh9UMsiioW40eBcQoCI+0pMxQ8vi
         sgUYgN4irtOa09X9IgZ1nUApUgD0Dvx2h2vOmJLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Po Hao Huang <phhuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 064/879] rtw89: fix misconfiguration on hw_scan channel time
Date:   Tue,  7 Jun 2022 18:53:02 +0200
Message-Id: <20220607165004.550739513@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Po Hao Huang <phhuang@realtek.com>

[ Upstream commit 65ee4971a262a024e239e5d2b7f4dee1b3dff40e ]

Without this patch, hw scan won't stay long enough on DFS/passive
channels. Found previous logic error and fix it.

Signed-off-by: Po Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220401055043.12512-5-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 6deaf8eec6b4..a9b5315a517e 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -2065,7 +2065,7 @@ static void rtw89_hw_scan_add_chan(struct rtw89_dev *rtwdev, int chan_type,
 		ch_info->num_pkt = 0;
 		break;
 	case RTW89_CHAN_DFS:
-		ch_info->period = min_t(u8, ch_info->period,
+		ch_info->period = max_t(u8, ch_info->period,
 					RTW89_DFS_CHAN_TIME);
 		ch_info->dwell_time = RTW89_DWELL_TIME;
 		break;
-- 
2.35.1



