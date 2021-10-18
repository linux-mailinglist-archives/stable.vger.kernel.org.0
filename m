Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B0F431D6A
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbhJRNvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:51:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233425AbhJRNtV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:49:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8ECC61401;
        Mon, 18 Oct 2021 13:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564241;
        bh=3quSAhr2xHc+Idhx0HOc2U05znd98WQ+JC0kryihbM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=En+pFRq58nC7xH1jOzvCN4JqmXUPTpD8fmLJWu8m7DKhX/mZ7236ooBzQ6VfAzB5I
         kQLR2nFXoa/r9mK40WTgXzaVGO+rJ5pYR+DB4rwvzcwWgoyR3jJgZ0HJUcuqU0fbND
         5wDZE/oMAG0jRKiKvxif6jxyrF+m7rDT8LT8/JSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ville Baillie <villeb@bytesnap.co.uk>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.14 015/151] spi: atmel: Fix PDC transfer setup bug
Date:   Mon, 18 Oct 2021 15:23:14 +0200
Message-Id: <20211018132341.181459931@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Baillie <villeb@bytesnap.co.uk>

commit 75e33c55ae8fb4a177fe07c284665e1d61b02560 upstream.

atmel_spi_dma_map_xfer to never be called in PDC mode. This causes the
driver to silently fail.

This patch changes the conditional to match the behaviour of the
previous commit before the refactor.

Fixes: 5fa5e6dec762 ("spi: atmel: Switch to transfer_one transfer method")
Signed-off-by: Ville Baillie <villeb@bytesnap.co.uk>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210921072132.21831-1-villeb@bytesnap.co.uk
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-atmel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1301,7 +1301,7 @@ static int atmel_spi_one_transfer(struct
 	 * DMA map early, for performance (empties dcache ASAP) and
 	 * better fault reporting.
 	 */
-	if ((!master->cur_msg_mapped)
+	if ((!master->cur_msg->is_dma_mapped)
 		&& as->use_pdc) {
 		if (atmel_spi_dma_map_xfer(as, xfer) < 0)
 			return -ENOMEM;
@@ -1381,7 +1381,7 @@ static int atmel_spi_one_transfer(struct
 		}
 	}
 
-	if (!master->cur_msg_mapped
+	if (!master->cur_msg->is_dma_mapped
 		&& as->use_pdc)
 		atmel_spi_dma_unmap_xfer(master, xfer);
 


