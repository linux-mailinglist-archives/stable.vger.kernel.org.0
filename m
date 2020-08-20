Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB32824B962
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730355AbgHTLnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:43:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730612AbgHTKD6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:03:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C08720724;
        Thu, 20 Aug 2020 10:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917836;
        bh=UQ9bBscGua1StUs2Lns9LflTuLYe5Z2moAJYhe5l1Wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Az9YCqWUmE5IKDHiY3AP6zTdHi6P4LlnmumKVcM0rDHtwsCfbpR55zrAhooZAq4/e
         /W4FS0YxdBQDdp+kXF9gnAQvKPtoJ86E95tLBOEb9YI9gkwmUOwgu7YhjGN9Yw9s0T
         PuxWfPfp1YUdUSpv/KpU+jDrcAlIMYI06LsdK4mo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.9 176/212] powerpc: Fix circular dependency between percpu.h and mmu.h
Date:   Thu, 20 Aug 2020 11:22:29 +0200
Message-Id: <20200820091611.280265772@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 0c83b277ada72b585e6a3e52b067669df15bcedb upstream.

Recently random.h started including percpu.h (see commit
f227e3ec3b5c ("random32: update the net random state on interrupt and
activity")), which broke corenet64_smp_defconfig:

  In file included from /linux/arch/powerpc/include/asm/paca.h:18,
                   from /linux/arch/powerpc/include/asm/percpu.h:13,
                   from /linux/include/linux/random.h:14,
                   from /linux/lib/uuid.c:14:
  /linux/arch/powerpc/include/asm/mmu.h:139:22: error: unknown type name 'next_tlbcam_idx'
    139 | DECLARE_PER_CPU(int, next_tlbcam_idx);

This is due to a circular header dependency:
  asm/mmu.h includes asm/percpu.h, which includes asm/paca.h, which
  includes asm/mmu.h

Which means DECLARE_PER_CPU() isn't defined when mmu.h needs it.

We can fix it by moving the include of paca.h below the include of
asm-generic/percpu.h.

This moves the include of paca.h out of the #ifdef __powerpc64__, but
that is OK because paca.h is almost entirely inside #ifdef
CONFIG_PPC64 anyway.

It also moves the include of paca.h out of the #ifdef CONFIG_SMP,
which could possibly break something, but seems to have no ill
effects.

Fixes: f227e3ec3b5c ("random32: update the net random state on interrupt and activity")
Cc: stable@vger.kernel.org # v5.8
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200804130558.292328-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/percpu.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/include/asm/percpu.h
+++ b/arch/powerpc/include/asm/percpu.h
@@ -9,8 +9,6 @@
 
 #ifdef CONFIG_SMP
 
-#include <asm/paca.h>
-
 #define __my_cpu_offset local_paca->data_offset
 
 #endif /* CONFIG_SMP */
@@ -18,4 +16,6 @@
 
 #include <asm-generic/percpu.h>
 
+#include <asm/paca.h>
+
 #endif /* _ASM_POWERPC_PERCPU_H_ */


