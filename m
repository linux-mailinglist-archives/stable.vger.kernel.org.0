Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1CC580432
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 20:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236122AbiGYSrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 14:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiGYSrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 14:47:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322882B1;
        Mon, 25 Jul 2022 11:47:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C172260ED9;
        Mon, 25 Jul 2022 18:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21470C341C6;
        Mon, 25 Jul 2022 18:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658774860;
        bh=eBsZ6f+ACMnNJls1sE0EwiTefDO6vWpt3zJ4rcotMZY=;
        h=Date:To:From:Subject:From;
        b=2GZJo33TZRkieW41SS+xTGRTpWNUCyMg4ttM7VCgLzSHvuaOHn2FSsS/4AKUGPKid
         ZbMEyPPeTkdeB1OHFRoGczlSD5KINBn0jBARoneqXftZsTHIzOEx6V7g/+IkqYbRgx
         a20eWTjLbFFu+NrBauE7Iq27l6d30GkqXoZmIzmY=
Date:   Mon, 25 Jul 2022 11:47:39 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, shakeelb@google.com,
        mike.kravetz@oracle.com, keescook@chromium.org,
        almasrymina@google.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb_cgroup-fix-wrong-hugetlb-cgroup-numa-stat.patch added to mm-unstable branch
Message-Id: <20220725184740.21470C341C6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hugetlb_cgroup: fix wrong hugetlb cgroup numa stat
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb_cgroup-fix-wrong-hugetlb-cgroup-numa-stat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb_cgroup-fix-wrong-hugetlb-cgroup-numa-stat.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlb_cgroup: fix wrong hugetlb cgroup numa stat
Date: Sat, 23 Jul 2022 15:38:04 +0800

We forget to set cft->private for numa stat file.  As a result, numa stat
of hstates[0] is always showed for all hstates.  Encode the hstates index
into cft->private to fix this issue.

Link: https://lkml.kernel.org/r/20220723073804.53035-1-linmiaohe@huawei.com
Fixes: f47761999052 ("hugetlb: add hugetlb.*.numa_stat file")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb_cgroup.c~hugetlb_cgroup-fix-wrong-hugetlb-cgroup-numa-stat
+++ a/mm/hugetlb_cgroup.c
@@ -772,6 +772,7 @@ static void __init __hugetlb_cgroup_file
 	/* Add the numa stat file */
 	cft = &h->cgroup_files_dfl[6];
 	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.numa_stat", buf);
+	cft->private = MEMFILE_PRIVATE(idx, 0);
 	cft->seq_show = hugetlb_cgroup_read_numa_stat;
 	cft->flags = CFTYPE_NOT_ON_ROOT;
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch
mm-remove-obsolete-comment-in-do_fault_around.patch
mm-remove-unneeded-pageanon-check-in-restore_exclusive_pte.patch
mm-mempolicy-remove-unneeded-out-label.patch
hugetlb_cgroup-fix-wrong-hugetlb-cgroup-numa-stat.patch

