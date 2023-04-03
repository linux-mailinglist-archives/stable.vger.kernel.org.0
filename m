Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B6B6D3F4A
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 10:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbjDCInu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 04:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbjDCInq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 04:43:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA4683D2
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 01:43:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E5605CE0FCD
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 08:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD28C433EF;
        Mon,  3 Apr 2023 08:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680511421;
        bh=Aw5uZ443RUXU6tnCbrcB9g0yKT3yaeMYLAtkin7ROgc=;
        h=Subject:To:Cc:From:Date:From;
        b=FSFcBH6h0OwJ4xQm5HRtlCJylwiYU1D1dFttVoDQd8yxmt+fF/iOoGB0hctC0TMbQ
         940fBiffaFt27BCK4tDCZnFQhqYsP2aymaquSosf4iYQ44bKlMlO0cz3ExdmkYR9oj
         K3+9lUZCwD5A+i+G8jpwSgvCyZ07JUsB6EggNUOc=
Subject: FAILED: patch "[PATCH] s390/uaccess: add missing earlyclobber annotations to" failed to apply to 5.10-stable tree
To:     hca@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        gor@linux.ibm.com, mark.rutland@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 03 Apr 2023 10:43:36 +0200
Message-ID: <2023040336-reformist-kinship-d451@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x 89aba4c26fae4e459f755a18912845c348ee48f3
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023040336-reformist-kinship-d451@gregkh' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

89aba4c26fae ("s390/uaccess: add missing earlyclobber annotations to __clear_user()")
4e1b5a86a5ed ("s390/uaccess: add missing EX_TABLE entries to __clear_user()")
731efc9613ee ("s390: convert ".insn" encoding to instruction names")
012a224e1fa3 ("s390/uaccess: introduce bit field for OAC specifier")
b087dfab4d39 ("s390/crypto: add SIMD implementation for ChaCha20")
de5012b41e5c ("s390/ftrace: implement hotpatching")
f8c2602733c9 ("s390/ftrace: fix ftrace_update_ftrace_func implementation")
d1e18efa8fa9 ("s390/lib,uaccess: get rid of register asm")
fcc91d5d4047 ("s390/timex: get rid of register asm")
dbb8864b28d6 ("s390/uaccess: get rid of register asm")
53c1c2504b6b ("s390/pgtable: use register pair instead of register asm")
80f06306240e ("s390/vdso: reimplement getcpu vdso syscall")
87d598634521 ("s390/mm: remove set_fs / rework address space handling")
c9343637d6b2 ("s390/ftrace: assume -mhotpatch or -mrecord-mcount always available")
ab177c5d00cd ("s390/mm: remove unused clear_user_asce()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 89aba4c26fae4e459f755a18912845c348ee48f3 Mon Sep 17 00:00:00 2001
From: Heiko Carstens <hca@linux.ibm.com>
Date: Thu, 23 Mar 2023 13:09:16 +0100
Subject: [PATCH] s390/uaccess: add missing earlyclobber annotations to
 __clear_user()

Add missing earlyclobber annotation to size, to, and tmp2 operands of the
__clear_user() inline assembly since they are modified or written to before
the last usage of all input operands. This can lead to incorrect register
allocation for the inline assembly.

Fixes: 6c2a9e6df604 ("[S390] Use alternative user-copy operations for new hardware.")
Reported-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/all/20230321122514.1743889-3-mark.rutland@arm.com/
Cc: stable@vger.kernel.org
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>

diff --git a/arch/s390/lib/uaccess.c b/arch/s390/lib/uaccess.c
index 720036fb1924..d44214072779 100644
--- a/arch/s390/lib/uaccess.c
+++ b/arch/s390/lib/uaccess.c
@@ -172,7 +172,7 @@ unsigned long __clear_user(void __user *to, unsigned long size)
 		"4: slgr  %0,%0\n"
 		"5:\n"
 		EX_TABLE(0b,2b) EX_TABLE(6b,2b) EX_TABLE(3b,5b) EX_TABLE(7b,5b)
-		: "+a" (size), "+a" (to), "+a" (tmp1), "=a" (tmp2)
+		: "+&a" (size), "+&a" (to), "+a" (tmp1), "=&a" (tmp2)
 		: "a" (empty_zero_page), [spec] "d" (spec.val)
 		: "cc", "memory", "0");
 	return size;

