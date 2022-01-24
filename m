Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776144995F4
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356418AbiAXU5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:57:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47078 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442172AbiAXUxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:53:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A69D960C60;
        Mon, 24 Jan 2022 20:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775F7C340E7;
        Mon, 24 Jan 2022 20:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057620;
        bh=j6BIUp+UvD5pzXwiUtAQyP7yzx8R7qTuo7sUGKPGpXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=12cZUUAzoKdelutUtKMh1uglytB5e05tsjrjb8TmKFDmwWx5xVYWFzhsY/bUQku5r
         fVggF+D6TvF7PjI+m9dye+d0nEC9dAwsvQ6MxiaQ3x1JQ/mbkjQc3nBg942Ods3AM/
         u6EIkJ6xQe3gmbt2aZQjAogA51g6MtSh6WLd2YMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Kossifidis <mick@ics.forth.gr>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.16 0025/1039] riscv: try to allocate crashkern region from 32bit addressible memory
Date:   Mon, 24 Jan 2022 19:30:14 +0100
Message-Id: <20220124184125.982757510@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
@@ -812,13 +812,22 @@ static void __init reserve_crashkernel(v
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


