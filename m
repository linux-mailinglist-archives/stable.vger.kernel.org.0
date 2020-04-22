Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1461B4042
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgDVKof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:44:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730023AbgDVKSw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:18:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25A9120780;
        Wed, 22 Apr 2020 10:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550731;
        bh=4fFNesi2B7U4ghqft/t2nI+a1ZdnPbr9W+VFIRsKftg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y9HWymyG8jkaBLAWctgaAxdOgQyaBUxgNCnIrN9+OW3NLP/k/NCI7iFaUoISPjuPx
         gV/eViuX79ucdf6bIN8edofg8qWsvaNFSJklFQQ+lu9284nzAljyibmqvlvyvrDR2T
         GMHOKRpJ6T8yzYe6ybIw6ePhrXwdmw3/jznMMDjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Baoquan He <bhe@redhat.com>,
        Nishanth Aravamudan <nacc@us.ibm.com>,
        Nick Piggin <npiggin@suse.de>, Adam Litke <agl@us.ibm.com>,
        Andi Kleen <ak@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/118] mm/hugetlb: fix build failure with HUGETLB_PAGE but not HUGEBTLBFS
Date:   Wed, 22 Apr 2020 11:57:10 +0200
Message-Id: <20200422095043.174015180@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

[ Upstream commit bb297bb2de517e41199185021f043bbc5d75b377 ]

When CONFIG_HUGETLB_PAGE is set but not CONFIG_HUGETLBFS, the following
build failure is encoutered:

  In file included from arch/powerpc/mm/fault.c:33:0:
  include/linux/hugetlb.h: In function 'hstate_inode':
  include/linux/hugetlb.h:477:9: error: implicit declaration of function 'HUGETLBFS_SB' [-Werror=implicit-function-declaration]
    return HUGETLBFS_SB(i->i_sb)->hstate;
           ^
  include/linux/hugetlb.h:477:30: error: invalid type argument of '->' (have 'int')
    return HUGETLBFS_SB(i->i_sb)->hstate;
                                ^

Gate hstate_inode() with CONFIG_HUGETLBFS instead of CONFIG_HUGETLB_PAGE.

Fixes: a137e1cc6d6e ("hugetlbfs: per mount huge page sizes")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Link: http://lkml.kernel.org/r/7e8c3a3c9a587b9cd8a2f146df32a421b961f3a2.1584432148.git.christophe.leroy@c-s.fr
Link: https://patchwork.ozlabs.org/patch/1255548/#2386036
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hugetlb.h | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 53fc34f930d08..8a03f392f3680 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -298,7 +298,10 @@ static inline bool is_file_hugepages(struct file *file)
 	return is_file_shm_hugepages(file);
 }
 
-
+static inline struct hstate *hstate_inode(struct inode *i)
+{
+	return HUGETLBFS_SB(i->i_sb)->hstate;
+}
 #else /* !CONFIG_HUGETLBFS */
 
 #define is_file_hugepages(file)			false
@@ -310,6 +313,10 @@ hugetlb_file_setup(const char *name, size_t size, vm_flags_t acctflag,
 	return ERR_PTR(-ENOSYS);
 }
 
+static inline struct hstate *hstate_inode(struct inode *i)
+{
+	return NULL;
+}
 #endif /* !CONFIG_HUGETLBFS */
 
 #ifdef HAVE_ARCH_HUGETLB_UNMAPPED_AREA
@@ -379,11 +386,6 @@ extern unsigned int default_hstate_idx;
 
 #define default_hstate (hstates[default_hstate_idx])
 
-static inline struct hstate *hstate_inode(struct inode *i)
-{
-	return HUGETLBFS_SB(i->i_sb)->hstate;
-}
-
 static inline struct hstate *hstate_file(struct file *f)
 {
 	return hstate_inode(file_inode(f));
@@ -636,11 +638,6 @@ static inline struct hstate *hstate_vma(struct vm_area_struct *vma)
 	return NULL;
 }
 
-static inline struct hstate *hstate_inode(struct inode *i)
-{
-	return NULL;
-}
-
 static inline struct hstate *page_hstate(struct page *page)
 {
 	return NULL;
-- 
2.20.1



