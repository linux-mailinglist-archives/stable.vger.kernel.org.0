Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 964D8699F90
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 23:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjBPWAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 17:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjBPWAk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 17:00:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DEBC38656;
        Thu, 16 Feb 2023 14:00:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCFFA60C8E;
        Thu, 16 Feb 2023 22:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DA3C433D2;
        Thu, 16 Feb 2023 22:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676584838;
        bh=BNTWSSeZH1Nsp42jA/ETbgN1awBoreh9NTsVEQ241Zg=;
        h=Date:To:From:Subject:From;
        b=uJESTtY4lk2nEzTsODRH70j4TmLG42s9NMVdCuCVOXw5NaJqVZecQYBSz6B8Nsaym
         +LwCVfyXmNRPiwO7H8zHGVOSF6f/BMHfaOgcyTepiHhVFQIZ1SHfmZYs8WXy1jFAxn
         cwIkypcqSzsErnUUnmf5FjVQJVL+AcsdJbbNRFXQ=
Date:   Thu, 16 Feb 2023 14:00:37 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        songmuchun@bytedance.com, sashal@kernel.org,
        naresh.kamboju@linaro.org, lkft@linaro.org, jesperjuhl76@gmail.com,
        anders.roxell@linaro.org, ak@linux.intel.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-check-for-undefined-shift-on-32-bit-architectures.patch added to mm-hotfixes-unstable branch
Message-Id: <20230216220038.30DA3C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hugetlb: check for undefined shift on 32 bit architectures
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     hugetlb-check-for-undefined-shift-on-32-bit-architectures.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-check-for-undefined-shift-on-32-bit-architectures.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

hugetlb-check-for-undefined-shift-on-32-bit-architectures.patch

