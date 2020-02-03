Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C84B7150B30
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgBCQZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:25:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:36128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728369AbgBCQZ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:25:27 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E83CF2080C;
        Mon,  3 Feb 2020 16:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747126;
        bh=nw/hVCP0XHwKDzSIO9/aKG8wnxIhazCth+jmXZt3mqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oZTHFTSbkPaWTrLiZ/VxWgus1AHnNT/0XCvoTxR/Zldxr+CrsvqMkHRk7eE6M3bkq
         CvrzlD8WsF2lsVunHvLAmApaHgeF/WiNLo9ss85b0XD8XaVySrjgFJsIx8CriPyju5
         zdK0kk7gdW3zNNOpNCG5XCExJxPyGtHf70BObvTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 22/68] atm: eni: fix uninitialized variable warning
Date:   Mon,  3 Feb 2020 16:19:18 +0000
Message-Id: <20200203161908.764213941@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161904.705434837@linuxfoundation.org>
References: <20200203161904.705434837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 30780d086a83332adcd9362281201cee7c3d9d19 ]

With -O3, gcc has found an actual unintialized variable stored
into an mmio register in two instances:

drivers/atm/eni.c: In function 'discard':
drivers/atm/eni.c:465:13: error: 'dma[1]' is used uninitialized in this function [-Werror=uninitialized]
   writel(dma[i*2+1],eni_dev->rx_dma+dma_wr*8+4);
             ^
drivers/atm/eni.c:465:13: error: 'dma[3]' is used uninitialized in this function [-Werror=uninitialized]

Change the code to always write zeroes instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/eni.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index 40c2d561417bd..88819409e0beb 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -372,7 +372,7 @@ static int do_rx_dma(struct atm_vcc *vcc,struct sk_buff *skb,
 		here = (eni_vcc->descr+skip) & (eni_vcc->words-1);
 		dma[j++] = (here << MID_DMA_COUNT_SHIFT) | (vcc->vci
 		    << MID_DMA_VCI_SHIFT) | MID_DT_JK;
-		j++;
+		dma[j++] = 0;
 	}
 	here = (eni_vcc->descr+size+skip) & (eni_vcc->words-1);
 	if (!eff) size += skip;
@@ -445,7 +445,7 @@ static int do_rx_dma(struct atm_vcc *vcc,struct sk_buff *skb,
 	if (size != eff) {
 		dma[j++] = (here << MID_DMA_COUNT_SHIFT) |
 		    (vcc->vci << MID_DMA_VCI_SHIFT) | MID_DT_JK;
-		j++;
+		dma[j++] = 0;
 	}
 	if (!j || j > 2*RX_DMA_BUF) {
 		printk(KERN_CRIT DEV_LABEL "!j or j too big!!!\n");
-- 
2.20.1



