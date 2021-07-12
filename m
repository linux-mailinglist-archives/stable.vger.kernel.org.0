Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B8A3C44F4
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbhGLGWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:22:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233409AbhGLGVY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:21:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9013610D1;
        Mon, 12 Jul 2021 06:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070715;
        bh=OqgXGjBDzeSwIepSMpC1mu1vc1La23fkZjFRjuIvnhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+kwm9vAKU79n4oqVLdJfP2KRUmG+7byVJPawXlOS8g//8dqZtNXDYiggQWqzHkeZ
         PcxTvhqP05yNuCIC6rUOxOY24q02ZTNV92q4cFmCERopSEApuATCLeVxS7YJ4uHaOl
         X14JIoMVYcII87Kj2/6HvN7UbH2bozuJB85sV4x8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 108/348] KVM: s390: get rid of register asm usage
Date:   Mon, 12 Jul 2021 08:08:12 +0200
Message-Id: <20210712060715.888640340@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 4fa3b91bdee1b08348c82660668ca0ca34e271ad ]

Using register asm statements has been proven to be very error prone,
especially when using code instrumentation where gcc may add function
calls, which clobbers register contents in an unexpected way.

Therefore get rid of register asm statements in kvm code, even though
there is currently nothing wrong with them. This way we know for sure
that this bug class won't be introduced here.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20210621140356.1210771-1-hca@linux.ibm.com
[borntraeger@de.ibm.com: checkpatch strict fix]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/kvm-s390.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d08e13c6dc98..20ba8537dbcc 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -318,31 +318,31 @@ static void allow_cpu_feat(unsigned long nr)
 
 static inline int plo_test_bit(unsigned char nr)
 {
-	register unsigned long r0 asm("0") = (unsigned long) nr | 0x100;
+	unsigned long function = (unsigned long)nr | 0x100;
 	int cc;
 
 	asm volatile(
+		"	lgr	0,%[function]\n"
 		/* Parameter registers are ignored for "test bit" */
 		"	plo	0,0,0,0(0)\n"
 		"	ipm	%0\n"
 		"	srl	%0,28\n"
 		: "=d" (cc)
-		: "d" (r0)
-		: "cc");
+		: [function] "d" (function)
+		: "cc", "0");
 	return cc == 0;
 }
 
 static __always_inline void __insn32_query(unsigned int opcode, u8 *query)
 {
-	register unsigned long r0 asm("0") = 0;	/* query function */
-	register unsigned long r1 asm("1") = (unsigned long) query;
-
 	asm volatile(
-		/* Parameter regs are ignored */
+		"	lghi	0,0\n"
+		"	lgr	1,%[query]\n"
+		/* Parameter registers are ignored */
 		"	.insn	rrf,%[opc] << 16,2,4,6,0\n"
 		:
-		: "d" (r0), "a" (r1), [opc] "i" (opcode)
-		: "cc", "memory");
+		: [query] "d" ((unsigned long)query), [opc] "i" (opcode)
+		: "cc", "memory", "0", "1");
 }
 
 #define INSN_SORTL 0xb938
-- 
2.30.2



