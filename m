Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAFE2C0B66
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732492AbgKWNYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:24:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:46104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731362AbgKWMe2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:34:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB9FB2158C;
        Mon, 23 Nov 2020 12:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134868;
        bh=qpZ4lN0hI29YLGGVP7/sOvtZ9R2wZvrWzs9gOJOWnik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nyX0zbiJstML6p4JSuvBpi6kPE4W7xp3lQwWjFX0DhD2VRo8ZZHzgOTIExXp93Gdc
         Dl3XHW+XjrY5QJE++7vqyTppSZdGTiv59A5QgzURxk0xAC62vfhdpVWpJ26wommDST
         1Qytp5xKFqjzLitFsEwWnDhwaSCb8InTkcjLQpEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 002/158] atm: nicstar: Unmap DMA on send error
Date:   Mon, 23 Nov 2020 13:20:30 +0100
Message-Id: <20201123121820.068322068@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 6dceaa9f56e22d0f9b4c4ad2ed9e04e315ce7fe5 ]

The `skb' is mapped for DMA in ns_send() but does not unmap DMA in case
push_scqe() fails to submit the `skb'. The memory of the `skb' is
released so only the DMA mapping is leaking.

Unmap the DMA mapping in case push_scqe() failed.

Fixes: 864a3ff635fa7 ("atm: [nicstar] remove virt_to_bus() and support 64-bit platforms")
Cc: Chas Williams <3chas3@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/atm/nicstar.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -1706,6 +1706,8 @@ static int ns_send(struct atm_vcc *vcc,
 
 	if (push_scqe(card, vc, scq, &scqe, skb) != 0) {
 		atomic_inc(&vcc->stats->tx_err);
+		dma_unmap_single(&card->pcidev->dev, NS_PRV_DMA(skb), skb->len,
+				 DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
 		return -EIO;
 	}


