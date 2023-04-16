Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0C16E3ABC
	for <lists+stable@lfdr.de>; Sun, 16 Apr 2023 19:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjDPRmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Apr 2023 13:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjDPRmH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Apr 2023 13:42:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6E098;
        Sun, 16 Apr 2023 10:42:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B2FC6102A;
        Sun, 16 Apr 2023 17:41:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52B7C433EF;
        Sun, 16 Apr 2023 17:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681666919;
        bh=FgxhHFGxCdKQ/neMG9iKlmAK/D18UtT2mL07Chkm5SU=;
        h=Date:To:From:Subject:From;
        b=k/T4ov7bszFQnBHjtF4in23DoRJfpzbji0oQigqqVy23jJxWyNOSgoRzm31HlmVLM
         bWKKyUvCYMQSMkC8pK62e5/hMjJd4X/PPFlkzPS5AhdHWcnmFAhg9oqMyUmx4VLqDo
         1NI8A2w1B2JlrfH0I909ZGVUpBD42JBdkO9cHDJA=
Date:   Sun, 16 Apr 2023 10:41:58 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mprotect-fix-do_mprotect_pkey-return-on-error.patch removed from -mm tree
Message-Id: <20230416174158.E52B7C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/mprotect: fix do_mprotect_pkey() return on error
has been removed from the -mm tree.  Its filename was
     mm-mprotect-fix-do_mprotect_pkey-return-on-error.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/mprotect: fix do_mprotect_pkey() return on error
Date: Thu, 6 Apr 2023 15:30:50 -0400

When the loop over the VMA is terminated early due to an error, the return
code could be overwritten with ENOMEM.  Fix the return code by only
setting the error on early loop termination when the error is not set.

User-visible effects include: attempts to run mprotect() against a
special mapping or with a poorly-aligned hugetlb address should return
-EINVAL, but they presently return -ENOMEM.  In other cases an -EACCESS
should be returned.

Link: https://lkml.kernel.org/r/20230406193050.1363476-1-Liam.Howlett@oracle.com
Fixes: 2286a6914c77 ("mm: change mprotect_fixup to vma iterator")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mprotect.c~mm-mprotect-fix-do_mprotect_pkey-return-on-error
+++ a/mm/mprotect.c
@@ -838,7 +838,7 @@ static int do_mprotect_pkey(unsigned lon
 	}
 	tlb_finish_mmu(&tlb);
 
-	if (vma_iter_end(&vmi) < end)
+	if (!error && vma_iter_end(&vmi) < end)
 		error = -ENOMEM;
 
 out:
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-make-maple-state-reusable-after-mas_empty_area_rev.patch
maple_tree-fix-mas_empty_area-search.patch
mm-mmap-regression-fix-for-unmapped_area_topdown.patch

