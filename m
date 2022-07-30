Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4645D5857B4
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 03:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239764AbiG3BJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 21:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239591AbiG3BIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 21:08:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80F087221;
        Fri, 29 Jul 2022 18:08:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96D7AB82926;
        Sat, 30 Jul 2022 01:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA44C433D7;
        Sat, 30 Jul 2022 01:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143315;
        bh=jdOQcJDQs1cHInz97O9LsgfylMp7cnPLylY9wbziNs0=;
        h=Date:To:From:Subject:From;
        b=UlYcjC2snOt9idpuFrK0TbHG50/yIIxjDc2T1swCRjP7hK+b8NGdvl4Y7Dsoccu4S
         8fzluHPDI4bJlrMU6ow+uP38ibKFa0w6G47X00ZIbdi7NisPtTgqe+wYud6ChAOTCo
         9osKYuKCNlpkjlL1EDhAKOTd/OFDOImrWkWXM1OU=
Date:   Fri, 29 Jul 2022 18:08:34 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, shakeelb@google.com,
        mike.kravetz@oracle.com, keescook@chromium.org,
        almasrymina@google.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb_cgroup-fix-wrong-hugetlb-cgroup-numa-stat.patch removed from -mm tree
Message-Id: <20220730010835.2BA44C433D7@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: hugetlb_cgroup: fix wrong hugetlb cgroup numa stat
has been removed from the -mm tree.  Its filename was
     hugetlb_cgroup-fix-wrong-hugetlb-cgroup-numa-stat.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

