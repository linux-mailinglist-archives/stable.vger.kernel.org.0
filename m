Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3333520C90
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 06:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235916AbiEJENe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 00:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233950AbiEJENa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 00:13:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C4B207936;
        Mon,  9 May 2022 21:09:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B09AB81AF7;
        Tue, 10 May 2022 04:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297D4C385A6;
        Tue, 10 May 2022 04:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155769;
        bh=zjEqwftLt27CPiVojIVahp//l9v7U+Mo14+x6bSn0hg=;
        h=Date:To:From:Subject:From;
        b=UJpZQ3Dlg/XDc+7KeTopDO3PSEKbmO8NI3sq0Xs5NI+u9sSMBmYL8R6ZJW1WqkEPe
         XYQR7152KSJX9ZbnbygcVKv+neX7EASX2N9ogje6N5Re4KYZqHSjIQhV6MdGMNhasu
         Mt43Gx8bm+zi6xJrcIZObpN4II4v+NXBb9ii7qvI=
Date:   Mon, 09 May 2022 21:09:28 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        mike.kravetz@oracle.com, almasrymina@google.com,
        dossche.niels@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mremap-fix-sign-for-efault-error-return-value.patch removed from -mm tree
Message-Id: <20220510040929.297D4C385A6@smtp.kernel.org>
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
     Subject: mm: mremap: fix sign for EFAULT error return value
has been removed from the -mm tree.  Its filename was
     mm-mremap-fix-sign-for-efault-error-return-value.patch

This patch was dropped because it was merged into mm-hotfixes-stable

------------------------------------------------------
From: Niels Dossche <dossche.niels@gmail.com>
Subject: mm: mremap: fix sign for EFAULT error return value

The mremap syscall is supposed to return a pointer to the new virtual
memory area on success, and a negative value of the error code in case of
failure.  Currently, EFAULT is returned when the VMA is not found, instead
of -EFAULT.  The users of this syscall will therefore believe the syscall
succeeded in case the VMA didn't exist, as it returns a pointer to address
0xe (0xe being the value of EFAULT).  Fix the sign of the error value.

Link: https://lkml.kernel.org/r/20220427224439.23828-2-dossche.niels@gmail.com
Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-fix-sign-for-efault-error-return-value
+++ a/mm/mremap.c
@@ -947,7 +947,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 		return -EINTR;
 	vma = vma_lookup(mm, addr);
 	if (!vma) {
-		ret = EFAULT;
+		ret = -EFAULT;
 		goto out;
 	}
 
_

Patches currently in -mm which might be from dossche.niels@gmail.com are


