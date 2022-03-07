Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B4E4CF713
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237990AbiCGJob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241044AbiCGJlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E51D6D872;
        Mon,  7 Mar 2022 01:39:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2794860F63;
        Mon,  7 Mar 2022 09:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D08C340E9;
        Mon,  7 Mar 2022 09:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645972;
        bh=i6eWzl/jBwIItkoI0ahapdrJ09185ZksOOhX4gEGG0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pbyft/bXq93m406sNkEG+jwu9ljZiF+BHbqUrrwuARIGVvph7bkwi36B0uzcwCAdS
         OgQjWtiqB//gkCYgZ52no1651Z+Prw3ADsgMJ9ML06MvhH2fEBboYoFxz4kay1vzSS
         vaK8E3rmUI1JGhFuSySKdkIvfGh8akjpC64uIflE=
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
Subject: [PATCH 5.15 095/262] hugetlbfs: fix off-by-one error in hugetlb_vmdelete_list()
Date:   Mon,  7 Mar 2022 10:17:19 +0100
Message-Id: <20220307091705.155232526@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 fs/hugetlbfs/inode.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index cdfb1ae78a3f8..54c4e0b0dda4a 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -409,10 +409,11 @@ hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end)
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
 
-- 
2.34.1



