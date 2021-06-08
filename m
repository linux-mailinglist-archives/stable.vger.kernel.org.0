Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884FF3A0271
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbhFHTD4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:03:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235343AbhFHTBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:01:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4288661359;
        Tue,  8 Jun 2021 18:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177901;
        bh=4FxsOxl0IxUm91bhDt+hrgMMQPhGIbt4bIOedGfT3gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/ZvE1zyZtOxhC+G06e+UN0wf/SBC6JfWvnNG8heuLTRHwbDo32pY+G7YTl55Pvyx
         dqeIrRECXKYuUVrFrthzTHMsdFCazni2zOt6FIKid1tf8jfEfwH5OZ32EOH8VkC+Pn
         +0PiRn0jQ49D0Z3GbiDRTylIN3yFTwcNltOmuYcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 118/137] powerpc/kprobes: Fix validation of prefixed instructions across page boundary
Date:   Tue,  8 Jun 2021 20:27:38 +0200
Message-Id: <20210608175946.363092965@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

commit 82123a3d1d5a306fdf50c968a474cc60fe43a80f upstream.

When checking if the probed instruction is the suffix of a prefixed
instruction, we access the instruction at the previous word. If the
probed instruction is the very first word of a module, we can end up
trying to access an invalid page.

Fix this by skipping the check for all instructions at the beginning of
a page. Prefixed instructions cannot cross a 64-byte boundary and as
such, we don't expect to encounter a suffix as the very first word in a
page for kernel text. Even if there are prefixed instructions crossing
a page boundary (from a module, for instance), the instruction will be
illegal, so preventing probing on the suffix of such prefix instructions
isn't worthwhile.

Fixes: b4657f7650ba ("powerpc/kprobes: Don't allow breakpoints on suffixes")
Cc: stable@vger.kernel.org # v5.8+
Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/0df9a032a05576a2fa8e97d1b769af2ff0eafbd6.1621416666.git.naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/kprobes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/kprobes.c
+++ b/arch/powerpc/kernel/kprobes.c
@@ -108,7 +108,6 @@ int arch_prepare_kprobe(struct kprobe *p
 	int ret = 0;
 	struct kprobe *prev;
 	struct ppc_inst insn = ppc_inst_read((struct ppc_inst *)p->addr);
-	struct ppc_inst prefix = ppc_inst_read((struct ppc_inst *)(p->addr - 1));
 
 	if ((unsigned long)p->addr & 0x03) {
 		printk("Attempt to register kprobe at an unaligned address\n");
@@ -116,7 +115,8 @@ int arch_prepare_kprobe(struct kprobe *p
 	} else if (IS_MTMSRD(insn) || IS_RFID(insn) || IS_RFI(insn)) {
 		printk("Cannot register a kprobe on rfi/rfid or mtmsr[d]\n");
 		ret = -EINVAL;
-	} else if (ppc_inst_prefixed(prefix)) {
+	} else if ((unsigned long)p->addr & ~PAGE_MASK &&
+		   ppc_inst_prefixed(ppc_inst_read((struct ppc_inst *)(p->addr - 1)))) {
 		printk("Cannot register a kprobe on the second word of prefixed instruction\n");
 		ret = -EINVAL;
 	}


