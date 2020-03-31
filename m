Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E2A19911F
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730499AbgCaJR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:17:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732037AbgCaJRZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:17:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C006B20675;
        Tue, 31 Mar 2020 09:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646244;
        bh=Tj/iq0FRyUK/KJfzZTg+0+d4QNo001tjbb7+70vHkUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lucerV/qlx8Fswy2eQZgRCwCtNKhHu6GdQAIyLBpv7MccpBqS8+jEm7qIAJXlXEJo
         xWegBju6G6MC7lrQHvq8U+T/ggEaPdTnAKBiEWFhV2gvn2Y1wBUQjs1sgFUfPDNqD9
         qPU5pBCWar0GL7A+p/UDbzr5UebBX/YdgSGs+o3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xi Wang <xi.wang@gmail.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.4 128/155] bpf, x32: Fix bug with JMP32 JSET BPF_X checking upper bits
Date:   Tue, 31 Mar 2020 10:59:28 +0200
Message-Id: <20200331085432.664230082@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luke Nelson <lukenels@cs.washington.edu>

commit 80f1f85036355e5581ec0b99913410345ad3491b upstream.

The current x32 BPF JIT is incorrect for JMP32 JSET BPF_X when the upper
32 bits of operand registers are non-zero in certain situations.

The problem is in the following code:

  case BPF_JMP | BPF_JSET | BPF_X:
  case BPF_JMP32 | BPF_JSET | BPF_X:
  ...

  /* and dreg_lo,sreg_lo */
  EMIT2(0x23, add_2reg(0xC0, sreg_lo, dreg_lo));
  /* and dreg_hi,sreg_hi */
  EMIT2(0x23, add_2reg(0xC0, sreg_hi, dreg_hi));
  /* or dreg_lo,dreg_hi */
  EMIT2(0x09, add_2reg(0xC0, dreg_lo, dreg_hi));

This code checks the upper bits of the operand registers regardless if
the BPF instruction is BPF_JMP32 or BPF_JMP64. Registers dreg_hi and
dreg_lo are not loaded from the stack for BPF_JMP32, however, they can
still be polluted with values from previous instructions.

The following BPF program demonstrates the bug. The jset64 instruction
loads the temporary registers and performs the jump, since ((u64)r7 &
(u64)r8) is non-zero. The jset32 should _not_ be taken, as the lower
32 bits are all zero, however, the current JIT will take the branch due
the pollution of temporary registers from the earlier jset64.

  mov64    r0, 0
  ld64     r7, 0x8000000000000000
  ld64     r8, 0x8000000000000000
  jset64   r7, r8, 1
  exit
  jset32   r7, r8, 1
  mov64    r0, 2
  exit

The expected return value of this program is 2; under the buggy x32 JIT
it returns 0. The fix is to skip using the upper 32 bits for jset32 and
compare the upper 32 bits for jset64 only.

All tests in test_bpf.ko and selftests/bpf/test_verifier continue to
pass with this change.

We found this bug using our automated verification tool, Serval.

Fixes: 69f827eb6e14 ("x32: bpf: implement jitting of JMP32")
Co-developed-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20200305234416.31597-1-luke.r.nels@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/net/bpf_jit_comp32.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -2039,10 +2039,12 @@ static int do_jit(struct bpf_prog *bpf_p
 			}
 			/* and dreg_lo,sreg_lo */
 			EMIT2(0x23, add_2reg(0xC0, sreg_lo, dreg_lo));
-			/* and dreg_hi,sreg_hi */
-			EMIT2(0x23, add_2reg(0xC0, sreg_hi, dreg_hi));
-			/* or dreg_lo,dreg_hi */
-			EMIT2(0x09, add_2reg(0xC0, dreg_lo, dreg_hi));
+			if (is_jmp64) {
+				/* and dreg_hi,sreg_hi */
+				EMIT2(0x23, add_2reg(0xC0, sreg_hi, dreg_hi));
+				/* or dreg_lo,dreg_hi */
+				EMIT2(0x09, add_2reg(0xC0, dreg_lo, dreg_hi));
+			}
 			goto emit_cond_jmp;
 		}
 		case BPF_JMP | BPF_JSET | BPF_K:


