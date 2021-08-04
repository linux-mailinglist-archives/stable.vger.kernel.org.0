Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9303C3DF8E2
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 02:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234610AbhHDAWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 20:22:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233759AbhHDAWC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Aug 2021 20:22:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B331F60F46;
        Wed,  4 Aug 2021 00:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628036509;
        bh=s/ruTlnn1ChuucTiostqFTQUlcvakiAUmn7lWJLSI6M=;
        h=Date:From:To:Subject:From;
        b=DO5urH0QGHCyYeDI9iCGWxAn/wXrhnwrgHXS7ZiZih2DyKytcaFha8vNpEsrAHmNO
         pemUHboBZn80vPsHhfp7aE+zDRzqTsOtiU4kmv//ZJ/ITOccymCKCUGeZMwuh5SZ0W
         /L/Zqj8dv2Q66s37RQiL0FBo617jKBF6ksPa1Z8s=
Date:   Tue, 03 Aug 2021 17:21:48 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        stable@vger.kernel.org, palmerdabbelt@google.com,
        nixiaoming@huawei.com, mcgrof@kernel.org, linux@armlinux.org.uk,
        gregkh@linuxfoundation.org, wangliang101@huawei.com
Subject:  + lib-use-pfn_phys-in-devmem_is_allowed.patch added to -mm
 tree
Message-ID: <20210804002148.96Sth%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: lib: use PFN_PHYS() in devmem_is_allowed()
has been added to the -mm tree.  Its filename is
     lib-use-pfn_phys-in-devmem_is_allowed.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-use-pfn_phys-in-devmem_is_allowed.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-use-pfn_phys-in-devmem_is_allowed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liang Wang <wangliang101@huawei.com>
Subject: lib: use PFN_PHYS() in devmem_is_allowed()

The physical address may exceed 32 bits on 32-bit systems with more than
32 bits of physcial address,use PFN_PHYS() in devmem_is_allowed(), or the
physical address may overflow and be truncated.

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
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
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

lib-use-pfn_phys-in-devmem_is_allowed.patch

