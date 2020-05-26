Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9F21E2994
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 20:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgEZSDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:03:47 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:59199 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728151AbgEZSDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 14:03:47 -0400
Received: from methusalix.internal.home.lespocky.de ([92.117.38.248]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1MqbDs-1jHnZO2ljU-00mdJw; Tue, 26 May 2020 20:02:54 +0200
Received: from lemmy.internal.home.lespocky.de ([192.168.243.176] helo=lemmy.home.lespocky.de)
        by methusalix.internal.home.lespocky.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.93.0.4)
        (envelope-from <alex@home.lespocky.de>)
        id 1jddub-00014I-G9; Tue, 26 May 2020 20:02:51 +0200
Received: (nullmailer pid 21056 invoked by uid 2001);
        Tue, 26 May 2020 18:02:49 -0000
From:   Alexander Dahl <post@lespocky.de>
To:     x86@kernel.org
Cc:     iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Alan Jenkins <alan.christopher.jenkins@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Florian Wolters <florian@florian-wolters.de>,
        Alexander Dahl <post@lespocky.de>, stable@vger.kernel.org
Subject: [PATCH v3] dma: Fix max PFN arithmetic overflow on 32 bit systems
Date:   Tue, 26 May 2020 19:57:49 +0200
Message-Id: <20200526175749.20742-1-post@lespocky.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scan-Signature: da60a1f87c2bd0fec1a92ee75d71daf0
X-Spam-Score: -2.9 (--)
X-Provags-ID: V03:K1:RU0d4InmKG43aVsuzP1TdFNT000xXVh0lJi3Xhuudqtalhc25M0
 xrTsa0sXhkoBbi8Bf1GXwburAlDeTBs8b6toisYHzR8wvRgJ9w6m1JjofqU/liNHR6hqt7/
 48hSjW2bZCgyFjEyQP4mMduSvaLpBlu05UWXNnR6Fxz5SwsUCre6es2vOz66+/LQMSknaHT
 CYpOOaghPKt40QB77o+3Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:wlxuTnZ1S80=:DGndYjAOdRIaa7nc1mImo4
 I6csZf45XfygC8KkBDX9LtzgkOXv3lV9fRbVyyjflaHlrT3J42VwyEjh1IAAjH4md4cRwiRJM
 EoO/voisoUjz0/CNsyivmJpMHDGIN08u0HLv92/I0D8KtqYL7AIiPJFre5EOubZBpUOpZn0Yv
 eXs9ViwG94jfeIVdcDCo6YAw4Ycfw5rOjJG6FU2fUC4pf9BNIVZOM13/LIBwwz8Ccr5wXBLP1
 OkvhXigbXMWEKe6blytvb5147FRSOhdclR1aeQ992Igdh4rTWFY5um5BoxhUsNHxHFwzCbULj
 2OeA0h6m5xZWImJrbr4e0yEziRFTS9Ube+4fynboKld7b7K3BM+jzuRVL+TrWuzpBar1/rxme
 p2WqWPQ4FbIUGteohwAkJeGuOkF3NfAQWcL7EMRQLxkSPgwXlRtyyDGpOHG8HbaZFZVEKtCNU
 E+VSD0QX2ABRy+z70H8BGlRotGYbVc/+URJVEzjgyYBKuJmyU33vVi2+GCXx1H0AOFoXScIdq
 PNJ5cm0dcHg5sFkdsxU0+79iiUU443g1xekCC23x8lP4VqDhi0ky/RyZu/bxWeV1j+N2AU9ZD
 5my+Iob6aB090X0xN+JXztsF/zdf/mvMMH9XT9XqzCzQNKK6OTQa7/zxTdip0HO8MDIPGFw50
 LJO66lfCsdcA2uJwoagtBFfNmjU0DCS+/84m7ABriJ1F4YQT948KyFr5SlpZeeG2DehacuLi3
 cljsg069LnfwpovUOIdriub9VEglpUXivHtbTuOuu4PabkQVWvfhipLBxNsiRfwpei86mMaF8
 TrnCph4xZNgL5Qk43x0u21xY7zDWMMedM/xHERJH2rBEv5ldksEQX3MkN3Be7f81PVJ0k2L
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The intermediate result of the old term (4UL * 1024 * 1024 * 1024) is
4 294 967 296 or 0x100000000 which is no problem on 64 bit systems.  The
patch does not change the later overall result of 0x100000 for
MAX_DMA32_PFN.  The new calculation yields the same result, but does not
require 64 bit arithmetic.

On 32 bit systems the old calculation suffers from an arithmetic
overflow in that intermediate term in braces: 4UL aka unsigned long int
is 4 byte wide and an arithmetic overflow happens (the 0x100000000 does
not fit in 4 bytes), the in braces result is truncated to zero, the
following right shift does not alter that, so MAX_DMA32_PFN evaluates to
0 on 32 bit systems.

That wrong value is a problem in a comparision against MAX_DMA32_PFN in
the init code for swiotlb in 'pci_swiotlb_detect_4gb()' to decide if
swiotlb should be active.  That comparison yields the opposite result,
when compiling on 32 bit systems.

This was not possible before 1b7e03ef7570 ("x86, NUMA: Enable emulation
on 32bit too") when that MAX_DMA32_PFN was first made visible to x86_32
(and which landed in v3.0).

In practice this wasn't a problem, unless you activated CONFIG_SWIOTLB
on x86 (32 bit).

However for ARCH=x86 (32 bit) and if you have set CONFIG_IOMMU_INTEL,
since c5a5dc4cbbf4 ("iommu/vt-d: Don't switch off swiotlb if bounce page
is used") there's a dependency on CONFIG_SWIOTLB, which was not
necessarily active before.  That landed in v5.4, where we noticed it in
the fli4l Linux distribution.  We have CONFIG_IOMMU_INTEL active on both
32 and 64 bit kernel configs there (I could not find out why, so let's
just say historical reasons).

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

Fixes: 1b7e03ef7570 ("x86, NUMA: Enable emulation on 32bit too")
Fixes: https://web.nettworks.org/bugs/browse/FFL-2560
Fixes: https://unix.stackexchange.com/q/520065/50007
Reported-by: Alan Jenkins <alan.christopher.jenkins@gmail.com>
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Alexander Dahl <post@lespocky.de>
Cc: stable@vger.kernel.org
---

Notes:
    v3:
      - rewritten commit message to better explain that arithmetic overflow
        and added Fixes tag (Greg Kroah-Hartman)
      - rebased on v5.7-rc7
    
    v2:
      - use the same calculation as with arch/mips (Robin Murphy)

 arch/x86/include/asm/dma.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/dma.h b/arch/x86/include/asm/dma.h
index 00f7cf45e699..8e95aa4b0d17 100644
--- a/arch/x86/include/asm/dma.h
+++ b/arch/x86/include/asm/dma.h
@@ -74,7 +74,7 @@
 #define MAX_DMA_PFN   ((16UL * 1024 * 1024) >> PAGE_SHIFT)
 
 /* 4GB broken PCI/AGP hardware bus master zone */
-#define MAX_DMA32_PFN ((4UL * 1024 * 1024 * 1024) >> PAGE_SHIFT)
+#define MAX_DMA32_PFN (1UL << (32 - PAGE_SHIFT))
 
 #ifdef CONFIG_X86_32
 /* The maximum address that we can perform a DMA transfer to on this platform */
-- 
2.20.1

