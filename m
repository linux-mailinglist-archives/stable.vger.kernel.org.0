Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D743F49A550
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2370771AbiAYAGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385856AbiAXXdz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:33:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A53AC07596B;
        Mon, 24 Jan 2022 13:35:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1906FB81057;
        Mon, 24 Jan 2022 21:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504F2C340E4;
        Mon, 24 Jan 2022 21:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060133;
        bh=a0YiCG/23n5Ij4udWEzbiqQJ3Zz1ama6V6tpi+vrVtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VnHKxBOwKipeZPKX+BQpw9s4r9SLt+UoIvpsOZlmyZsusLd23S6AjKYE9fIqMK62N
         R0AhqEmrMV1DZK464xFpinFeCT5fTh1XllVjGImlZefwqXgQBFT126GUaMKliyyLeX
         VYytnGcfT+7mDF7MDiHiepcs1ldIN29W4BFMOtmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        syzbot+4e697fe80a31aa7efe21@syzkaller.appspotmail.com,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0833/1039] hugetlbfs: fix off-by-one error in hugetlb_vmdelete_list()
Date:   Mon, 24 Jan 2022 19:43:42 +0100
Message-Id: <20220124184153.284397402@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit d6aba4c8e20d4d2bf65d589953f6d891c178f3a3 ]

Pass "end - 1" instead of "end" when walking the interval tree in
hugetlb_vmdelete_list() to fix an inclusive vs.  exclusive bug.  The two
callers that pass a non-zero "end" treat it as exclusive, whereas the
interval tree iterator expects an inclusive "last".  E.g.  punching a
hole in a file that precisely matches the size of a single hugepage,
with a vma starting right on the boundary, will result in
unmap_hugepage_range() being called twice, with the second call having
start==end.

The off-by-one error doesn't cause functional problems as
__unmap_hugepage_range() turns into a massive nop due to
short-circuiting its for-loop on "address < end".  But, the mmu_notifier
invocations to invalid_range_{start,end}() are passed a bogus zero-sized
range, which may be unexpected behavior for secondary MMUs.

The bug was exposed by commit ed922739c919 ("KVM: Use interval tree to
do fast hva lookup in memslots"), currently queued in the KVM tree for
5.17, which added a WARN to detect ranges with start==end.

Link: https://lkml.kernel.org/r/20211228234257.1926057-1-seanjc@google.com
Fixes: 1bfad99ab425 ("hugetlbfs: hugetlb_vmtruncate_list() needs to take a range to delete")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reported-by: syzbot+4e697fe80a31aa7efe21@syzkaller.appspotmail.com
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hugetlbfs/inode.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -409,10 +409,11 @@ hugetlb_vmdelete_list(struct rb_root_cac
 	struct vm_area_struct *vma;
 
 	/*
-	 * end == 0 indicates that the entire range after
-	 * start should be unmapped.
+	 * end == 0 indicates that the entire range after start should be
+	 * unmapped.  Note, end is exclusive, whereas the interval tree takes
+	 * an inclusive "last".
 	 */
-	vma_interval_tree_foreach(vma, root, start, end ? end : ULONG_MAX) {
+	vma_interval_tree_foreach(vma, root, start, end ? end - 1 : ULONG_MAX) {
 		unsigned long v_offset;
 		unsigned long v_end;
 


