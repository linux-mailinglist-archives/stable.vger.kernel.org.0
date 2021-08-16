Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D3A3EDEB2
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 22:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhHPUfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 16:35:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231748AbhHPUfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 16:35:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C94060F46;
        Mon, 16 Aug 2021 20:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629146111;
        bh=gQMi8VdKS1kJI2/BdiMSJAgplu244t+vr/AMMDM6Y4Y=;
        h=Date:From:To:Subject:From;
        b=WsN+lQwPeJD11bykI8AHgyd1azJMMrvcMWkYviH0yJuf2/BySnWfj+MZryIH2rOqd
         9bmm2NIqbvMHzYoq/QohI/qSNi13lbjBn/QXQRRQMt0+ssLF/OIXWh+pg2jtRsxC6B
         zBoBSPpCTucuw2KGO5vurpx6tncRHtMbqIk1YzfM=
Date:   Mon, 16 Aug 2021 13:35:11 -0700
From:   akpm@linux-foundation.org
To:     gregkh@linuxfoundation.org, linux@armlinux.org.uk,
        mcgrof@kernel.org, mm-commits@vger.kernel.org,
        nixiaoming@huawei.com, palmerdabbelt@google.com,
        stable@vger.kernel.org, wangkefeng.wang@huawei.com,
        wangliang101@huawei.com
Subject:  [merged] lib-use-pfn_phys-in-devmem_is_allowed.patch
 removed from -mm tree
Message-ID: <20210816203511.K2fX9guWK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: lib: use PFN_PHYS() in devmem_is_allowed()
has been removed from the -mm tree.  Its filename was
     lib-use-pfn_phys-in-devmem_is_allowed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liang Wang <wangliang101@huawei.com>
Subject: lib: use PFN_PHYS() in devmem_is_allowed()

The physical address may exceed 32 bits on 32-bit systems with more than
32 bits of physcial address.  Use PFN_PHYS() in devmem_is_allowed(), or
the physical address may overflow and be truncated.

We found this bug when mapping a high addresses through devmem tool, when
CONFIG_STRICT_DEVMEM is enabled on the ARM with ARM_LPAE and devmem is
used to map a high address that is not in the iomem address range, an
unexpected error indicating no permission is returned.

This bug was initially introduced from v2.6.37, and the function was moved
to lib when v5.11.

Link: https://lkml.kernel.org/r/20210731025057.78825-1-wangliang101@huawei.com
Fixes: 087aaffcdf9c ("ARM: implement CONFIG_STRICT_DEVMEM by disabling access to RAM via /dev/mem")
Fixes: 527701eda5f1 ("lib: Add a generic version of devmem_is_allowed()")
Signed-off-by: Liang Wang <wangliang101@huawei.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Liang Wang <wangliang101@huawei.com>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[2.6.37+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/devmem_is_allowed.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/devmem_is_allowed.c~lib-use-pfn_phys-in-devmem_is_allowed
+++ a/lib/devmem_is_allowed.c
@@ -19,7 +19,7 @@
  */
 int devmem_is_allowed(unsigned long pfn)
 {
-	if (iomem_is_exclusive(pfn << PAGE_SHIFT))
+	if (iomem_is_exclusive(PFN_PHYS(pfn)))
 		return 0;
 	if (!page_is_ram(pfn))
 		return 1;
_

Patches currently in -mm which might be from wangliang101@huawei.com are


