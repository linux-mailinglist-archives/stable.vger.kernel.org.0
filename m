Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A04F96AE928
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbjCGRVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:21:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbjCGRV0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:21:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B9EA729D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:16:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1BE3B819A4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BFF1C4339B;
        Tue,  7 Mar 2023 17:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209389;
        bh=JhooWYk/J3Y118O0aO4yLRUF+YLG4SyaBxOq+BmC2lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sfWHyxCOV8Yb+vQom1mf/9yjb73Hhtx43b/hjXDAU+W5nwco0CTxx1gL5ex6NBODw
         JsCV5MdTVCwDjfz5+FbQOVdwSeewXE2RwXRhURjJQyDkgmK3rSzePhxXTCytkGSqQB
         JQJM3TdoZrYWKnk3lz08AROPBBroaeJUNQiPAB7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ping-Ke Shih <pkshih@realtek.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0204/1001] wifi: rtw88: Use rtw_iterate_vifs() for rtw_vif_watch_dog_iter()
Date:   Tue,  7 Mar 2023 17:49:36 +0100
Message-Id: <20230307170030.748301451@linuxfoundation.org>
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

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 313f6dc7c5ed723d0c5691553eff4c0090f16bb8 ]

USB and (upcoming) SDIO support may sleep in the read/write handlers.
Make rtw_watch_dog_work() use rtw_iterate_vifs() to prevent "scheduling
while atomic" or "Voluntary context switch within RCU read-side
critical section!" warnings when accessing the registers using an SDIO
card (which is where this issue has been spotted in the real world but
it also affects USB cards).

Fixes: 78d5bf925f30 ("wifi: rtw88: iterate over vif/sta list non-atomically")
Suggested-by: Ping-Ke Shih <pkshih@realtek.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230108211324.442823-3-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 888427cf3bdf9..b2e78737bd5d0 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -241,8 +241,10 @@ static void rtw_watch_dog_work(struct work_struct *work)
 	rtw_phy_dynamic_mechanism(rtwdev);
 
 	data.rtwdev = rtwdev;
-	/* use atomic version to avoid taking local->iflist_mtx mutex */
-	rtw_iterate_vifs_atomic(rtwdev, rtw_vif_watch_dog_iter, &data);
+	/* rtw_iterate_vifs internally uses an atomic iterator which is needed
+	 * to avoid taking local->iflist_mtx mutex
+	 */
+	rtw_iterate_vifs(rtwdev, rtw_vif_watch_dog_iter, &data);
 
 	/* fw supports only one station associated to enter lps, if there are
 	 * more than two stations associated to the AP, then we can not enter
-- 
2.39.2



