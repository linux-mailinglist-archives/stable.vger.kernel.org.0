Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE0F31BD2B
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhBOPlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:41:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:49638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231603AbhBOPiF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:38:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 337D464EEB;
        Mon, 15 Feb 2021 15:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403236;
        bh=iNhBaqcKo5xlqkXO9BkzW2PKLCoLecJSEpmH4XRm8xQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U8sDA6q9YKdvxGpdH1T9VNVLAIOBGUy7QcXIABM2/lVs/4cgiHw6SV70JaGXc0jst
         SB8aFcaTrC9YFAknSIV04kQYAQnFhotJX8TUHZG2Y7LiZMGG7GQGOynFNasnGd8hEX
         mePPm2BL6CddIngbQE1f8pG3FcXYAMj/SexGeG+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/104] kasan: add explicit preconditions to kasan_report()
Date:   Mon, 15 Feb 2021 16:26:56 +0100
Message-Id: <20210215152720.867409732@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincenzo Frascino <vincenzo.frascino@arm.com>

[ Upstream commit 49c6631d3b4f61a7b5bb0453a885a12bfa06ffd8 ]

Patch series "kasan: Fix metadata detection for KASAN_HW_TAGS", v5.

With the introduction of KASAN_HW_TAGS, kasan_report() currently assumes
that every location in memory has valid metadata associated.  This is
due to the fact that addr_has_metadata() returns always true.

As a consequence of this, an invalid address (e.g.  NULL pointer
address) passed to kasan_report() when KASAN_HW_TAGS is enabled, leads
to a kernel panic.

Example below, based on arm64:

   BUG: KASAN: invalid-access in 0x0
   Read at addr 0000000000000000 by task swapper/0/1
   Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
   Mem abort info:
     ESR = 0x96000004
     EC = 0x25: DABT (current EL), IL = 32 bits
     SET = 0, FnV = 0
     EA = 0, S1PTW = 0
   Data abort info:
     ISV = 0, ISS = 0x00000004
     CM = 0, WnR = 0

  ...

   Call trace:
    mte_get_mem_tag+0x24/0x40
    kasan_report+0x1a4/0x410
    alsa_sound_last_init+0x8c/0xa4
    do_one_initcall+0x50/0x1b0
    kernel_init_freeable+0x1d4/0x23c
    kernel_init+0x14/0x118
    ret_from_fork+0x10/0x34
   Code: d65f03c0 9000f021 f9428021 b6cfff61 (d9600000)
   ---[ end trace 377c8bb45bdd3a1a ]---
   hrtimer: interrupt took 48694256 ns
   note: swapper/0[1] exited with preempt_count 1
   Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
   SMP: stopping secondary CPUs
   Kernel Offset: 0x35abaf140000 from 0xffff800010000000
   PHYS_OFFSET: 0x40000000
   CPU features: 0x0a7e0152,61c0a030
   Memory Limit: none
   ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b ]---

This series fixes the behavior of addr_has_metadata() that now returns
true only when the address is valid.

This patch (of 2):

With the introduction of KASAN_HW_TAGS, kasan_report() accesses the
metadata only when addr_has_metadata() succeeds.

Add a comment to make sure that the preconditions to the function are
explicitly clarified.

Link: https://lkml.kernel.org/r/20210126134409.47894-1-vincenzo.frascino@arm.com
Link: https://lkml.kernel.org/r/20210126134409.47894-2-vincenzo.frascino@arm.com
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Leon Romanovsky <leonro@mellanox.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kasan.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 30d343b4a40a5..646fa165d2cce 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -196,6 +196,13 @@ void kasan_init_tags(void);
 
 void *kasan_reset_tag(const void *addr);
 
+/**
+ * kasan_report - print a report about a bad memory access detected by KASAN
+ * @addr: address of the bad access
+ * @size: size of the bad access
+ * @is_write: whether the bad access is a write or a read
+ * @ip: instruction pointer for the accessibility check or the bad access itself
+ */
 bool kasan_report(unsigned long addr, size_t size,
 		bool is_write, unsigned long ip);
 
-- 
2.27.0



