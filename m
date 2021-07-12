Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3447E3C4AFC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238574AbhGLGzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236674AbhGLGx1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:53:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83835610D0;
        Mon, 12 Jul 2021 06:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072638;
        bh=fsXzZU99CNoQrO+dXEfkeHAuHSfCDX2X0HKResemX5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=briAex5uVBS7PPMUWfoIwBqYTKnW0Rh7GCIfTsUYBIleMQ4DxrtxQuLVPj9BFfhjf
         i94iG3uCBFp8IB5KHeQIduRYLVHTOI+a5ZhfpM3z10UHuGZTIaxLYB/7fahsvXTVj5
         VDtr8YgR9OezGSr/1AgvAGaA1oGI2F6te0zssGKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Jan Kara <jack@suse.cz>, David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 562/593] mm/pmem: avoid inserting hugepage PTE entry with fsdax if hugepage support is disabled
Date:   Mon, 12 Jul 2021 08:12:02 +0200
Message-Id: <20210712060956.508914388@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

[ Upstream commit bae84953815793f68ddd8edeadd3f4e32676a2c8 ]

Differentiate between hardware not supporting hugepages and user disabling
THP via 'echo never > /sys/kernel/mm/transparent_hugepage/enabled'

For the devdax namespace, the kernel handles the above via the
supported_alignment attribute and failing to initialize the namespace if
the namespace align value is not supported on the platform.

For the fsdax namespace, the kernel will continue to initialize the
namespace.  This can result in the kernel creating a huge pte entry even
though the hardware don't support the same.

We do want hugepage support with pmem even if the end-user disabled THP
via sysfs file (/sys/kernel/mm/transparent_hugepage/enabled).  Hence
differentiate between hardware/firmware lacking support vs user-controlled
disable of THP and prevent a huge fault if the hardware lacks hugepage
support.

Link: https://lkml.kernel.org/r/20210205023956.417587-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/huge_mm.h | 15 +++++++++------
 mm/huge_memory.c        |  6 +++++-
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index ff55be011739..10c7a80a0394 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -84,6 +84,7 @@ static inline vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn,
 }
 
 enum transparent_hugepage_flag {
+	TRANSPARENT_HUGEPAGE_NEVER_DAX,
 	TRANSPARENT_HUGEPAGE_FLAG,
 	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
@@ -129,6 +130,13 @@ extern unsigned long transparent_hugepage_flags;
  */
 static inline bool __transparent_hugepage_enabled(struct vm_area_struct *vma)
 {
+
+	/*
+	 * If the hardware/firmware marked hugepage support disabled.
+	 */
+	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_NEVER_DAX))
+		return false;
+
 	if (vma->vm_flags & VM_NOHUGEPAGE)
 		return false;
 
@@ -140,12 +148,7 @@ static inline bool __transparent_hugepage_enabled(struct vm_area_struct *vma)
 
 	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_FLAG))
 		return true;
-	/*
-	 * For dax vmas, try to always use hugepage mappings. If the kernel does
-	 * not support hugepages, fsdax mappings will fallback to PAGE_SIZE
-	 * mappings, and device-dax namespaces, that try to guarantee a given
-	 * mapping size, will fail to enable
-	 */
+
 	if (vma_is_dax(vma))
 		return true;
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6301ecc1f679..f1432d4d81c7 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -375,7 +375,11 @@ static int __init hugepage_init(void)
 	struct kobject *hugepage_kobj;
 
 	if (!has_transparent_hugepage()) {
-		transparent_hugepage_flags = 0;
+		/*
+		 * Hardware doesn't support hugepages, hence disable
+		 * DAX PMD support.
+		 */
+		transparent_hugepage_flags = 1 << TRANSPARENT_HUGEPAGE_NEVER_DAX;
 		return -EINVAL;
 	}
 
-- 
2.30.2



