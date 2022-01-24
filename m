Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC1C4991A1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348775AbiAXUMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:12:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52138 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243916AbiAXUKt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:10:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E57BB811FB;
        Mon, 24 Jan 2022 20:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6131C340E5;
        Mon, 24 Jan 2022 20:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055043;
        bh=7lLkkm2hMmoAH1d6/BJ0zjj/pNAbPcKrce/ofU2nTdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XpYPZGxWKXgV9fBNoHjBM6Bgw8t2N0serTXXEKNhT9Y2LTP6aWeuoXielv5eLz4KY
         S7+8HA3GaEwWByg5ncOk0BKEYXH1JzUrH22ZuEnnmj8160Xy5OAHvuTRE3JIRJShHV
         iUhJOlGJCPBWBlnxvkvwx3P5ztUSXAFIll2uwQWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Kossifidis <mick@ics.forth.gr>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 023/846] riscv: try to allocate crashkern region from 32bit addressible memory
Date:   Mon, 24 Jan 2022 19:32:20 +0100
Message-Id: <20220124184101.723193388@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Kossifidis <mick@ics.forth.gr>

commit decf89f86ecd3c3c3de81c562010d5797bea3de1 upstream.

When allocating crash kernel region without explicitly specifying its
base address/size, memblock_phys_alloc_range will attempt to allocate
memory top to bottom (memblock.bottom_up is false), so the crash
kernel region will end up in highmem on 64bit systems. This way
swiotlb can't work on the crash kernel, since there won't be any
32bit addressible memory available for the bounce buffers.

Try to allocate 32bit addressible memory if available, for the
crash kernel by restricting the top search address to be less
than SZ_4G. If that fails fallback to the previous behavior.

I tested this on HiFive Unmatched where the pci-e controller needs
swiotlb to work, with this patch it's possible to access the pci-e
controller on crash kernel and mount the rootfs from the nvme.

Signed-off-by: Nick Kossifidis <mick@ics.forth.gr>
Fixes: e53d28180d4d ("RISC-V: Add kdump support")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/init.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -813,13 +813,22 @@ static void __init reserve_crashkernel(v
 	/*
 	 * Current riscv boot protocol requires 2MB alignment for
 	 * RV64 and 4MB alignment for RV32 (hugepage size)
+	 *
+	 * Try to alloc from 32bit addressible physical memory so that
+	 * swiotlb can work on the crash kernel.
 	 */
 	crash_base = memblock_phys_alloc_range(crash_size, PMD_SIZE,
-					       search_start, search_end);
+					       search_start,
+					       min(search_end, (unsigned long) SZ_4G));
 	if (crash_base == 0) {
-		pr_warn("crashkernel: couldn't allocate %lldKB\n",
-			crash_size >> 10);
-		return;
+		/* Try again without restricting region to 32bit addressible memory */
+		crash_base = memblock_phys_alloc_range(crash_size, PMD_SIZE,
+						search_start, search_end);
+		if (crash_base == 0) {
+			pr_warn("crashkernel: couldn't allocate %lldKB\n",
+				crash_size >> 10);
+			return;
+		}
 	}
 
 	pr_info("crashkernel: reserved 0x%016llx - 0x%016llx (%lld MB)\n",


