Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30E5419B8A
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236697AbhI0RUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:20:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237170AbhI0RRy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:17:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA0F26139D;
        Mon, 27 Sep 2021 17:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762731;
        bh=9QA+X0F6UwdUy5WYqhUxyWvqZLL76OoYjh5K0cD0d1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=osd250ngvkGsThhDVh7gcQbFdGdlL7PbhDKUCHzD2pBe2e+gGeHW+BhfrUpSXL/mr
         iUGMmgSAfdv5JzVs47kTQlNtXmDuOeodv/PSyd3/H1TAWrfECHSSTAaSUIOan9q268
         facovntqW7mO6wvhEUwkPEl+6XNvyldF9h18TeHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 5.14 031/162] misc: genwqe: Fixes DMA mask setting
Date:   Mon, 27 Sep 2021 19:01:17 +0200
Message-Id: <20210927170234.555086902@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 8d753db5c227d1f403c4bc9cae4ae02c862413cd upstream.

Commit 505b08777d78 ("misc: genwqe: Use dma_set_mask_and_coherent to simplify code")
changed the logic in the code.

Instead of a ||, a && should have been used to keep the code the same.

Fixes: 505b08777d78 ("misc: genwqe: Use dma_set_mask_and_coherent to simplify code")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/be49835baa8ba6daba5813b399edf6300f7fdbda.1631130862.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/genwqe/card_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/genwqe/card_base.c
+++ b/drivers/misc/genwqe/card_base.c
@@ -1090,7 +1090,7 @@ static int genwqe_pci_setup(struct genwq
 
 	/* check for 64-bit DMA address supported (DAC) */
 	/* check for 32-bit DMA address supported (SAC) */
-	if (dma_set_mask_and_coherent(&pci_dev->dev, DMA_BIT_MASK(64)) ||
+	if (dma_set_mask_and_coherent(&pci_dev->dev, DMA_BIT_MASK(64)) &&
 	    dma_set_mask_and_coherent(&pci_dev->dev, DMA_BIT_MASK(32))) {
 		dev_err(&pci_dev->dev,
 			"err: neither DMA32 nor DMA64 supported\n");


