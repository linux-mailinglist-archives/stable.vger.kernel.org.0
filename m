Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6B01215A0
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732036AbfLPSUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:20:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:49728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728634AbfLPSUK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:20:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4A0F206EC;
        Mon, 16 Dec 2019 18:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520410;
        bh=wCDWB/bRhXepO1riftMcvU3VSqlqFKrfo5G149GN9SM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhWOECb8D+tO20iSb/EW0ZZtxcRVeFp/boaoNPLpTw/XBHOtCFrt4/ZhGLFa6JMd9
         JiwrxK3gN2YvMUWLjvlon0RMUdpcF0m2uhRC81Hw+VJPqFhVuUUtVwaCBVARstL1M4
         sbJp2IEDI0MYIIMLSFWLc/jAcHXseu8EfbWAUtxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alastair DSilva <alastair@d-silva.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 144/177] powerpc: Allow 64bit VDSO __kernel_sync_dicache to work across ranges >4GB
Date:   Mon, 16 Dec 2019 18:50:00 +0100
Message-Id: <20191216174847.126558417@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alastair D'Silva <alastair@d-silva.org>

commit f9ec11165301982585e5e5f606739b5bae5331f3 upstream.

When calling __kernel_sync_dicache with a size >4GB, we were masking
off the upper 32 bits, so we would incorrectly flush a range smaller
than intended.

This patch replaces the 32 bit shifts with 64 bit ones, so that
the full size is accounted for.

Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
Cc: stable@vger.kernel.org
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191104023305.9581-3-alastair@au1.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/vdso64/cacheflush.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/vdso64/cacheflush.S
+++ b/arch/powerpc/kernel/vdso64/cacheflush.S
@@ -35,7 +35,7 @@ V_FUNCTION_BEGIN(__kernel_sync_dicache)
 	subf	r8,r6,r4		/* compute length */
 	add	r8,r8,r5		/* ensure we get enough */
 	lwz	r9,CFG_DCACHE_LOGBLOCKSZ(r10)
-	srw.	r8,r8,r9		/* compute line count */
+	srd.	r8,r8,r9		/* compute line count */
 	crclr	cr0*4+so
 	beqlr				/* nothing to do? */
 	mtctr	r8
@@ -52,7 +52,7 @@ V_FUNCTION_BEGIN(__kernel_sync_dicache)
 	subf	r8,r6,r4		/* compute length */
 	add	r8,r8,r5
 	lwz	r9,CFG_ICACHE_LOGBLOCKSZ(r10)
-	srw.	r8,r8,r9		/* compute line count */
+	srd.	r8,r8,r9		/* compute line count */
 	crclr	cr0*4+so
 	beqlr				/* nothing to do? */
 	mtctr	r8


