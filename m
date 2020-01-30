Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1120114E1F8
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731485AbgA3SsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:48:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:58894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731480AbgA3SsG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:48:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A583215A4;
        Thu, 30 Jan 2020 18:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410084;
        bh=y/PLv26yGwlsfXVOGfnKuilRTFiRg/vyFfTi8gAvHtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w3SUsjq5TlNyoxTlGpANgLG8LQaTlxDbPjjFM1YbLaCXh9k1zvDXNzLpwVtmg/UC1
         j3r4VRjJVtgZcpJidkL/5a1CAiVJc4eYFg8x8zXfDwPsJsZRKH+Vxx4sCq1SN0OK/i
         iSv6PgHBc7mRlL9rTOjiOxH416d85z8vA2g1YOJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/55] atm: eni: fix uninitialized variable warning
Date:   Thu, 30 Jan 2020 19:39:20 +0100
Message-Id: <20200130183615.555864002@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.563083888@linuxfoundation.org>
References: <20200130183608.563083888@linuxfoundation.org>
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
index 6470e3c4c9907..7323e9210f4b1 100644
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



