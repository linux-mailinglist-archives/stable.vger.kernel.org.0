Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1141E6941
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 20:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405782AbgE1SY6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 28 May 2020 14:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405744AbgE1SY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 14:24:57 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17447C08C5C6;
        Thu, 28 May 2020 11:24:57 -0700 (PDT)
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jeND0-0006Bd-A3; Thu, 28 May 2020 20:24:50 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id B8F091C0051;
        Thu, 28 May 2020 20:24:49 +0200 (CEST)
Date:   Thu, 28 May 2020 18:24:49 -0000
From:   "tip-bot2 for Alexander Dahl" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/dma: Fix max PFN arithmetic overflow on 32 bit systems
Cc:     Alan Jenkins <alan.christopher.jenkins@gmail.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Alexander Dahl <post@lespocky.de>,
        Borislav Petkov <bp@suse.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200526175749.20742-1-post@lespocky.de>
References: <20200526175749.20742-1-post@lespocky.de>
MIME-Version: 1.0
Message-ID: <159069028956.17951.16863245734810894294.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     88743470668ef5eb6b7ba9e0f99888e5999bf172
Gitweb:        https://git.kernel.org/tip/88743470668ef5eb6b7ba9e0f99888e5999bf172
Author:        Alexander Dahl <post@lespocky.de>
AuthorDate:    Tue, 26 May 2020 19:57:49 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Thu, 28 May 2020 20:21:32 +02:00

x86/dma: Fix max PFN arithmetic overflow on 32 bit systems

The intermediate result of the old term (4UL * 1024 * 1024 * 1024) is
4 294 967 296 or 0x100000000 which is no problem on 64 bit systems.
The patch does not change the later overall result of 0x100000 for
MAX_DMA32_PFN (after it has been shifted by PAGE_SHIFT). The new
calculation yields the same result, but does not require 64 bit
arithmetic.

On 32 bit systems the old calculation suffers from an arithmetic
overflow in that intermediate term in braces: 4UL aka unsigned long int
is 4 byte wide and an arithmetic overflow happens (the 0x100000000 does
not fit in 4 bytes), the in braces result is truncated to zero, the
following right shift does not alter that, so MAX_DMA32_PFN evaluates to
0 on 32 bit systems.

That wrong value is a problem in a comparision against MAX_DMA32_PFN in
the init code for swiotlb in pci_swiotlb_detect_4gb() to decide if
swiotlb should be active.  That comparison yields the opposite result,
when compiling on 32 bit systems.

This was not possible before

  1b7e03ef7570 ("x86, NUMA: Enable emulation on 32bit too")

when that MAX_DMA32_PFN was first made visible to x86_32 (and which
landed in v3.0).

In practice this wasn't a problem, unless CONFIG_SWIOTLB is active on
x86-32.

However if one has set CONFIG_IOMMU_INTEL, since

  c5a5dc4cbbf4 ("iommu/vt-d: Don't switch off swiotlb if bounce page is used")

there's a dependency on CONFIG_SWIOTLB, which was not necessarily
active before. That landed in v5.4, where we noticed it in the fli4l
Linux distribution. We have CONFIG_IOMMU_INTEL active on both 32 and 64
bit kernel configs there (I could not find out why, so let's just say
historical reasons).

The effect is at boot time 64 MiB (default size) were allocated for
bounce buffers now, which is a noticeable amount of memory on small
systems like pcengines ALIX 2D3 with 256 MiB memory, which are still
frequently used as home routers.

We noticed this effect when migrating from kernel v4.19 (LTS) to v5.4
(LTS) in fli4l and got that kernel messages for example:

  Linux version 5.4.22 (buildroot@buildroot) (gcc version 7.3.0 (Buildroot 2018.02.8)) #1 SMP Mon Nov 26 23:40:00 CET 2018
  …
  Memory: 183484K/261756K available (4594K kernel code, 393K rwdata, 1660K rodata, 536K init, 456K bss , 78272K reserved, 0K cma-reserved, 0K highmem)
  …
  PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
  software IO TLB: mapped [mem 0x0bb78000-0x0fb78000] (64MB)

The initial analysis and the suggested fix was done by user 'sourcejedi'
at stackoverflow and explicitly marked as GPLv2 for inclusion in the
Linux kernel:

  https://unix.stackexchange.com/a/520525/50007

The new calculation, which does not suffer from that overflow, is the
same as for arch/mips now as suggested by Robin Murphy.

The fix was tested by fli4l users on round about two dozen different
systems, including both 32 and 64 bit archs, bare metal and virtualized
machines.

 [ bp: Massage commit message. ]

Fixes: 1b7e03ef7570 ("x86, NUMA: Enable emulation on 32bit too")
Reported-by: Alan Jenkins <alan.christopher.jenkins@gmail.com>
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Alexander Dahl <post@lespocky.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org
Link: https://unix.stackexchange.com/q/520065/50007
Link: https://web.nettworks.org/bugs/browse/FFL-2560
Link: https://lkml.kernel.org/r/20200526175749.20742-1-post@lespocky.de
---
 arch/x86/include/asm/dma.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/dma.h b/arch/x86/include/asm/dma.h
index 00f7cf4..8e95aa4 100644
--- a/arch/x86/include/asm/dma.h
+++ b/arch/x86/include/asm/dma.h
@@ -74,7 +74,7 @@
 #define MAX_DMA_PFN   ((16UL * 1024 * 1024) >> PAGE_SHIFT)
 
 /* 4GB broken PCI/AGP hardware bus master zone */
-#define MAX_DMA32_PFN ((4UL * 1024 * 1024 * 1024) >> PAGE_SHIFT)
+#define MAX_DMA32_PFN (1UL << (32 - PAGE_SHIFT))
 
 #ifdef CONFIG_X86_32
 /* The maximum address that we can perform a DMA transfer to on this platform */
