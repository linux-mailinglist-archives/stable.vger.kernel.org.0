Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C344C2A51EE
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730980AbgKCUpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:45:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:33144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730119AbgKCUpN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:45:13 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6B39223EA;
        Tue,  3 Nov 2020 20:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436312;
        bh=kqDcOyj+tcuk7A4b5KrS9aWFMKow0aK5eT0UyvdUGco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mfH2U/Z3ZMXkKCN0d6Ryu003CJHY81R9iTZhtx3w3b+rcfPOwgv7TP/Rsoy7y1YdO
         Wa1H98jCP/hLyXSriCizP0j0yUwEStfWGc8LeS5AwtlQNevoq/a8OLEtOXxBH6LxJF
         OBdTW5toJkxOXHWoShLVaIdrHki+2EclCTqETLnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuanhong Guo <gch981213@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.9 196/391] spi: spi-mtk-nor: fix timeout calculation overflow
Date:   Tue,  3 Nov 2020 21:34:07 +0100
Message-Id: <20201103203400.118825819@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuanhong Guo <gch981213@gmail.com>

commit 4cafaddedb5fbef9531202ee547784409fd0de33 upstream.

CLK_TO_US macro is used to calculate potential transfer time for various
timeout handling. However it overflows on transfer bigger than 512 bytes
because it first did (len * 8 * 1000000).
This controller typically operates at 45MHz. This patch did 2 things:
1. calculate clock / 1000000 first
2. add a 4M transfer size cap so that the final timeout in DMA reading
   doesn't overflow

Fixes: 881d1ee9fe81f ("spi: add support for mediatek spi-nor controller")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chuanhong Guo <gch981213@gmail.com>
Link: https://lore.kernel.org/r/20200922114905.2942859-1-gch981213@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-mtk-nor.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-mtk-nor.c
+++ b/drivers/spi/spi-mtk-nor.c
@@ -89,7 +89,7 @@
 // Buffered page program can do one 128-byte transfer
 #define MTK_NOR_PP_SIZE			128
 
-#define CLK_TO_US(sp, clkcnt)		((clkcnt) * 1000000 / sp->spi_freq)
+#define CLK_TO_US(sp, clkcnt)		DIV_ROUND_UP(clkcnt, sp->spi_freq / 1000000)
 
 struct mtk_nor {
 	struct spi_controller *ctlr;
@@ -177,6 +177,10 @@ static int mtk_nor_adjust_op_size(struct
 	if ((op->addr.nbytes == 3) || (op->addr.nbytes == 4)) {
 		if ((op->data.dir == SPI_MEM_DATA_IN) &&
 		    mtk_nor_match_read(op)) {
+			// limit size to prevent timeout calculation overflow
+			if (op->data.nbytes > 0x400000)
+				op->data.nbytes = 0x400000;
+
 			if ((op->addr.val & MTK_NOR_DMA_ALIGN_MASK) ||
 			    (op->data.nbytes < MTK_NOR_DMA_ALIGN))
 				op->data.nbytes = 1;


