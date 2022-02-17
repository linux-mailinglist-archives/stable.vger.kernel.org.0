Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55EC4B9546
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 02:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiBQBOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 20:14:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiBQBOV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 20:14:21 -0500
X-Greylist: delayed 90 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 16 Feb 2022 17:14:07 PST
Received: from p-impout004.msg.pkvw.co.charter.net (p-impout004aa.msg.pkvw.co.charter.net [47.43.26.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBEA28D3BF;
        Wed, 16 Feb 2022 17:14:07 -0800 (PST)
Received: from localhost.localdomain ([24.31.246.181])
        by cmsmtp with ESMTP
        id KVLXn2oSOgPEBKVLXn2hGC; Thu, 17 Feb 2022 01:12:36 +0000
X-Authority-Analysis: v=2.4 cv=b8OhX/Kx c=1 sm=1 tr=0 ts=620da104
 a=cAe/7qmlxnd6JlJqP68I9A==:117 a=cAe/7qmlxnd6JlJqP68I9A==:17 a=pGLkceISAAAA:8
 a=VwQbUJbxAAAA:8 a=stkexhm8AAAA:8 a=yQdBAQUQAAAA:8 a=WxT-y_wQJvY9aPZTOZ4A:9
 a=AjGcO6oz07-iQ99wixmX:22 a=pIW3pCRaVxJDc-hWtpF8:22 a=SzazLyfi1tnkUD6oumHU:22
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@kernel.org
Cc:     linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Maxim Klimenko Sergievich <klimenkomaximsergievich@gmail.com>,
        stable@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] cfg80211: Fix spamming of logs when number of scan results is limited
Date:   Wed, 16 Feb 2022 19:12:26 -0600
Message-Id: <20220217011226.31579-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfOLg9OXvNgV7KQF0jaFcyUzNLX8d6dL94QAq5MAIfydhyKI1qL/V48TpdysqxYv74LL47nONfqFyeC9GRVdSmJmeE5SQlfxftmqnvSnvKMccmz990GYO
 UbaUZEvn7r6h/HGaVEVCGaSiKFriAb0K4RnvdYiB/gw+Lpez6NAuwTpKDZ1g676QjZdGbWEt63GXvBsuZTouV3+5HUhQp4FNkZEULjZX3bswKxTVXp5sWCS+
 lpZwoC/HYzRJeL4NZA9J5P/zyiPqRVQPrWOulnSmszTP8IvWimbT62LdcSSgX1kmqDTmqgH2S/8fUoIKRVvyXfNSmcmYNdQwTxgKHFb4jxUrRdWwbBqGClcY
 6zCqMJ7MKb7VK2hoipiLgPdhSZ4fFeSHQZyMKh9ZdmpOFZWyTzrjww9u7yED4Esr5M4j+l3r
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the cfg80211 option "bss_entries_limit" is set to 1, routine
cfg80211_bss_expire_oldest() fails by issuing repeated warnings.
The problem could also occur in the unlikely event that a scan only finds
a single SSID. In the first case, the warning is avoided by testing for
the special ivalue for the option before scanning for the oldest entry.
The second case is handled by converting the WARN_ON() to a WARN_ON_ONCE().
These changes fix commit 9853a55ef1bb ("cfg80211: limit scan results cache
size").

Reported-by: Maxim Klimenko Sergievich <klimenkomaximsergievich@gmail.com>
Fixes: 9853a55ef1bb ("cfg80211: limit scan results cache size").
Cc: stable@vger.kernel.org # 4.9+
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 net/wireless/scan.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 22e92be61938..d7aa38445fe6 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -463,6 +463,12 @@ static bool cfg80211_bss_expire_oldest(struct cfg80211_registered_device *rdev)
 
 	lockdep_assert_held(&rdev->bss_lock);
 
+	/* If the user has set cfg80211 option bss_entries_limit to 1,
+	 * there cannot be an oldest BSS. Skip the scan.
+	 */
+	if (unlikely(rdev->bss_entries == 1))
+		return false;
+
 	list_for_each_entry(bss, &rdev->bss_list, list) {
 		if (atomic_read(&bss->hold))
 			continue;
@@ -476,7 +482,7 @@ static bool cfg80211_bss_expire_oldest(struct cfg80211_registered_device *rdev)
 		oldest = bss;
 	}
 
-	if (WARN_ON(!oldest))
+	if (WARN_ON_ONCE(!oldest))
 		return false;
 
 	/*
-- 
2.35.1

