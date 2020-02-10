Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92D8915783C
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730256AbgBJNGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:06:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:38622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729153AbgBJMjy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:54 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DB3224686;
        Mon, 10 Feb 2020 12:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338394;
        bh=irbCVC1di7wloz/cOEiX1QG9QpnE2bzNzLB4e3lEqtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zp+wlHv3hPzPKlTS7vYj48Xn/GdHqg++eBK5whbP3MzBK1hLtWT8UWxae7viJR8uU
         zR5DZyk8XGaNIlh0GzHqzlo9FGcFTpSC8rnsCeFqyB2Inu4wuNDmu9ma3Lsn/pLyLR
         aZ1gDghluGufuYpSdy7a06AwltyXQhzb0IRHw/Cs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.5 088/367] powerpc/32s: Fix CPU wake-up from sleep mode
Date:   Mon, 10 Feb 2020 04:30:01 -0800
Message-Id: <20200210122432.488169484@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 9933819099c4600b41a042f27a074470a43cf6b9 upstream.

Commit f7354ccac844 ("powerpc/32: Remove CURRENT_THREAD_INFO and
rename TI_CPU") broke the CPU wake-up from sleep mode (i.e. when
_TLF_SLEEPING is set) by delaying the tovirt(r2, r2).

This is because r2 is not restored by fast_exception_return. It used
to work (by chance ?) because CPU wake-up interrupt never comes from
user, so r2 is expected to point to 'current' on return.

Commit e2fb9f544431 ("powerpc/32: Prepare for Kernel Userspace Access
Protection") broke it even more by clobbering r0 which is not
restored by fast_exception_return either.

Use r6 instead of r0. This is possible because r3-r6 are restored by
fast_exception_return and only r3-r5 are used for exception arguments.

For r2 it could be converted back to virtual address, but stay on the
safe side and restore it from the stack instead. It should be live
in the cache at that moment, so loading from the stack should make
no difference compared to converting it from phys to virt.

Fixes: f7354ccac844 ("powerpc/32: Remove CURRENT_THREAD_INFO and rename TI_CPU")
Fixes: e2fb9f544431 ("powerpc/32: Prepare for Kernel Userspace Access Protection")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/6d02c3ae6ad77af34392e98117e44c2bf6d13ba1.1580121710.git.christophe.leroy@c-s.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/entry_32.S |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -179,7 +179,7 @@ transfer_to_handler:
 2:	/* if from kernel, check interrupted DOZE/NAP mode and
          * check for stack overflow
          */
-	kuap_save_and_lock r11, r12, r9, r2, r0
+	kuap_save_and_lock r11, r12, r9, r2, r6
 	addi	r2, r12, -THREAD
 	lwz	r9,KSP_LIMIT(r12)
 	cmplw	r1,r9			/* if r1 <= ksp_limit */
@@ -284,6 +284,7 @@ reenable_mmu:
 	rlwinm	r9,r9,0,~MSR_EE
 	lwz	r12,_LINK(r11)		/* and return to address in LR */
 	kuap_restore r11, r2, r3, r4, r5
+	lwz	r2, GPR2(r11)
 	b	fast_exception_return
 #endif
 


