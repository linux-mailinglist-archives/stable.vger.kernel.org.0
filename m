Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6B8AACD94
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbfIHMvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:51:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732443AbfIHMvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:51:05 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 317E420863;
        Sun,  8 Sep 2019 12:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947063;
        bh=aRAbFHpRb2erDfCo+7+WNnl1jZnuKdO2GYEvustH5XM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gfLNFwX0WOilUtWKB9nYBJGbZiIU9kuafnhf7tId/NhooiMoKCjEW7o8PwdNMp3x4
         fXpVXIrmFECXI0NrCiC/ugkJSxStUXGi4WFij6vO6MJnGrzrvGFp1E4Y25InKWieI9
         f+fFkQcPXL93hpPOpnKmk7EnBVy75LOKSWeSX/bU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 10/94] Revert "r8152: napi hangup fix after disconnect"
Date:   Sun,  8 Sep 2019 13:41:06 +0100
Message-Id: <20190908121150.726876315@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>

[ Upstream commit 49d4b14113cae1410eb4654ada5b9583bad971c4 ]

This reverts commit 0ee1f4734967af8321ecebaf9c74221ace34f2d5.

The commit 0ee1f4734967 ("r8152: napi hangup fix after
disconnect") adds a check about RTL8152_UNPLUG to determine
if calling napi_disable() is invalid in rtl8152_close(),
when rtl8152_disconnect() is called. This avoids to use
napi_disable() after calling netif_napi_del().

Howver, commit ffa9fec30ca0 ("r8152: set RTL8152_UNPLUG
only for real disconnection") causes that RTL8152_UNPLUG
is not always set when calling rtl8152_disconnect().
Therefore, I have to revert commit 0ee1f4734967 ("r8152:
napi hangup fix after disconnect"), first. And submit
another patch to fix it.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/r8152.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3987,8 +3987,7 @@ static int rtl8152_close(struct net_devi
 #ifdef CONFIG_PM_SLEEP
 	unregister_pm_notifier(&tp->pm_notifier);
 #endif
-	if (!test_bit(RTL8152_UNPLUG, &tp->flags))
-		napi_disable(&tp->napi);
+	napi_disable(&tp->napi);
 	clear_bit(WORK_ENABLE, &tp->flags);
 	usb_kill_urb(tp->intr_urb);
 	cancel_delayed_work_sync(&tp->schedule);


