Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF763ED5DE
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239123AbhHPNPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:15:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239604AbhHPNOc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:14:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3FB0632A2;
        Mon, 16 Aug 2021 13:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119475;
        bh=xWHx/EOAscR3etXZqIA2GxRKfnPuBGdPN7geStoKCLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X7+mau9lEKijKYs0/K7P3DO7xclOfRO/IHdz/fVNLIPxCaZMCfrABitOMh34TiClk
         RqnGty4AWIf62AyNI06xEvUWvYDQCpHWQMSnnJd5qa3abaHXCdgQQYLUM4KR9Pi//w
         dr+TDMLzzFJqS4cchUqVnlQkFyUHY1mP8A1U+M+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Perrot <thomas.perrot@bootlin.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 023/151] net: wwan: mhi_wwan_ctrl: Fix possible deadlock
Date:   Mon, 16 Aug 2021 15:00:53 +0200
Message-Id: <20210816125444.832318357@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

commit 34737e1320db6d51f0d140d5c684b9eb32f0da76 upstream.

Lockdep detected possible interrupt unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&mhiwwan->rx_lock);
                               local_irq_disable();
                               lock(&mhi_cntrl->pm_lock);
                               lock(&mhiwwan->rx_lock);
   <Interrupt>
     lock(&mhi_cntrl->pm_lock);

  *** DEADLOCK ***

To prevent this we need to disable the soft-interrupts when taking
the rx_lock.

Cc: stable@vger.kernel.org
Fixes: fa588eba632d ("net: Add Qcom WWAN control driver")
Reported-by: Thomas Perrot <thomas.perrot@bootlin.com>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wwan/mhi_wwan_ctrl.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/wwan/mhi_wwan_ctrl.c
+++ b/drivers/net/wwan/mhi_wwan_ctrl.c
@@ -41,14 +41,14 @@ struct mhi_wwan_dev {
 /* Increment RX budget and schedule RX refill if necessary */
 static void mhi_wwan_rx_budget_inc(struct mhi_wwan_dev *mhiwwan)
 {
-	spin_lock(&mhiwwan->rx_lock);
+	spin_lock_bh(&mhiwwan->rx_lock);
 
 	mhiwwan->rx_budget++;
 
 	if (test_bit(MHI_WWAN_RX_REFILL, &mhiwwan->flags))
 		schedule_work(&mhiwwan->rx_refill);
 
-	spin_unlock(&mhiwwan->rx_lock);
+	spin_unlock_bh(&mhiwwan->rx_lock);
 }
 
 /* Decrement RX budget if non-zero and return true on success */
@@ -56,7 +56,7 @@ static bool mhi_wwan_rx_budget_dec(struc
 {
 	bool ret = false;
 
-	spin_lock(&mhiwwan->rx_lock);
+	spin_lock_bh(&mhiwwan->rx_lock);
 
 	if (mhiwwan->rx_budget) {
 		mhiwwan->rx_budget--;
@@ -64,7 +64,7 @@ static bool mhi_wwan_rx_budget_dec(struc
 			ret = true;
 	}
 
-	spin_unlock(&mhiwwan->rx_lock);
+	spin_unlock_bh(&mhiwwan->rx_lock);
 
 	return ret;
 }
@@ -130,9 +130,9 @@ static void mhi_wwan_ctrl_stop(struct ww
 {
 	struct mhi_wwan_dev *mhiwwan = wwan_port_get_drvdata(port);
 
-	spin_lock(&mhiwwan->rx_lock);
+	spin_lock_bh(&mhiwwan->rx_lock);
 	clear_bit(MHI_WWAN_RX_REFILL, &mhiwwan->flags);
-	spin_unlock(&mhiwwan->rx_lock);
+	spin_unlock_bh(&mhiwwan->rx_lock);
 
 	cancel_work_sync(&mhiwwan->rx_refill);
 


