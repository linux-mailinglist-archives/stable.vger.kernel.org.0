Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F6E540BFF
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352072AbiFGSdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352493AbiFGSbC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:31:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290ED17B879;
        Tue,  7 Jun 2022 10:56:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80454B82370;
        Tue,  7 Jun 2022 17:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300E8C3411C;
        Tue,  7 Jun 2022 17:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624578;
        bh=UZ5Dc/FfKOsM7z4voa90CsZSNexUen7lsXLITcFOEA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UN62sF+mpPPJ42eqCkhdV3XEPvr39T08XBLBUgiKCtFQlfN02PUyb9Zqzn3XhfpLS
         MQAljBPlMhi/T0ptZOcxZ2hDnJTQRGwfw4tv0LYgP8xsyw7JHbmCQRYVJFfIpJpDq5
         cxp8M8u+KUY+8DuTLlsKlwcvnjt2/4P+5wkBkuqwvgrsUkvzfQzvxgBKmPo8EsxN5e
         n8QkAM53gJKwpirA4rt15ow7hNZ5oA+MuLYQfVbTmsocT6LS9g1Y0EtRs1GJvk5a0/
         y5mTPTfI4+bDPeO9PWxMjq+oND6agEGOWrYZqdszVr8Th18mks7qklO9IUyZ3Hzlsy
         6+iYkFOp5ovZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, fabioaiuto83@gmail.com,
        hdegoede@redhat.com, sevinj.aghayeva@gmail.com,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 05/51] drivers: staging: rtl8723bs: Fix deadlock in rtw_surveydone_event_callback()
Date:   Tue,  7 Jun 2022 13:55:04 -0400
Message-Id: <20220607175552.479948-5-sashal@kernel.org>
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
index cf79bec916c5..2c20bf26b10e 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -749,7 +749,9 @@ void rtw_surveydone_event_callback(struct adapter	*adapter, u8 *pbuf)
 	}
 
 	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY)) {
+		spin_unlock_bh(&pmlmepriv->lock);
 		del_timer_sync(&pmlmepriv->scan_to_timer);
+		spin_lock_bh(&pmlmepriv->lock);
 		_clr_fwstate_(pmlmepriv, _FW_UNDER_SURVEY);
 	}
 
@@ -1584,11 +1586,11 @@ void rtw_scan_timeout_handler(struct timer_list *t)
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

