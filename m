Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BABB1D0F19
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732773AbgEMJrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:47:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732810AbgEMJrN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:47:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 693622078C;
        Wed, 13 May 2020 09:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363232;
        bh=Nl8K5b252Z3oTCQfej+1iIqWvtOKZyzW/iHp0Q4TVj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sU8xNiGBd82EfCAzoCX5X/p9Q6RQ/wPEg7yjGnmjygJPf1GYIAccvdt9HmC+O5H02
         soZnvpKJGEWQ4qGOUVnUKEre7gOOhsVrIc/2DH+kMXthi4cBGONmB0HdBbnkERT4g8
         DhbRl+7rGV97DCVmprjJWi/v7eEgaSW26wDl6kCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Jann Horn <jannh@google.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>, Dave Jones <dsj@fb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: [PATCH 4.19 39/48] x86/entry/64: Fix unwind hints in rewind_stack_do_exit()
Date:   Wed, 13 May 2020 11:45:05 +0200
Message-Id: <20200513094401.664753125@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094351.100352960@linuxfoundation.org>
References: <20200513094351.100352960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit f977df7b7ca45a4ac4b66d30a8931d0434c394b1 upstream.

The LEAQ instruction in rewind_stack_do_exit() moves the stack pointer
directly below the pt_regs at the top of the task stack before calling
do_exit(). Tell the unwinder to expect pt_regs.

Fixes: 8c1f75587a18 ("x86/entry/64: Add unwind hint annotations")
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Jones <dsj@fb.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Link: https://lore.kernel.org/r/68c33e17ae5963854916a46f522624f8e1d264f2.1587808742.git.jpoimboe@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/entry_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1745,7 +1745,7 @@ ENTRY(rewind_stack_do_exit)
 
 	movq	PER_CPU_VAR(cpu_current_top_of_stack), %rax
 	leaq	-PTREGS_SIZE(%rax), %rsp
-	UNWIND_HINT_FUNC sp_offset=PTREGS_SIZE
+	UNWIND_HINT_REGS
 
 	call	do_exit
 END(rewind_stack_do_exit)


