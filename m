Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2B21D230B
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387781AbfJJIjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:39:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387767AbfJJIjG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:39:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D48D20B7C;
        Thu, 10 Oct 2019 08:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696745;
        bh=zCNBAvfBC2GkCrSrnVZbh81b4yRACjXiRWvWQuy7CBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AFUsE56+kKc201824jywSAyew612qaWxLHW7dn9+TsQZTQJkD4Z8cpNxy/ftVjXn9
         CK2tVtkjtFRYuoDHBPTPzBLWVJan8EGgN09oWLlNie5gKseul3Ig67hU3jRSsuI8uv
         FSfNys7j6eO9fCFDifQp41t1rBJG+Twi/eVXWJvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.3 009/148] KVM: s390: fix __insn32_query() inline assembly
Date:   Thu, 10 Oct 2019 10:34:30 +0200
Message-Id: <20191010083611.628970243@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit b1c41ac3ce569b04644bb1e3fd28926604637da3 upstream.

The inline assembly constraints of __insn32_query() tell the compiler
that only the first byte of "query" is being written to. Intended was
probably that 32 bytes are written to.

Fix and simplify the code and just use a "memory" clobber.

Fixes: d668139718a9 ("KVM: s390: provide query function for instructions returning 32 byte")
Cc: stable@vger.kernel.org # v5.2+
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kvm/kvm-s390.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -332,7 +332,7 @@ static inline int plo_test_bit(unsigned
 	return cc == 0;
 }
 
-static inline void __insn32_query(unsigned int opcode, u8 query[32])
+static inline void __insn32_query(unsigned int opcode, u8 *query)
 {
 	register unsigned long r0 asm("0") = 0;	/* query function */
 	register unsigned long r1 asm("1") = (unsigned long) query;
@@ -340,9 +340,9 @@ static inline void __insn32_query(unsign
 	asm volatile(
 		/* Parameter regs are ignored */
 		"	.insn	rrf,%[opc] << 16,2,4,6,0\n"
-		: "=m" (*query)
+		:
 		: "d" (r0), "a" (r1), [opc] "i" (opcode)
-		: "cc");
+		: "cc", "memory");
 }
 
 #define INSN_SORTL 0xb938


