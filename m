Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2170D32841B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234772AbhCAQ2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:28:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:60814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231645AbhCAQYq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:24:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F30A64F43;
        Mon,  1 Mar 2021 16:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615688;
        bh=G+gJdW0zCwsUHqPseCQTPkJVeus4P3sRHtcHXk4VfyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sf83Hvn+f8sCZmDFh9CDeUPa7Jovpa+GVnSot6X7iTstnZ0wHeTtniqB4K/aq/QVV
         3cyAZTPGujutJaCc2WSEGH+Tlntg1dUMYdORYSVlN92myZdigt6Q3nCA1S6cf5kw4l
         n8NGZ7UGzcRWKweCS6FcvfxEp2R0BacKwsSClz9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Agner <stefan@agner.ch>,
        Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 024/134] ARM: s3c: fix fiq for clang IAS
Date:   Mon,  1 Mar 2021 17:12:05 +0100
Message-Id: <20210301161014.754504746@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 7f9942c61fa60eda7cc8e42f04bd25b7d175876e ]

Building with the clang integrated assembler produces a couple of
errors for the s3c24xx fiq support:

  arch/arm/mach-s3c/irq-s3c24xx-fiq.S:52:2: error: instruction 'subne' can not set flags, but 's' suffix specified
    subnes pc, lr, #4 @@ return, still have work to do

  arch/arm/mach-s3c/irq-s3c24xx-fiq.S:64:1: error: invalid symbol redefinition
    s3c24xx_spi_fiq_txrx:

There are apparently two problems: one with extraneous or duplicate
labels, and one with old-style opcode mnemonics. Stefan Agner has
previously fixed other problems like this, but missed this particular
file.

Fixes: bec0806cfec6 ("spi_s3c24xx: add FIQ pseudo-DMA support")
Cc: Stefan Agner <stefan@agner.ch>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20210204162416.3030114-1-arnd@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-s3c24xx-fiq.S | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-s3c24xx-fiq.S b/drivers/spi/spi-s3c24xx-fiq.S
index 059f2dc1fda2d..1565c792da079 100644
--- a/drivers/spi/spi-s3c24xx-fiq.S
+++ b/drivers/spi/spi-s3c24xx-fiq.S
@@ -36,7 +36,6 @@
 	@ and an offset to the irq acknowledgment word
 
 ENTRY(s3c24xx_spi_fiq_rx)
-s3c24xx_spi_fix_rx:
 	.word	fiq_rx_end - fiq_rx_start
 	.word	fiq_rx_irq_ack - fiq_rx_start
 fiq_rx_start:
@@ -50,7 +49,7 @@ fiq_rx_start:
 	strb	fiq_rtmp, [ fiq_rspi, # S3C2410_SPTDAT ]
 
 	subs	fiq_rcount, fiq_rcount, #1
-	subnes	pc, lr, #4		@@ return, still have work to do
+	subsne	pc, lr, #4		@@ return, still have work to do
 
 	@@ set IRQ controller so that next op will trigger IRQ
 	mov	fiq_rtmp, #0
@@ -62,7 +61,6 @@ fiq_rx_irq_ack:
 fiq_rx_end:
 
 ENTRY(s3c24xx_spi_fiq_txrx)
-s3c24xx_spi_fiq_txrx:
 	.word	fiq_txrx_end - fiq_txrx_start
 	.word	fiq_txrx_irq_ack - fiq_txrx_start
 fiq_txrx_start:
@@ -77,7 +75,7 @@ fiq_txrx_start:
 	strb	fiq_rtmp, [ fiq_rspi, # S3C2410_SPTDAT ]
 
 	subs	fiq_rcount, fiq_rcount, #1
-	subnes	pc, lr, #4		@@ return, still have work to do
+	subsne	pc, lr, #4		@@ return, still have work to do
 
 	mov	fiq_rtmp, #0
 	str	fiq_rtmp, [ fiq_rirq, # S3C2410_INTMOD  - S3C24XX_VA_IRQ ]
@@ -89,7 +87,6 @@ fiq_txrx_irq_ack:
 fiq_txrx_end:
 
 ENTRY(s3c24xx_spi_fiq_tx)
-s3c24xx_spi_fix_tx:
 	.word	fiq_tx_end - fiq_tx_start
 	.word	fiq_tx_irq_ack - fiq_tx_start
 fiq_tx_start:
@@ -102,7 +99,7 @@ fiq_tx_start:
 	strb	fiq_rtmp, [ fiq_rspi, # S3C2410_SPTDAT ]
 
 	subs	fiq_rcount, fiq_rcount, #1
-	subnes	pc, lr, #4		@@ return, still have work to do
+	subsne	pc, lr, #4		@@ return, still have work to do
 
 	mov	fiq_rtmp, #0
 	str	fiq_rtmp, [ fiq_rirq, # S3C2410_INTMOD  - S3C24XX_VA_IRQ ]
-- 
2.27.0



