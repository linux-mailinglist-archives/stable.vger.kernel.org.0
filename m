Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B502C091F
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732349AbgKWNEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:04:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:35630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733261AbgKWMvQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:51:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7E0821534;
        Mon, 23 Nov 2020 12:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135874;
        bh=CNVyWDcJmxhiqIkKUnVmz5LTp9JQpGZhhdzVagJ5vW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u7xMQrhAapsYLD93MKNliEj4PNGGsMIXiuURIknVXwN06CEcuZs8J0QOmLwNEWzsB
         w/TOte7ZEno4vuBnlwLwaKqYYyerbjPMcarABoGimS3vYUcMRP8R351cbjSK1W0aA0
         qOYJK5aF9/seIc6Ajt06ttnRjaTcXvmJy6EfZ3fc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5.9 227/252] xtensa: fix TLBTEMP area placement
Date:   Mon, 23 Nov 2020 13:22:57 +0100
Message-Id: <20201123121846.534657703@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

commit 481535c5b41d191b22775a6873de5ec0e1cdced1 upstream.

fast_second_level_miss handler for the TLBTEMP area has an assumption
that page table directory entry for the TLBTEMP address range is 0. For
it to be true the TLBTEMP area must be aligned to 4MB boundary and not
share its 4MB region with anything that may use a page table. This is
not true currently: TLBTEMP shares space with vmalloc space which
results in the following kinds of runtime errors when
fast_second_level_miss loads page table directory entry for the vmalloc
space instead of fixing up the TLBTEMP area:

 Unable to handle kernel paging request at virtual address c7ff0e00
  pc = d0009275, ra = 90009478
 Oops: sig: 9 [#1] PREEMPT
 CPU: 1 PID: 61 Comm: kworker/u9:2 Not tainted 5.10.0-rc3-next-20201110-00007-g1fe4962fa983-dirty #58
 Workqueue: xprtiod xs_stream_data_receive_workfn
 a00: 90009478 d11e1dc0 c7ff0e00 00000020 c7ff0000 00000001 7f8b8107 00000000
 a08: 900c5992 d11e1d90 d0cc88b8 5506e97c 00000000 5506e97c d06c8074 d11e1d90
 pc: d0009275, ps: 00060310, depc: 00000014, excvaddr: c7ff0e00
 lbeg: d0009275, lend: d0009287 lcount: 00000003, sar: 00000010
 Call Trace:
   xs_stream_data_receive_workfn+0x43c/0x770
   process_one_work+0x1a1/0x324
   worker_thread+0x1cc/0x3c0
   kthread+0x10d/0x124
   ret_from_kernel_thread+0xc/0x18

Cc: stable@vger.kernel.org
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/xtensa/mmu.rst      |    9 ++++++---
 arch/xtensa/include/asm/pgtable.h |    2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/Documentation/xtensa/mmu.rst
+++ b/Documentation/xtensa/mmu.rst
@@ -82,7 +82,8 @@ Default MMUv2-compatible layout::
   +------------------+
   | VMALLOC area     |  VMALLOC_START            0xc0000000  128MB - 64KB
   +------------------+  VMALLOC_END
-  | Cache aliasing   |  TLBTEMP_BASE_1           0xc7ff0000  DCACHE_WAY_SIZE
+  +------------------+
+  | Cache aliasing   |  TLBTEMP_BASE_1           0xc8000000  DCACHE_WAY_SIZE
   | remap area 1     |
   +------------------+
   | Cache aliasing   |  TLBTEMP_BASE_2                       DCACHE_WAY_SIZE
@@ -124,7 +125,8 @@ Default MMUv2-compatible layout::
   +------------------+
   | VMALLOC area     |  VMALLOC_START            0xa0000000  128MB - 64KB
   +------------------+  VMALLOC_END
-  | Cache aliasing   |  TLBTEMP_BASE_1           0xa7ff0000  DCACHE_WAY_SIZE
+  +------------------+
+  | Cache aliasing   |  TLBTEMP_BASE_1           0xa8000000  DCACHE_WAY_SIZE
   | remap area 1     |
   +------------------+
   | Cache aliasing   |  TLBTEMP_BASE_2                       DCACHE_WAY_SIZE
@@ -167,7 +169,8 @@ Default MMUv2-compatible layout::
   +------------------+
   | VMALLOC area     |  VMALLOC_START            0x90000000  128MB - 64KB
   +------------------+  VMALLOC_END
-  | Cache aliasing   |  TLBTEMP_BASE_1           0x97ff0000  DCACHE_WAY_SIZE
+  +------------------+
+  | Cache aliasing   |  TLBTEMP_BASE_1           0x98000000  DCACHE_WAY_SIZE
   | remap area 1     |
   +------------------+
   | Cache aliasing   |  TLBTEMP_BASE_2                       DCACHE_WAY_SIZE
--- a/arch/xtensa/include/asm/pgtable.h
+++ b/arch/xtensa/include/asm/pgtable.h
@@ -69,7 +69,7 @@
  */
 #define VMALLOC_START		(XCHAL_KSEG_CACHED_VADDR - 0x10000000)
 #define VMALLOC_END		(VMALLOC_START + 0x07FEFFFF)
-#define TLBTEMP_BASE_1		(VMALLOC_END + 1)
+#define TLBTEMP_BASE_1		(VMALLOC_START + 0x08000000)
 #define TLBTEMP_BASE_2		(TLBTEMP_BASE_1 + DCACHE_WAY_SIZE)
 #if 2 * DCACHE_WAY_SIZE > ICACHE_WAY_SIZE
 #define TLBTEMP_SIZE		(2 * DCACHE_WAY_SIZE)


