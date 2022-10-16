Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7075FFE70
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 11:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiJPJab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 05:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiJPJa3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 05:30:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F5D31EDD
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 02:30:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AE9560023
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 09:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0075CC433C1;
        Sun, 16 Oct 2022 09:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665912627;
        bh=gSRV3cOUKraj6ppCkcEetm+m6aCSBSv3xIp3EMeP12g=;
        h=Subject:To:Cc:From:Date:From;
        b=IqkA3dWen8dMPKm4w1C6daJlZxEcAO9RV/St9BlZLd9IjNHlZSa4yJRarzUdEUNhI
         T/anpgySHyaHNlxw6+Vd+8gG5aiKWlqs/czacjsnq/7J7WYqNIBcBTEI71bSutuqde
         DsxcM1dfROa74deY08TKz42+jRYeyDbxqGjokhfE=
Subject: FAILED: patch "[PATCH] riscv: Make VM_WRITE imply VM_READ" failed to apply to 4.19-stable tree
To:     abrestic@rivosinc.com, atishp@rivosinc.com, palmer@rivosinc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 11:31:03 +0200
Message-ID: <1665912663114228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

7ab72c597356 ("riscv: Make VM_WRITE imply VM_READ")
afb8c6fee8ce ("riscv/mm/fault: Move access error check to function")
6747430197ed ("riscv/mm/fault: Move FAULT_FLAG_WRITE handling in do_page_fault()")
ac416a724f11 ("riscv/mm/fault: Move vmalloc fault handling to vmalloc_fault()")
a51271d99cdd ("riscv/mm/fault: Move bad area handling to bad_area()")
cac4d1dc85be ("riscv/mm/fault: Move no context handling to no_context()")
d8ed45c5dcd4 ("mmap locking API: use coccinelle to convert mmap_sem rwsem call sites")
7ae77150d94d ("Merge tag 'powerpc-5.8-1' of git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7ab72c597356be1e7f0f3d856e54ce78527f43c8 Mon Sep 17 00:00:00 2001
From: Andrew Bresticker <abrestic@rivosinc.com>
Date: Thu, 15 Sep 2022 15:37:01 -0400
Subject: [PATCH] riscv: Make VM_WRITE imply VM_READ

RISC-V does not presently have write-only mappings as that PTE bit pattern
is considered reserved in the privileged spec, so allow handling of read
faults in VMAs that have VM_WRITE without VM_READ in order to be consistent
with other architectures that have similar limitations.

Fixes: 2139619bcad7 ("riscv: mmap with PROT_WRITE but no PROT_READ is invalid")
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Andrew Bresticker <abrestic@rivosinc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220915193702.2201018-2-abrestic@rivosinc.com/
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

diff --git a/arch/riscv/mm/fault.c b/arch/riscv/mm/fault.c
index f2fbd1400b7c..d86f7cebd4a7 100644
--- a/arch/riscv/mm/fault.c
+++ b/arch/riscv/mm/fault.c
@@ -184,7 +184,8 @@ static inline bool access_error(unsigned long cause, struct vm_area_struct *vma)
 		}
 		break;
 	case EXC_LOAD_PAGE_FAULT:
-		if (!(vma->vm_flags & VM_READ)) {
+		/* Write implies read */
+		if (!(vma->vm_flags & (VM_READ | VM_WRITE))) {
 			return true;
 		}
 		break;

