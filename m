Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0F514E259
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730900AbgA3Sov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:44:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730898AbgA3Sou (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:44:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 993092082E;
        Thu, 30 Jan 2020 18:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409890;
        bh=saXXOSjiRFcl+smuaMC7M+4L6SdqpELGKqVjGPcAly4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BE72rARjiA5Vm5AYvEZuEMi+o1em0RDEzCoGQeDgayJ1lsL6aDHyQ83etQWE6I8I9
         X889iI7KoIWls/TeKdTdqYifXpZktUvHVHZmEvxRwYV88HDBtz7BUkxmTLlYVXy+E3
         jgKAokmxJC+ZhJFLsaQ1+44IXS2trCUEhFi2lKvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 073/110] atm: eni: fix uninitialized variable warning
Date:   Thu, 30 Jan 2020 19:38:49 +0100
Message-Id: <20200130183623.066069730@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
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
index b23d1e4bad33b..9d0d65efcd94e 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -374,7 +374,7 @@ static int do_rx_dma(struct atm_vcc *vcc,struct sk_buff *skb,
 		here = (eni_vcc->descr+skip) & (eni_vcc->words-1);
 		dma[j++] = (here << MID_DMA_COUNT_SHIFT) | (vcc->vci
 		    << MID_DMA_VCI_SHIFT) | MID_DT_JK;
-		j++;
+		dma[j++] = 0;
 	}
 	here = (eni_vcc->descr+size+skip) & (eni_vcc->words-1);
 	if (!eff) size += skip;
@@ -447,7 +447,7 @@ static int do_rx_dma(struct atm_vcc *vcc,struct sk_buff *skb,
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



