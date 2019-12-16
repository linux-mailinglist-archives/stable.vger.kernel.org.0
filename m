Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D21EB12133C
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbfLPSAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:00:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728854AbfLPSAA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:00:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41CC5205ED;
        Mon, 16 Dec 2019 17:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519199;
        bh=qMLWmQ3wc7BSVvg5SW1DTdKJPskH/4hsiez8yiO/fwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wyi6/wlpEHiqAdo10xnbmoMzs5BsAPZk0miwbvHbdGrUxKQqxJtSxkndW/+IZyLSe
         Vq9wttd+PmPWFPEgBMrbU6sIj24OyI4F9kT2NxPchh/rSWqp3DXczla0LS5VoZe/pb
         0BQp/YG0JWxa1R7jh6BZi2CMLqdY1NCowMb89tTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alastair DSilva <alastair@d-silva.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.14 229/267] powerpc: Allow flush_icache_range to work across ranges >4GB
Date:   Mon, 16 Dec 2019 18:49:15 +0100
Message-Id: <20191216174915.101184046@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alastair D'Silva <alastair@d-silva.org>

commit 29430fae82073d39b1b881a3cd507416a56a363f upstream.

When calling flush_icache_range with a size >4GB, we were masking
off the upper 32 bits, so we would incorrectly flush a range smaller
than intended.

This patch replaces the 32 bit shifts with 64 bit ones, so that
the full size is accounted for.

Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
Cc: stable@vger.kernel.org
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191104023305.9581-2-alastair@au1.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/misc_64.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/misc_64.S
+++ b/arch/powerpc/kernel/misc_64.S
@@ -86,7 +86,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_COHERENT_I
 	subf	r8,r6,r4		/* compute length */
 	add	r8,r8,r5		/* ensure we get enough */
 	lwz	r9,DCACHEL1LOGBLOCKSIZE(r10)	/* Get log-2 of cache block size */
-	srw.	r8,r8,r9		/* compute line count */
+	srd.	r8,r8,r9		/* compute line count */
 	beqlr				/* nothing to do? */
 	mtctr	r8
 1:	dcbst	0,r6
@@ -102,7 +102,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_COHERENT_I
 	subf	r8,r6,r4		/* compute length */
 	add	r8,r8,r5
 	lwz	r9,ICACHEL1LOGBLOCKSIZE(r10)	/* Get log-2 of Icache block size */
-	srw.	r8,r8,r9		/* compute line count */
+	srd.	r8,r8,r9		/* compute line count */
 	beqlr				/* nothing to do? */
 	mtctr	r8
 2:	icbi	0,r6


