Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379065493C5
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379298AbiFMN5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380316AbiFMNyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:54:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7252F12A8D;
        Mon, 13 Jun 2022 04:34:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E15C612AC;
        Mon, 13 Jun 2022 11:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E87C34114;
        Mon, 13 Jun 2022 11:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120082;
        bh=pxMSMF/hF72JQ4c3POFMv6XIIGFKrqfTwgmbPp1Ct7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uUccKuEIngc+0e8ukdw1yH+rPq+F1pS/eMbqptMuNlcIXak54OqXwu2UbSvT1eDvK
         2AWO2VVf4+rwe0neUZurZxPvMdTrekGepc2urEGKiS71NWJodJbfKq7UdqeZH0bK8u
         g31ZDV17enokBmG2tx+LtXavRY0RNFqjLqEuWRSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 228/339] drivers: staging: rtl8192bs: Fix deadlock in rtw_joinbss_event_prehandle()
Date:   Mon, 13 Jun 2022 12:10:53 +0200
Message-Id: <20220613094933.574830150@linuxfoundation.org>
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

[ Upstream commit 041879b12ddb0c6c83ed9c0bdd10dc82a056f2fc ]

There is a deadlock in rtw_joinbss_event_prehandle(), which is shown
below:

   (Thread 1)                |      (Thread 2)
                             | _set_timer()
rtw_joinbss_event_prehandle()|  mod_timer()
 spin_lock_bh() //(1)        |  (wait a time)
 ...                         | _rtw_join_timeout_handler()
 del_timer_sync()            |  spin_lock_bh() //(2)
 (wait timer to stop)        |  ...

We hold pmlmepriv->lock in position (1) of thread 1 and
use del_timer_sync() to wait timer to stop, but timer handler
also need pmlmepriv->lock in position (2) of thread 2.
As a result, rtw_joinbss_event_prehandle() will block forever.

This patch extracts del_timer_sync() from the protection of
spin_lock_bh(), which could let timer handler to obtain
the needed lock. What`s more, we change spin_lock_bh() to
spin_lock_irq() in _rtw_join_timeout_handler() in order to
prevent deadlock.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20220409064953.67420-1-duoming@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_mlme.c b/drivers/staging/rtl8723bs/core/rtw_mlme.c
index 62f140985e3f..24d6af886f72 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -1240,8 +1240,10 @@ void rtw_joinbss_event_prehandle(struct adapter *adapter, u8 *pbuf)
 
 			spin_unlock_bh(&pmlmepriv->scanned_queue.lock);
 
+			spin_unlock_bh(&pmlmepriv->lock);
 			/* s5. Cancel assoc_timer */
 			del_timer_sync(&pmlmepriv->assoc_timer);
+			spin_lock_bh(&pmlmepriv->lock);
 		} else {
 			spin_unlock_bh(&(pmlmepriv->scanned_queue.lock));
 		}
@@ -1547,7 +1549,7 @@ void _rtw_join_timeout_handler(struct timer_list *t)
 	if (adapter->bDriverStopped || adapter->bSurpriseRemoved)
 		return;
 
-	spin_lock_bh(&pmlmepriv->lock);
+	spin_lock_irq(&pmlmepriv->lock);
 
 	if (rtw_to_roam(adapter) > 0) { /* join timeout caused by roaming */
 		while (1) {
@@ -1575,7 +1577,7 @@ void _rtw_join_timeout_handler(struct timer_list *t)
 
 	}
 
-	spin_unlock_bh(&pmlmepriv->lock);
+	spin_unlock_irq(&pmlmepriv->lock);
 }
 
 /*
-- 
2.35.1



