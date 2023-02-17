Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90A869B628
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 00:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjBQXHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 18:07:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBQXHv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 18:07:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2914935A2;
        Fri, 17 Feb 2023 15:07:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B26BEB82EA8;
        Fri, 17 Feb 2023 23:07:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E46BC433EF;
        Fri, 17 Feb 2023 23:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676675267;
        bh=5rGwQ3tckpOjFR4YPo2nCylgN54ytSjPUWh0jo6H/kQ=;
        h=Date:To:From:Subject:From;
        b=SKglvq8kpHtbVbfzi6Un2LMvMoR19Bnqa8JVUI+rIlcgAqW8RJZBO7dWlkHAG1Idx
         A0VnDXvB2YoNC5ht5pVJAdndBZdb9safIx/zr9yedupigr5B4AnyM2buGCmf3qoLZJ
         yZBgVoJIFSVsiW06ivmy3z7LTknoWecvTqmf5cA8=
Date:   Fri, 17 Feb 2023 15:07:46 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, sashal@kernel.org,
        naresh.kamboju@linaro.org, lkft@linaro.org, jesperjuhl76@gmail.com,
        anders.roxell@linaro.org, ak@linux.intel.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] hugetlb-check-for-undefined-shift-on-32-bit-architectures.patch removed from -mm tree
Message-Id: <20230217230747.5E46BC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: check for undefined shift on 32 bit architectures
has been removed from the -mm tree.  Its filename was
     hugetlb-check-for-undefined-shift-on-32-bit-architectures.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: check for undefined shift on 32 bit architectures
Date: Wed, 15 Feb 2023 17:35:42 -0800

Users can specify the hugetlb page size in the mmap, shmget and
memfd_create system calls.  This is done by using 6 bits within the flags
argument to encode the base-2 logarithm of the desired page size.  The
routine hstate_sizelog() uses the log2 value to find the corresponding
hugetlb hstate structure.  Converting the log2 value (page_size_log) to
potential hugetlb page size is the simple statement:

	1UL << page_size_log

Because only 6 bits are used for page_size_log, the left shift can not be
greater than 63.  This is fine on 64 bit architectures where a long is 64
bits.  However, if a value greater than 31 is passed on a 32 bit
architecture (where long is 32 bits) the shift will result in undefined
behavior.  This was generally not an issue as the result of the undefined
shift had to exactly match hugetlb page size to proceed.

Recent improvements in runtime checking have resulted in this undefined
behavior throwing errors such as reported below.

Fix by comparing page_size_log to BITS_PER_LONG before doing shift.

Link: https://lkml.kernel.org/r/20230216013542.138708-1-mike.kravetz@oracle.com
Link: https://lore.kernel.org/lkml/CA+G9fYuei_Tr-vN9GS7SfFyU1y9hNysnf=PB7kT0=yv4MiPgVg@mail.gmail.com/
Fixes: 42d7395feb56 ("mm: support more pagesizes for MAP_HUGETLB/SHM_HUGETLB")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reviewed-by: Jesper Juhl <jesperjuhl76@gmail.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/hugetlb.h~hugetlb-check-for-undefined-shift-on-32-bit-architectures
+++ a/include/linux/hugetlb.h
@@ -743,7 +743,10 @@ static inline struct hstate *hstate_size
 	if (!page_size_log)
 		return &default_hstate;
 
-	return size_to_hstate(1UL << page_size_log);
+	if (page_size_log < BITS_PER_LONG)
+		return size_to_hstate(1UL << page_size_log);
+
+	return NULL;
 }
 
 static inline struct hstate *hstate_vma(struct vm_area_struct *vma)
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


