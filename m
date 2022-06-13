Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A02548CEF
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380450AbiFMN66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380214AbiFMNxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:53:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D91195B7;
        Mon, 13 Jun 2022 04:34:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C866BB80D3A;
        Mon, 13 Jun 2022 11:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A648C34114;
        Mon, 13 Jun 2022 11:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120050;
        bh=ux7IuVmMI8o15RzsRZcZNkGPWCqiFNkdIdCURxZuwdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D8jWVwijJgjEUFkwXRTlq0W6/KENINGVpDpfBibcmqFjAXHjPLc0j8CjFsCijHhkq
         75OzkJbaeQqjYRQRnBUqMlqwevC39IP1vQ7rTA61PFWUtg4RfrPavFSdtvvCtudj71
         ZRIZBtWwAInj0JCSyIkzkH628ac0MWcV+kGqkp4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 233/339] drivers: staging: rtl8192u: Fix deadlock in ieee80211_beacons_stop()
Date:   Mon, 13 Jun 2022 12:10:58 +0200
Message-Id: <20220613094933.726247811@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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
index 1a43979939a8..79f3fbe25556 100644
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



