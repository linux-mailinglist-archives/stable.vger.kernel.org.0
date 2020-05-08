Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9861CAAC7
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgEHMgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:36:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727891AbgEHMgr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:36:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9C5421582;
        Fri,  8 May 2020 12:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941407;
        bh=Rb1GDpdprDpq6RwZL0rYnYTGS4DnZIANwENFzzhhGfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gX6JjXOx7+T4bMITMp4XiwOD2Q/D8J6eOCa6yA23L7mj9GTwa4t3KGGMo6xlvMeo9
         BVtvK5YJAuoWQ9yvP3Ir1UqERXNS4KzbooN4MZ1bHXuXWrns8vjamsgTdnpZrZ+Q1A
         6675TCHsJexgKNtgQ1wD/LazYHbQ/4UUsYyh0skk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 004/312] staging: rtl8192u: Fix crash due to pointers being "confusing"
Date:   Fri,  8 May 2020 14:29:55 +0200
Message-Id: <20200508123124.853211565@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

commit c3f463484bdd0acd15abd5f92399041f79592d06 upstream.

There's no net_device stashed in skb->cb, there's a net_device * there.

To make it *really* clear, also change the write of the dev pointer
into skb->cb from a memcpy() to an assignment.

Fixes: 3fe563249374 ("staging: rtl8192u: r8192U_core.c: Cleaning up ...")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8192u/r8192U_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -1050,7 +1050,7 @@ static void rtl8192_hard_data_xmit(struc
 
 	spin_lock_irqsave(&priv->tx_lock, flags);
 
-	memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
+	*(struct net_device **)(skb->cb) = dev;
 	tcb_desc->bTxEnableFwCalcDur = 1;
 	skb_push(skb, priv->ieee80211->tx_headroom);
 	ret = rtl8192_tx(dev, skb);
@@ -1092,7 +1092,7 @@ static int rtl8192_hard_start_xmit(struc
 static void rtl8192_tx_isr(struct urb *tx_urb)
 {
 	struct sk_buff *skb = (struct sk_buff *)tx_urb->context;
-	struct net_device *dev = (struct net_device *)(skb->cb);
+	struct net_device *dev = *(struct net_device **)(skb->cb);
 	struct r8192_priv *priv = NULL;
 	cb_desc *tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 	u8  queue_index = tcb_desc->queue_index;


