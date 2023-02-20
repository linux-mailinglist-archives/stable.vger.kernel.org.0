Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82DFD69CD7E
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbjBTNuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbjBTNuL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:50:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B71A1E5D4
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:49:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AF9060E9D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1669CC433D2;
        Mon, 20 Feb 2023 13:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900983;
        bh=wGwVzkJwFalgr9Z1sts/r+o5YSLXxZMIYjMk+Y4lXg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBojZkpBtuW6sWeTibcV7IqTFLtXkR4N+LFdwiPQS8GLn8OuCm3G4w3ABX5ch4lKg
         y0PGj6wRTuFUvr5fQi7mPc9Tzy4Krx7vssZMNLjaotfX6oJ+XGUGu5baVsyAke5iM6
         9Qn1WACrBpGaVSX+CHjKF16gf8DeqQV9nwOW7Bvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mike Kravetz <mike.kravetz@oracle.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Jesper Juhl <jesperjuhl76@gmail.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Andi Kleen <ak@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 134/156] hugetlb: check for undefined shift on 32 bit architectures
Date:   Mon, 20 Feb 2023 14:36:18 +0100
Message-Id: <20230220133608.199970772@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

commit ec4288fe63966b26d53907212ecd05dfa81dd2cc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hugetlb.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -397,7 +397,10 @@ static inline struct hstate *hstate_size
 	if (!page_size_log)
 		return &default_hstate;
 
-	return size_to_hstate(1UL << page_size_log);
+	if (page_size_log < BITS_PER_LONG)
+		return size_to_hstate(1UL << page_size_log);
+
+	return NULL;
 }
 
 static inline struct hstate *hstate_vma(struct vm_area_struct *vma)


