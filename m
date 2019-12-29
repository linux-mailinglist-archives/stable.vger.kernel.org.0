Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA62612C704
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732367AbfL2Rwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:52:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:39426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732363AbfL2Rwz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:52:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72568207FF;
        Sun, 29 Dec 2019 17:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641973;
        bh=0ESp20aAUnS5jp+6ZSrygToxGhhWPBu3SxXHzuTJ01E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gx3TjpHEa172Zv53MSzDCMc4tdO+I9/KVGRyJqWazAcu9XtJXgY42M4QXzuzhSI30
         v48YjwCEF7L/wEiEZL1YaZRQ5F4tsZZzO8OLrf8ban15EFTsLTJNsk5qPD9jKzgAdA
         MeRUgLnl2qgoVUx5QDOzDdCfmtYiKTuubkNspxNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 290/434] bpf, testing: Workaround a verifier failure for test_progs
Date:   Sun, 29 Dec 2019 18:25:43 +0100
Message-Id: <20191229172721.212406497@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit b7a0d65d80a0c5034b366392624397a0915b7556 ]

With latest llvm compiler, running test_progs will have the following
verifier failure for test_sysctl_loop1.o:

  libbpf: load bpf program failed: Permission denied
  libbpf: -- BEGIN DUMP LOG ---
  libbpf:
  invalid indirect read from stack var_off (0x0; 0xff)+196 size 7
  ...
  libbpf: -- END LOG --
  libbpf: failed to load program 'cgroup/sysctl'
  libbpf: failed to load object 'test_sysctl_loop1.o'

The related bytecode looks as below:

  0000000000000308 LBB0_8:
      97:       r4 = r10
      98:       r4 += -288
      99:       r4 += r7
     100:       w8 &= 255
     101:       r1 = r10
     102:       r1 += -488
     103:       r1 += r8
     104:       r2 = 7
     105:       r3 = 0
     106:       call 106
     107:       w1 = w0
     108:       w1 += -1
     109:       if w1 > 6 goto -24 <LBB0_5>
     110:       w0 += w8
     111:       r7 += 8
     112:       w8 = w0
     113:       if r7 != 224 goto -17 <LBB0_8>

And source code:

     for (i = 0; i < ARRAY_SIZE(tcp_mem); ++i) {
             ret = bpf_strtoul(value + off, MAX_ULONG_STR_LEN, 0,
                               tcp_mem + i);
             if (ret <= 0 || ret > MAX_ULONG_STR_LEN)
                     return 0;
             off += ret & MAX_ULONG_STR_LEN;
     }

Current verifier is not able to conclude that register w0 before '+'
at insn 110 has a range of 1 to 7 and thinks it is from 0 - 255. This
leads to more conservative range for w8 at insn 112, and later verifier
complaint.

Let us workaround this issue until we found a compiler and/or verifier
solution. The workaround in this patch is to make variable 'ret' volatile,
which will force a reload and then '&' operation to ensure better value
range. With this patch, I got the below byte code for the loop:

  0000000000000328 LBB0_9:
     101:       r4 = r10
     102:       r4 += -288
     103:       r4 += r7
     104:       w8 &= 255
     105:       r1 = r10
     106:       r1 += -488
     107:       r1 += r8
     108:       r2 = 7
     109:       r3 = 0
     110:       call 106
     111:       *(u32 *)(r10 - 64) = r0
     112:       r1 = *(u32 *)(r10 - 64)
     113:       if w1 s< 1 goto -28 <LBB0_5>
     114:       r1 = *(u32 *)(r10 - 64)
     115:       if w1 s> 7 goto -30 <LBB0_5>
     116:       r1 = *(u32 *)(r10 - 64)
     117:       w1 &= 7
     118:       w1 += w8
     119:       r7 += 8
     120:       w8 = w1
     121:       if r7 != 224 goto -21 <LBB0_9>

Insn 117 did the '&' operation and we got more precise value range
for 'w8' at insn 120. The test is happy then:

  #3/17 test_sysctl_loop1.o:OK

Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20191107170045.2503480-1-yhs@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/test_sysctl_loop1.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/test_sysctl_loop1.c b/tools/testing/selftests/bpf/progs/test_sysctl_loop1.c
index 608a06871572..d22e438198cf 100644
--- a/tools/testing/selftests/bpf/progs/test_sysctl_loop1.c
+++ b/tools/testing/selftests/bpf/progs/test_sysctl_loop1.c
@@ -44,7 +44,10 @@ int sysctl_tcp_mem(struct bpf_sysctl *ctx)
 	unsigned long tcp_mem[TCP_MEM_LOOPS] = {};
 	char value[MAX_VALUE_STR_LEN];
 	unsigned char i, off = 0;
-	int ret;
+	/* a workaround to prevent compiler from generating
+	 * codes verifier cannot handle yet.
+	 */
+	volatile int ret;
 
 	if (ctx->write)
 		return 0;
-- 
2.20.1



