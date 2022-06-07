Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEA0540E67
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353183AbiFGSyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354265AbiFGSqv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:46:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB2D118020;
        Tue,  7 Jun 2022 11:00:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2530B61866;
        Tue,  7 Jun 2022 18:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FD9C34115;
        Tue,  7 Jun 2022 18:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624829;
        bh=AFtAHfC/KbuuNV46TdvKwid6qZzeWaijsvBa9IoGvxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8/QWVjUDKuiuAk+GxsrGkLZKrdbswi6dQyxShfIR6pCMskvaFCJMw68zfW/pm9kg
         ASxQC73XQ58Ome2Z+gpTy3HuOrd5dxAVNoZCvEjUL+QSSIHbjm9mfbviBPgauvbKkc
         9njE4CvrCMHeJBBi3cgj2LcwhVHLvY9t44cnL+TWzhNdb8GMP2tkWilIek14U0Ho+/
         elLbn0AyTAId0Kw3UfrLpLihJ1ftGXxRSltrFGMeilL5Uk2sE+X7jM7Kqio6+lU1T+
         8IxOjuE50YxC1KGZWUM6U4ePBWV54jUN44M5P5yhzcQget9PkfIcKHVatW8CGMVLb8
         FlalKNa8pTmrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, baihaowen@meizu.com,
        dave@stgolabs.net, wangborong@cdjrlc.com, len.baker@gmx.com,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.4 06/34] drivers: staging: rtl8192u: Fix deadlock in ieee80211_beacons_stop()
Date:   Tue,  7 Jun 2022 13:59:41 -0400
Message-Id: <20220607180011.481266-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607180011.481266-1-sashal@kernel.org>
References: <20220607180011.481266-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 806c7b53414934ba2a39449b31fd1a038e500273 ]

There is a deadlock in ieee80211_beacons_stop(), which is shown below:

   (Thread 1)              |      (Thread 2)
                           | ieee80211_send_beacon()
ieee80211_beacons_stop()   |  mod_timer()
 spin_lock_irqsave() //(1) |  (wait a time)
 ...                       | ieee80211_send_beacon_cb()
 del_timer_sync()          |  spin_lock_irqsave() //(2)
 (wait timer to stop)      |  ...

We hold ieee->beacon_lock in position (1) of thread 1 and use
del_timer_sync() to wait timer to stop, but timer handler
also need ieee->beacon_lock in position (2) of thread 2.
As a result, ieee80211_beacons_stop() will block forever.

This patch extracts del_timer_sync() from the protection of
spin_lock_irqsave(), which could let timer handler to obtain
the needed lock.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20220417135407.109536-1-duoming@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index 33a6af7aad22..a869694337f7 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -528,9 +528,9 @@ static void ieee80211_beacons_stop(struct ieee80211_device *ieee)
 	spin_lock_irqsave(&ieee->beacon_lock, flags);
 
 	ieee->beacon_txing = 0;
-	del_timer_sync(&ieee->beacon_timer);
 
 	spin_unlock_irqrestore(&ieee->beacon_lock, flags);
+	del_timer_sync(&ieee->beacon_timer);
 }
 
 void ieee80211_stop_send_beacons(struct ieee80211_device *ieee)
-- 
2.35.1

