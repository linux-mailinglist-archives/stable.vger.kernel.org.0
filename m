Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC102C064F
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730634AbgKWM3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:29:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:40170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730615AbgKWM3j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:29:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAFDD2076E;
        Mon, 23 Nov 2020 12:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134577;
        bh=N+6/AxSR7d/JMxdSO1626shlY+dXERHa/WwSQepdL3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xe5w9bLOqAPgAstjSoCGY/lptkMPzVymt7aZuIVAEmTTOkxQkhdwdOuby7YKonzy/
         vNFeQ7kGcTw9idQI4VA84U5y9jV5KrFVSPF+GQRmUgi/LO7g47+7vWTzAGy8wb5oYL
         5LboxIaFoPB/K/fnor7a/8uA1AxId5Sk0XRv80VE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 02/91] atm: nicstar: Unmap DMA on send error
Date:   Mon, 23 Nov 2020 13:21:22 +0100
Message-Id: <20201123121809.413379627@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
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
@@ -1705,6 +1705,8 @@ static int ns_send(struct atm_vcc *vcc,
 
 	if (push_scqe(card, vc, scq, &scqe, skb) != 0) {
 		atomic_inc(&vcc->stats->tx_err);
+		dma_unmap_single(&card->pcidev->dev, NS_PRV_DMA(skb), skb->len,
+				 DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
 		return -EIO;
 	}


