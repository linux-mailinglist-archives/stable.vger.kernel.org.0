Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA6235A43D5
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 09:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbiH2Hh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 03:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiH2Hh5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 03:37:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51154E63D
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 00:37:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FE096112E
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 07:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41990C433D6;
        Mon, 29 Aug 2022 07:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661758675;
        bh=QzNMbyb4Gj85ErYzYbfOMUB4Y4kANxCvHOZdLflyM+w=;
        h=Subject:To:Cc:From:Date:From;
        b=ImxLJCUUCuu/Dm1eIcMP7X/Z0FsalEx2KzPwqG4xhS7es8umzGHC9uU7ttjH2srQE
         Ru5vZ771TrlkpWKiAa5vnHhfPdudXHltBVDXFPBd+i5aETdb4tQeIpfPz3U6OgcVjX
         BtwP9JIEUBPLO6khJYwRvKgMHTNPVdolJPIlaLck=
Subject: FAILED: patch "[PATCH] s390/mm: do not trigger write fault when vma does not allow" failed to apply to 4.19-stable tree
To:     gerald.schaefer@linux.ibm.com, david@redhat.com, gor@linux.ibm.com,
        hca@linux.ibm.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Aug 2022 09:37:42 +0200
Message-ID: <1661758662124123@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 41ac42f137080bc230b5882e3c88c392ab7f2d32 Mon Sep 17 00:00:00 2001
From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Date: Wed, 17 Aug 2022 15:26:03 +0200
Subject: [PATCH] s390/mm: do not trigger write fault when vma does not allow
 VM_WRITE

For non-protection pXd_none() page faults in do_dat_exception(), we
call do_exception() with access == (VM_READ | VM_WRITE | VM_EXEC).
In do_exception(), vma->vm_flags is checked against that before
calling handle_mm_fault().

Since commit 92f842eac7ee3 ("[S390] store indication fault optimization"),
we call handle_mm_fault() with FAULT_FLAG_WRITE, when recognizing that
it was a write access. However, the vma flags check is still only
checking against (VM_READ | VM_WRITE | VM_EXEC), and therefore also
calling handle_mm_fault() with FAULT_FLAG_WRITE in cases where the vma
does not allow VM_WRITE.

Fix this by changing access check in do_exception() to VM_WRITE only,
when recognizing write access.

Link: https://lkml.kernel.org/r/20220811103435.188481-3-david@redhat.com
Fixes: 92f842eac7ee3 ("[S390] store indication fault optimization")
Cc: <stable@vger.kernel.org>
Reported-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 13449941516c..09b6e756d521 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -379,7 +379,9 @@ static inline vm_fault_t do_exception(struct pt_regs *regs, int access)
 	flags = FAULT_FLAG_DEFAULT;
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
-	if (access == VM_WRITE || is_write)
+	if (is_write)
+		access = VM_WRITE;
+	if (access == VM_WRITE)
 		flags |= FAULT_FLAG_WRITE;
 	mmap_read_lock(mm);
 

