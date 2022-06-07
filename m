Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A131C540B0F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352933AbiFGSWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348852AbiFGSSW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:18:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EB8E7338;
        Tue,  7 Jun 2022 10:53:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3810617B4;
        Tue,  7 Jun 2022 17:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B11C3411C;
        Tue,  7 Jun 2022 17:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624399;
        bh=uTEg04H4UeGHZAZVp/bvD+TiVLWrnnrWSihosKeUwgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lX44tFINdJ2lymCOoYvcn+SSB+E3eUzw8spPZFs6CRid5+KuTHS1zXUf0Pf0qQt7h
         5HQ/eeq7nsyVPJS9xgZOLY2jRiIvDx1RI9+hPOSyWSImVvxOMmz7iMm6z5xDnBJBlH
         URiyV6emQ1FFRdpXFdVbQFKlnD8gw9++53NLDWdHV/fpOR7yVfXGoM7HJaxNE/2Muv
         tC9VxETdimk/CH6GottScPP/xHcmQaPBpOdC/HtOGp800O2j5SCv8h1KWCg2Pf28Jx
         9d40bYW7iOE0jYO9xdgZydbV5ulBM5DmHoTmgH9z4NCMTkIB3r6B3uBeOIs7Qpw91H
         isWZm3OJnZUmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, fabioaiuto83@gmail.com,
        hdegoede@redhat.com, sevinj.aghayeva@gmail.com,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.17 05/60] drivers: staging: rtl8723bs: Fix deadlock in rtw_surveydone_event_callback()
Date:   Tue,  7 Jun 2022 13:52:02 -0400
Message-Id: <20220607175259.478835-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175259.478835-1-sashal@kernel.org>
References: <20220607175259.478835-1-sashal@kernel.org>
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

[ Upstream commit cc7ad0d77b51c872d629bcd98aea463a3c4109e7 ]

There is a deadlock in rtw_surveydone_event_callback(),
which is shown below:

   (Thread 1)                  |      (Thread 2)
                               | _set_timer()
rtw_surveydone_event_callback()|  mod_timer()
 spin_lock_bh() //(1)          |  (wait a time)
 ...                           | rtw_scan_timeout_handler()
 del_timer_sync()              |  spin_lock_bh() //(2)
 (wait timer to stop)          |  ...

We hold pmlmepriv->lock in position (1) of thread 1 and use
del_timer_sync() to wait timer to stop, but timer handler
also need pmlmepriv->lock in position (2) of thread 2.
As a result, rtw_surveydone_event_callback() will block forever.

This patch extracts del_timer_sync() from the protection of
spin_lock_bh(), which could let timer handler to obtain
the needed lock. What`s more, we change spin_lock_bh() in
rtw_scan_timeout_handler() to spin_lock_irq(). Otherwise,
spin_lock_bh() will also cause deadlock() in timer handler.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20220409061836.60529-1-duoming@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_mlme.c b/drivers/staging/rtl8723bs/core/rtw_mlme.c
index 9202223ebc0c..a6e5f2332e12 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -751,7 +751,9 @@ void rtw_surveydone_event_callback(struct adapter	*adapter, u8 *pbuf)
 	}
 
 	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY)) {
+		spin_unlock_bh(&pmlmepriv->lock);
 		del_timer_sync(&pmlmepriv->scan_to_timer);
+		spin_lock_bh(&pmlmepriv->lock);
 		_clr_fwstate_(pmlmepriv, _FW_UNDER_SURVEY);
 	}
 
@@ -1586,11 +1588,11 @@ void rtw_scan_timeout_handler(struct timer_list *t)
 						  mlmepriv.scan_to_timer);
 	struct	mlme_priv *pmlmepriv = &adapter->mlmepriv;
 
-	spin_lock_bh(&pmlmepriv->lock);
+	spin_lock_irq(&pmlmepriv->lock);
 
 	_clr_fwstate_(pmlmepriv, _FW_UNDER_SURVEY);
 
-	spin_unlock_bh(&pmlmepriv->lock);
+	spin_unlock_irq(&pmlmepriv->lock);
 
 	rtw_indicate_scan_done(adapter, true);
 }
-- 
2.35.1

