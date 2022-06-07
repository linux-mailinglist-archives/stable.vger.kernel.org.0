Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 494F3540BFE
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352085AbiFGSdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352544AbiFGSbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:31:04 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC81144FD3;
        Tue,  7 Jun 2022 10:56:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E34EECE242A;
        Tue,  7 Jun 2022 17:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7C4C3411C;
        Tue,  7 Jun 2022 17:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624583;
        bh=BqpPVKGOyzA+uqnI406r2teKN9d313jC11ZUQ6CBH3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=keOX2bxHfI7M1CE9oJe1C2VL6HveflnoRMIcXPXBD2DInzr52lg8/1IhxvzluP6p7
         LcekVkbPJfviPfxvMlgSlG8q/tze6QltckONe2O0fa9tVPxl/zjYnAsYVoW77t1ko0
         uFIuLq6TwNE9Duvj2Hujb2/MbcwZiceFTwZdFVMgz5iii5z/KMylHPv/blF8rI8D0s
         jzr4VqP/Nv+ZuP7Rt4wrjCgNVhMvhqEEdtOTaltr3FTgwgsIEOVQxIlGy/DtggDaGg
         ZNSleZNvbM7YRvFVU/3zRXl2LwAMayR8PlHlLSmqENGbXwbhyCVq7twykphHkTWdi/
         GTHE3qrlRp1aA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, fabioaiuto83@gmail.com,
        hdegoede@redhat.com, sevinj.aghayeva@gmail.com,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 06/51] drivers: staging: rtl8192bs: Fix deadlock in rtw_joinbss_event_prehandle()
Date:   Tue,  7 Jun 2022 13:55:05 -0400
Message-Id: <20220607175552.479948-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175552.479948-1-sashal@kernel.org>
References: <20220607175552.479948-1-sashal@kernel.org>
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
index 2c20bf26b10e..952c3e14d1b3 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -1238,8 +1238,10 @@ void rtw_joinbss_event_prehandle(struct adapter *adapter, u8 *pbuf)
 
 			spin_unlock_bh(&pmlmepriv->scanned_queue.lock);
 
+			spin_unlock_bh(&pmlmepriv->lock);
 			/* s5. Cancel assoc_timer */
 			del_timer_sync(&pmlmepriv->assoc_timer);
+			spin_lock_bh(&pmlmepriv->lock);
 		} else {
 			spin_unlock_bh(&(pmlmepriv->scanned_queue.lock));
 		}
@@ -1545,7 +1547,7 @@ void _rtw_join_timeout_handler(struct timer_list *t)
 	if (adapter->bDriverStopped || adapter->bSurpriseRemoved)
 		return;
 
-	spin_lock_bh(&pmlmepriv->lock);
+	spin_lock_irq(&pmlmepriv->lock);
 
 	if (rtw_to_roam(adapter) > 0) { /* join timeout caused by roaming */
 		while (1) {
@@ -1573,7 +1575,7 @@ void _rtw_join_timeout_handler(struct timer_list *t)
 
 	}
 
-	spin_unlock_bh(&pmlmepriv->lock);
+	spin_unlock_irq(&pmlmepriv->lock);
 }
 
 /*
-- 
2.35.1

