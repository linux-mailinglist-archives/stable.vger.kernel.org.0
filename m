Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C97862BA831
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgKTLFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:05:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:52966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728148AbgKTLFU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:05:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA12422255;
        Fri, 20 Nov 2020 11:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870319;
        bh=m6ZFw1C6vwDc7iXqLj1qDZdUW2q7DcqpcX2t3kPxVwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NOQl/B9dL1b/FnfBdm2FNiUdDsJt46shLDvwl1PqXomkF6iAtBahF4HTmN4No/Oaj
         05n/MjwwBwH97lHqhAoUa+os4w5ZtePNSf+seRJ0lzHIBpo8C18bk9/96rLyASCA5p
         9q/g9ABlvcf4eYPhZHlVYgZGeDsKkh8vJ1AghNUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, dja@axtens.net
Subject: [PATCH 4.14 02/17] powerpc/64s: move some exception handlers out of line
Date:   Fri, 20 Nov 2020 12:03:13 +0100
Message-Id: <20201120104540.530368843@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104540.414709708@linuxfoundation.org>
References: <20201120104540.414709708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Axtens <dja@axtens.net>

(backport only)

We're about to grow the exception handlers, which will make a bunch of them
no longer fit within the space available. We move them out of line.

This is a fiddly and error-prone business, so in the interests of reviewability
I haven't merged this in with the addition of the entry flush.

Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/exceptions-64s.S |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -516,13 +516,16 @@ ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_TY
 EXC_REAL_BEGIN(data_access_slb, 0x380, 0x80)
 	SET_SCRATCH0(r13)
 	EXCEPTION_PROLOG_0(PACA_EXSLB)
+	b tramp_data_access_slb
+EXC_REAL_END(data_access_slb, 0x380, 0x80)
+
+TRAMP_REAL_BEGIN(tramp_data_access_slb)
 	EXCEPTION_PROLOG_1(PACA_EXSLB, KVMTEST_PR, 0x380)
 	mr	r12,r3	/* save r3 */
 	mfspr	r3,SPRN_DAR
 	mfspr	r11,SPRN_SRR1
 	crset	4*cr6+eq
 	BRANCH_TO_COMMON(r10, slb_miss_common)
-EXC_REAL_END(data_access_slb, 0x380, 0x80)
 
 EXC_VIRT_BEGIN(data_access_slb, 0x4380, 0x80)
 	SET_SCRATCH0(r13)
@@ -560,13 +563,16 @@ ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_TY
 EXC_REAL_BEGIN(instruction_access_slb, 0x480, 0x80)
 	SET_SCRATCH0(r13)
 	EXCEPTION_PROLOG_0(PACA_EXSLB)
+	b tramp_instruction_access_slb
+EXC_REAL_END(instruction_access_slb, 0x480, 0x80)
+
+TRAMP_REAL_BEGIN(tramp_instruction_access_slb)
 	EXCEPTION_PROLOG_1(PACA_EXSLB, KVMTEST_PR, 0x480)
 	mr	r12,r3	/* save r3 */
 	mfspr	r3,SPRN_SRR0		/* SRR0 is faulting address */
 	mfspr	r11,SPRN_SRR1
 	crclr	4*cr6+eq
 	BRANCH_TO_COMMON(r10, slb_miss_common)
-EXC_REAL_END(instruction_access_slb, 0x480, 0x80)
 
 EXC_VIRT_BEGIN(instruction_access_slb, 0x4480, 0x80)
 	SET_SCRATCH0(r13)


