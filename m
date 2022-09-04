Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F565AC5D0
	for <lists+stable@lfdr.de>; Sun,  4 Sep 2022 19:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbiIDRyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Sep 2022 13:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiIDRyQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Sep 2022 13:54:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B562F2D1C9;
        Sun,  4 Sep 2022 10:54:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEF7A60FFF;
        Sun,  4 Sep 2022 17:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCC2C433D6;
        Sun,  4 Sep 2022 17:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662314053;
        bh=Cad+RFMq7QmDEB5EXqy7yV0zZjDCCSLmr0nt4OUkZRg=;
        h=Date:To:From:Subject:From;
        b=y296WWD1vCJM5tbIVt0VbfIk8MWRAIk+bm5r1louDViNtgelIvJMOi/4dTvNclCIc
         0zw2buUGTDLLSvojAPVe1lQdfozicd/VO9bOBc5pYv/XI0ZBvlVKVzrjrOCGLzU6TY
         fUy59n6rFwfqy1rj2Emv4e65+kNWOmnpZiEbophU=
Date:   Sun, 04 Sep 2022 10:54:12 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rppt@kernel.org, James.Bottomley@HansenPartnership.com,
        hagen@jauu.net, ammarfaizi2@gnuweeb.org, akpm@linux-foudation.org,
        dantengknight@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-dereferencing-possible-err_ptr.patch added to mm-hotfixes-unstable branch
Message-Id: <20220904175412.EBCC2C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: fix dereferencing possible ERR_PTR
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-dereferencing-possible-err_ptr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-dereferencing-possible-err_ptr.patch

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
From: Binyi Han <dantengknight@gmail.com>
Subject: mm: fix dereferencing possible ERR_PTR
Date: Sun, 4 Sep 2022 00:46:47 -0700

Smatch checker complains that 'secretmem_mnt' dereferencing possible
ERR_PTR().  Let the function return if 'secretmem_mnt' is ERR_PTR, to
avoid deferencing it.

Link: https://lkml.kernel.org/r/20220904074647.GA64291@cloud-MacBookPro
Fixes: 1507f51255c9f ("mm: introduce memfd_secret system call to create "secret" memory areas")
Signed-off-by: Binyi Han <dantengknight@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foudation.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/secretmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/secretmem.c~mm-fix-dereferencing-possible-err_ptr
+++ a/mm/secretmem.c
@@ -285,7 +285,7 @@ static int secretmem_init(void)
 
 	secretmem_mnt = kern_mount(&secretmem_fs);
 	if (IS_ERR(secretmem_mnt))
-		ret = PTR_ERR(secretmem_mnt);
+		return PTR_ERR(secretmem_mnt);
 
 	/* prevent secretmem mappings from ever getting PROT_EXEC */
 	secretmem_mnt->mnt_flags |= MNT_NOEXEC;
_

Patches currently in -mm which might be from dantengknight@gmail.com are

mm-fix-dereferencing-possible-err_ptr.patch

