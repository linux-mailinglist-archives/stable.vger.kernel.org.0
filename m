Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C1B328DA6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241104AbhCATPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:15:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:39810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238073AbhCATKX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:10:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E18764FBD;
        Mon,  1 Mar 2021 17:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620238;
        bh=/7pT0kEh99FHUtwTb6He+rcjg5tNt++0dodBOJTVDCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDYTceftLdd0LxEjfgYP/pt55Hzggw6OJvcoG4ivZ63vzNgwt1KvBJY1UiPzu4dhC
         safTX9mE+AWKX+/CL6RfrpbD+yYIF82giXCdQPVS4Vc+I91j841j/JU3NytIg7cbA5
         w2MVOQBTDUpN+dFqdbu66cBPt95+A2qD+CFe2SoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Agner <stefan@agner.ch>,
        Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 081/775] ARM: s3c: fix fiq for clang IAS
Date:   Mon,  1 Mar 2021 17:04:09 +0100
Message-Id: <20210301161205.687206714@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
 arch/arm/mach-s3c/irq-s3c24xx-fiq.S | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-s3c/irq-s3c24xx-fiq.S b/arch/arm/mach-s3c/irq-s3c24xx-fiq.S
index b54cbd0122413..5d238d9a798e1 100644
--- a/arch/arm/mach-s3c/irq-s3c24xx-fiq.S
+++ b/arch/arm/mach-s3c/irq-s3c24xx-fiq.S
@@ -35,7 +35,6 @@
 	@ and an offset to the irq acknowledgment word
 
 ENTRY(s3c24xx_spi_fiq_rx)
-s3c24xx_spi_fix_rx:
 	.word	fiq_rx_end - fiq_rx_start
 	.word	fiq_rx_irq_ack - fiq_rx_start
 fiq_rx_start:
@@ -49,7 +48,7 @@ fiq_rx_start:
 	strb	fiq_rtmp, [ fiq_rspi, # S3C2410_SPTDAT ]
 
 	subs	fiq_rcount, fiq_rcount, #1
-	subnes	pc, lr, #4		@@ return, still have work to do
+	subsne	pc, lr, #4		@@ return, still have work to do
 
 	@@ set IRQ controller so that next op will trigger IRQ
 	mov	fiq_rtmp, #0
@@ -61,7 +60,6 @@ fiq_rx_irq_ack:
 fiq_rx_end:
 
 ENTRY(s3c24xx_spi_fiq_txrx)
-s3c24xx_spi_fiq_txrx:
 	.word	fiq_txrx_end - fiq_txrx_start
 	.word	fiq_txrx_irq_ack - fiq_txrx_start
 fiq_txrx_start:
@@ -76,7 +74,7 @@ fiq_txrx_start:
 	strb	fiq_rtmp, [ fiq_rspi, # S3C2410_SPTDAT ]
 
 	subs	fiq_rcount, fiq_rcount, #1
-	subnes	pc, lr, #4		@@ return, still have work to do
+	subsne	pc, lr, #4		@@ return, still have work to do
 
 	mov	fiq_rtmp, #0
 	str	fiq_rtmp, [ fiq_rirq, # S3C2410_INTMOD  - S3C24XX_VA_IRQ ]
@@ -88,7 +86,6 @@ fiq_txrx_irq_ack:
 fiq_txrx_end:
 
 ENTRY(s3c24xx_spi_fiq_tx)
-s3c24xx_spi_fix_tx:
 	.word	fiq_tx_end - fiq_tx_start
 	.word	fiq_tx_irq_ack - fiq_tx_start
 fiq_tx_start:
@@ -101,7 +98,7 @@ fiq_tx_start:
 	strb	fiq_rtmp, [ fiq_rspi, # S3C2410_SPTDAT ]
 
 	subs	fiq_rcount, fiq_rcount, #1
-	subnes	pc, lr, #4		@@ return, still have work to do
+	subsne	pc, lr, #4		@@ return, still have work to do
 
 	mov	fiq_rtmp, #0
 	str	fiq_rtmp, [ fiq_rirq, # S3C2410_INTMOD  - S3C24XX_VA_IRQ ]
-- 
2.27.0



