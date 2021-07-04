Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6393BB164
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbhGDXLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231144AbhGDXKy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:10:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F25756194B;
        Sun,  4 Jul 2021 23:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440079;
        bh=2Wi38nQN3VKnV4ahUhGFIElpkM/7DNUZ3EbizulaLTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hAaIUVFn3+bGzW7u0EtvEsw4AAhadKX4tk8cvcLwrIyH0DsYXIAwyZeyqua7xem8N
         rblsFhvXdLRxOLjpvH4S23MQx6qRy/9qfNcA6C9sQKigvNSwHnnfFW2eT57wsuhNBf
         nKDq9djkVbj34ADGSml/cEVwptmbYShKfGEIJztjIRvsqmpW/lmXGUAo6Y8PFaRTAZ
         ZM9zxf9RwjmA2HlEI9Q4Z4RFg4PB8lJP+yYoYzVUtq7AwomxyueV3iSjdN43q86WoU
         y9hSdxQ215HCYM+ID9fMomDrx4buqA4+WWKRoAfH4f01RCwtLixehIAra+DZo7uhpg
         yLHblX+l3Cu3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 77/80] KVM: s390: get rid of register asm usage
Date:   Sun,  4 Jul 2021 19:06:13 -0400
Message-Id: <20210704230616.1489200-77-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 24ad447e648c..dd7136b3ed9a 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -323,31 +323,31 @@ static void allow_cpu_feat(unsigned long nr)
 
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

