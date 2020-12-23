Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC4B2E1786
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbgLWDK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:10:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:45428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727954AbgLWCSX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29D772333F;
        Wed, 23 Dec 2020 02:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689838;
        bh=Li2v3nG6h5Itz46M6/5dg6HgsN4K2JS77IBpLb3zOzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bzG0aayjQinBqlhixL1F/klMohle7XN8Hi8px1Hhot5ATbL5A1QcBoibaRJ/xvRqO
         qKhiDGSpaufBAvDcuKWHa/BAUO+5Is2O8viZAzvJsfx+q5HPkwnZaC7cA8k2n3WYll
         KejC0fkvH7D/bYAcxGhoIfG7+v5XDCpnNgLxv+vffHV++lBNWFLt4+JKwGyJmNljUw
         p6Eb9p4MvrIKiGobVHcRrVCRL415cC7/rrsceKXaz9x3vmPB/bhYGDyIWscYHHYX3h
         +lBK3gEwl3ySE/rGyp4JJZlNOLnzAbk2tMpoQu9IqR+EsByoMcOlIXRhq4tdQyx1po
         HZFAtX/vCFcig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.10 039/217] staging: rtl8192u: fix wrong judgement in rtl8192_rx_isr
Date:   Tue, 22 Dec 2020 21:13:28 -0500
Message-Id: <20201223021626.2790791-39-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 071dc1787a2f8bb636f864c1f306280deea3b1d5 ]

The 'EPERM' cannot appear in the previous path, we
should use '-EPERM' to check it. For example:

Call trace:
->rtl8192_rx_isr
    ->usb_submit_urb
       ->usb_hcd_submit_urb
           ->rh_urb_enqueue
	       ->rh_queue_status
	           ->usb_hcd_link_urb_to_ep

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201028122648.47959-1-zhangqilong3@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8192u/r8192U_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 27dc181c4c9b6..93676af986290 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -867,7 +867,7 @@ static void rtl8192_rx_isr(struct urb *urb)
 	urb->context = skb;
 	skb_queue_tail(&priv->rx_queue, skb);
 	err = usb_submit_urb(urb, GFP_ATOMIC);
-	if (err && err != EPERM)
+	if (err && err != -EPERM)
 		netdev_err(dev,
 			   "can not submit rxurb, err is %x, URB status is %x\n",
 			   err, urb->status);
-- 
2.27.0

