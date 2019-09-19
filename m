Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8F73B8697
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406253AbfISWQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:16:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406249AbfISWQD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:16:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B15FE217D6;
        Thu, 19 Sep 2019 22:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931362;
        bh=MDQ7rLMjvv0P66wPoli3ZPds3gzwj7sGjeX3LmqqTIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+KAwkVEjVyPZq2dg/tdcOA31pKRLT0Z7wEsgXJ3Nk2xjSO2WEJBrg36DPkWFAbBs
         3zimrnPrP5nH7evDpr2Tp11N1R2P4kJljHx/odHE3ItLSRQS7gH1+HsyU+gR88CCub
         KaJNGamk1FrOL7v4XIH9ibMW4PZx8qpccM/1wOkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yauheni Kaliuta <yauheni.kaliuta@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 19/59] s390/bpf: use 32-bit index for tail calls
Date:   Fri, 20 Sep 2019 00:03:34 +0200
Message-Id: <20190919214801.315715000@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214755.852282682@linuxfoundation.org>
References: <20190919214755.852282682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 91b4db5313a2c793aabc2143efb8ed0cf0fdd097 ]

"p runtime/jit: pass > 32bit index to tail_call" fails when
bpf_jit_enable=1, because the tail call is not executed.

This in turn is because the generated code assumes index is 64-bit,
while it must be 32-bit, and as a result prog array bounds check fails,
while it should pass. Even if bounds check would have passed, the code
that follows uses 64-bit index to compute prog array offset.

Fix by using clrj instead of clgrj for comparing index with array size,
and also by using llgfr for truncating index to 32 bits before using it
to compute prog array offset.

Fixes: 6651ee070b31 ("s390/bpf: implement bpf_tail_call() helper")
Reported-by: Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
Acked-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index fcb9e840727cd..b8bd841048434 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -1063,8 +1063,8 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp, int i
 		/* llgf %w1,map.max_entries(%b2) */
 		EMIT6_DISP_LH(0xe3000000, 0x0016, REG_W1, REG_0, BPF_REG_2,
 			      offsetof(struct bpf_array, map.max_entries));
-		/* clgrj %b3,%w1,0xa,label0: if %b3 >= %w1 goto out */
-		EMIT6_PCREL_LABEL(0xec000000, 0x0065, BPF_REG_3,
+		/* clrj %b3,%w1,0xa,label0: if (u32)%b3 >= (u32)%w1 goto out */
+		EMIT6_PCREL_LABEL(0xec000000, 0x0077, BPF_REG_3,
 				  REG_W1, 0, 0xa);
 
 		/*
@@ -1090,8 +1090,10 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp, int i
 		 *         goto out;
 		 */
 
-		/* sllg %r1,%b3,3: %r1 = index * 8 */
-		EMIT6_DISP_LH(0xeb000000, 0x000d, REG_1, BPF_REG_3, REG_0, 3);
+		/* llgfr %r1,%b3: %r1 = (u32) index */
+		EMIT4(0xb9160000, REG_1, BPF_REG_3);
+		/* sllg %r1,%r1,3: %r1 *= 8 */
+		EMIT6_DISP_LH(0xeb000000, 0x000d, REG_1, REG_1, REG_0, 3);
 		/* lg %r1,prog(%b2,%r1) */
 		EMIT6_DISP_LH(0xe3000000, 0x0004, REG_1, BPF_REG_2,
 			      REG_1, offsetof(struct bpf_array, ptrs));
-- 
2.20.1



