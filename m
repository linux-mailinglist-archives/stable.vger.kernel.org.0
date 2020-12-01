Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72AED2C9D44
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389354AbgLAJVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:21:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:47328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389584AbgLAJJv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:09:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D472221EB;
        Tue,  1 Dec 2020 09:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813745;
        bh=9gm5weQq856C4mJXJWgcMgZDW1ZwU8Qr533MjtNjEvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iwQ1j75nQTwRADQunobv7LG6Z/QpPddfvzziFY4hinGyUzJA/aZbNp/NmePg9K80X
         RFclxWVaDIVDnwGe1UjsPSLhtNP3zj8ZVluCDe7xqhZasa0k0+k39ZHW0cimP7+z15
         IcWjq056gSSLz1Wy5zqsJ642vztUh0z6+1ARg3sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pierre Morel <pmorel@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.9 014/152] s390: fix fpu restore in entry.S
Date:   Tue,  1 Dec 2020 09:52:09 +0100
Message-Id: <20201201084713.734548029@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit 1179f170b6f0af7bb0b3b7628136eaac450ddf31 upstream.

We need to disable interrupts in load_fpu_regs(). Otherwise an
interrupt might come in after the registers are loaded, but before
CIF_FPU is cleared in load_fpu_regs(). When the interrupt returns,
CIF_FPU will be cleared and the registers will never be restored.

The entry.S code usually saves the interrupt state in __SF_EMPTY on the
stack when disabling/restoring interrupts. sie64a however saves the pointer
to the sie control block in __SF_SIE_CONTROL, which references the same
location.  This is non-obvious to the reader. To avoid thrashing the sie
control block pointer in load_fpu_regs(), move the __SIE_* offsets eight
bytes after __SF_EMPTY on the stack.

Cc: <stable@vger.kernel.org> # 5.8
Fixes: 0b0ed657fe00 ("s390: remove critical section cleanup from entry.S")
Reported-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/asm-offsets.c |   10 +++++-----
 arch/s390/kernel/entry.S       |    2 ++
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -53,11 +53,11 @@ int main(void)
 	/* stack_frame offsets */
 	OFFSET(__SF_BACKCHAIN, stack_frame, back_chain);
 	OFFSET(__SF_GPRS, stack_frame, gprs);
-	OFFSET(__SF_EMPTY, stack_frame, empty1);
-	OFFSET(__SF_SIE_CONTROL, stack_frame, empty1[0]);
-	OFFSET(__SF_SIE_SAVEAREA, stack_frame, empty1[1]);
-	OFFSET(__SF_SIE_REASON, stack_frame, empty1[2]);
-	OFFSET(__SF_SIE_FLAGS, stack_frame, empty1[3]);
+	OFFSET(__SF_EMPTY, stack_frame, empty1[0]);
+	OFFSET(__SF_SIE_CONTROL, stack_frame, empty1[1]);
+	OFFSET(__SF_SIE_SAVEAREA, stack_frame, empty1[2]);
+	OFFSET(__SF_SIE_REASON, stack_frame, empty1[3]);
+	OFFSET(__SF_SIE_FLAGS, stack_frame, empty1[4]);
 	BLANK();
 	/* timeval/timezone offsets for use by vdso */
 	OFFSET(__VDSO_UPD_COUNT, vdso_data, tb_update_count);
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -1072,6 +1072,7 @@ EXPORT_SYMBOL(save_fpu_regs)
  *	%r4
  */
 load_fpu_regs:
+	stnsm	__SF_EMPTY(%r15),0xfc
 	lg	%r4,__LC_CURRENT
 	aghi	%r4,__TASK_thread
 	TSTMSK	__LC_CPU_FLAGS,_CIF_FPU
@@ -1103,6 +1104,7 @@ load_fpu_regs:
 .Lload_fpu_regs_done:
 	ni	__LC_CPU_FLAGS+7,255-_CIF_FPU
 .Lload_fpu_regs_exit:
+	ssm	__SF_EMPTY(%r15)
 	BR_EX	%r14
 .Lload_fpu_regs_end:
 ENDPROC(load_fpu_regs)


