Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167173D6106
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237752AbhGZP0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:26:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238179AbhGZPZH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:25:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B72ED60F38;
        Mon, 26 Jul 2021 16:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315535;
        bh=UUSnv+YBR56PLXtQOE914sFblrvfbpijYigJ4zwetgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oRR8U/W3UskRYjTilFQkhm2+E5cKfTAmwa8Q+ljd1j0oEN+Z9wK8ofjgYqnyIdt+c
         8nHHoFEWggQpkm3I17tBiH3kSyfFHrCnskuKftKybCwxIHAN9Qq+86qwKvYOciqJAV
         onayVJx4cuQmPpmM4L7qqe5R5b1rPFtohKjIEKLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.10 108/167] s390/boot: fix use of expolines in the DMA code
Date:   Mon, 26 Jul 2021 17:39:01 +0200
Message-Id: <20210726153843.015826258@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Egorenkov <egorenar@linux.ibm.com>

commit 463f36c76fa4ec015c640ff63ccf52e7527abee0 upstream.

The DMA code section of the decompressor must be compiled with expolines
if Spectre V2 mitigation has been enabled for the decompressed kernel.
This is required because although the decompressor's image contains
the DMA code section, it is handed over to the decompressed kernel for use.

Because the DMA code is already slow w/o expolines, use expolines always
regardless whether the decompressed kernel is using them or not. This
simplifies the DMA code by dropping the conditional compilation of
expolines.

Fixes: bf72630130c2 ("s390: use proper expoline sections for .dma code")
Cc: <stable@vger.kernel.org> # 5.2
Signed-off-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/boot/text_dma.S |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

--- a/arch/s390/boot/text_dma.S
+++ b/arch/s390/boot/text_dma.S
@@ -9,16 +9,6 @@
 #include <asm/errno.h>
 #include <asm/sigp.h>
 
-#ifdef CC_USING_EXPOLINE
-	.pushsection .dma.text.__s390_indirect_jump_r14,"axG"
-__dma__s390_indirect_jump_r14:
-	larl	%r1,0f
-	ex	0,0(%r1)
-	j	.
-0:	br	%r14
-	.popsection
-#endif
-
 	.section .dma.text,"ax"
 /*
  * Simplified version of expoline thunk. The normal thunks can not be used here,
@@ -27,11 +17,10 @@ __dma__s390_indirect_jump_r14:
  * affects a few functions that are not performance-relevant.
  */
 	.macro BR_EX_DMA_r14
-#ifdef CC_USING_EXPOLINE
-	jg	__dma__s390_indirect_jump_r14
-#else
-	br	%r14
-#endif
+	larl	%r1,0f
+	ex	0,0(%r1)
+	j	.
+0:	br	%r14
 	.endm
 
 /*


