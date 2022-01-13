Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C7F48DF64
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 22:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234861AbiAMVI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 16:08:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46356 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiAMVIZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 16:08:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3808BB82380;
        Thu, 13 Jan 2022 21:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48DAC36AE3;
        Thu, 13 Jan 2022 21:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642108103;
        bh=VFEtRmkBG783GINGo9/2Ud9BDYd4r8hnGCuCp07GMII=;
        h=Date:From:To:Subject:From;
        b=L8uDT9U03hOWlkKVNRR0KD2LqUt+loTw57UDqHw5H5KBtpfzfqVSFlzoyf5P4gkGB
         vLjSIXd+jijG8Btm04bmFZEjihSXeDVacrVSv35bs8Vt+AveZZ3RJBb8pIizBaqZ9c
         lbatvP9ZDdfzXpSLT8WHsY3dDpa5p5sdSX59HhbY=
Date:   Thu, 13 Jan 2022 13:08:22 -0800
From:   akpm@linux-foundation.org
To:     agruenba@redhat.com, catalin.marinas@arm.com, dsterba@suse.com,
        josef@toxicpanda.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk, will@kernel.org,
        willy@infradead.org
Subject:  [to-be-updated]
 arm64-add-support-for-sub-page-faults-user-probing.patch removed from -mm
 tree
Message-ID: <20220113210822.dPjzRdu-S%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: arm64: add support for sub-page faults user probing
has been removed from the -mm tree.  Its filename was
     arm64-add-support-for-sub-page-faults-user-probing.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: arm64: add support for sub-page faults user probing

With MTE, even if the pte allows an access, a mismatched tag somewhere
within a page can still cause a fault.  Select ARCH_HAS_SUBPAGE_FAULTS if
MTE is enabled and implement probe_user_writeable().

Link: https://lkml.kernel.org/r/20211124192024.2408218-3-catalin.marinas@arm.com
Fixes: a48b73eca4ce ("btrfs: fix potential deadlock in the search ioctl") 
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig               |    1 
 arch/arm64/include/asm/uaccess.h |   33 +++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

--- a/arch/arm64/include/asm/uaccess.h~arm64-add-support-for-sub-page-faults-user-probing
+++ a/arch/arm64/include/asm/uaccess.h
@@ -479,4 +479,37 @@ static inline int __copy_from_user_flush
 }
 #endif
 
+#ifdef CONFIG_ARCH_HAS_SUBPAGE_FAULTS
+static inline size_t __mte_probe_user_range(const char __user *uaddr,
+					    size_t size)
+{
+	const char __user *end = uaddr + size;
+	int err = 0;
+	char val;
+
+	uaddr = PTR_ALIGN_DOWN(uaddr, MTE_GRANULE_SIZE);
+	while (uaddr < end) {
+		/*
+		 * A read is sufficient for MTE, the caller should have probed
+		 * for the pte write permission.
+		 */
+		__raw_get_user(val, uaddr, err);
+		if (err)
+			return end - uaddr;
+		uaddr += MTE_GRANULE_SIZE;
+	}
+	(void)val;
+
+	return 0;
+}
+
+static inline size_t probe_user_writable(const void __user *uaddr,
+					 size_t size)
+{
+	if (!system_supports_mte())
+		return 0;
+	return __mte_probe_user_range(uaddr, size);
+}
+#endif /* CONFIG_ARCH_HAS_SUBPAGE_FAULTS */
+
 #endif /* __ASM_UACCESS_H */
--- a/arch/arm64/Kconfig~arm64-add-support-for-sub-page-faults-user-probing
+++ a/arch/arm64/Kconfig
@@ -1777,6 +1777,7 @@ config ARM64_MTE
 	depends on AS_HAS_LSE_ATOMICS
 	# Required for tag checking in the uaccess routines
 	depends on ARM64_PAN
+	select ARCH_HAS_SUBPAGE_FAULTS
 	select ARCH_USES_HIGH_VMA_FLAGS
 	help
 	  Memory Tagging (part of the ARMv8.5 Extensions) provides
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

btrfs-avoid-live-lock-in-search_ioctl-on-hardware-with-sub-page-faults.patch

