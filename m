Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D397E1B4130
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbgDVKuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:50:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726848AbgDVKLp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:11:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C07F20784;
        Wed, 22 Apr 2020 10:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550305;
        bh=A4cY8BzDtOLzMKBw6kmvPW8FlQ3SJ8qUoYCg7hQonGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uwOFhuThfnkKw/ranOd1lCARcoFxtVvy8TgCyngnWhIUTAwoBj8643lwO5XTE/Dp+
         9nTDCVeNSjj3EnECEPqGCci12sCSpHYNf9CoDrdA7zWJSvfcgrGfteup1EPBUqNVGY
         hzbz+3p4D3F5zqg4Z4KXpMiJoI5zVocRn/7FxK0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.14 091/199] powerpc/kprobes: Ignore traps that happened in real mode
Date:   Wed, 22 Apr 2020 11:56:57 +0200
Message-Id: <20200422095107.179032828@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 21f8b2fa3ca5b01f7a2b51b89ce97a3705a15aa0 upstream.

When a program check exception happens while MMU translation is
disabled, following Oops happens in kprobe_handler() in the following
code:

	} else if (*addr != BREAKPOINT_INSTRUCTION) {

  BUG: Unable to handle kernel data access on read at 0x0000e268
  Faulting instruction address: 0xc000ec34
  Oops: Kernel access of bad area, sig: 11 [#1]
  BE PAGE_SIZE=16K PREEMPT CMPC885
  Modules linked in:
  CPU: 0 PID: 429 Comm: cat Not tainted 5.6.0-rc1-s3k-dev-00824-g84195dc6c58a #3267
  NIP:  c000ec34 LR: c000ecd8 CTR: c019cab8
  REGS: ca4d3b58 TRAP: 0300   Not tainted  (5.6.0-rc1-s3k-dev-00824-g84195dc6c58a)
  MSR:  00001032 <ME,IR,DR,RI>  CR: 2a4d3c52  XER: 00000000
  DAR: 0000e268 DSISR: c0000000
  GPR00: c000b09c ca4d3c10 c66d0620 00000000 ca4d3c60 00000000 00009032 00000000
  GPR08: 00020000 00000000 c087de44 c000afe0 c66d0ad0 100d3dd6 fffffff3 00000000
  GPR16: 00000000 00000041 00000000 ca4d3d70 00000000 00000000 0000416d 00000000
  GPR24: 00000004 c53b6128 00000000 0000e268 00000000 c07c0000 c07bb6fc ca4d3c60
  NIP [c000ec34] kprobe_handler+0x128/0x290
  LR [c000ecd8] kprobe_handler+0x1cc/0x290
  Call Trace:
  [ca4d3c30] [c000b09c] program_check_exception+0xbc/0x6fc
  [ca4d3c50] [c000e43c] ret_from_except_full+0x0/0x4
  --- interrupt: 700 at 0xe268
  Instruction dump:
  913e0008 81220000 38600001 3929ffff 91220000 80010024 bb410008 7c0803a6
  38210020 4e800020 38600000 4e800020 <813b0000> 6d2a7fe0 2f8a0008 419e0154
  ---[ end trace 5b9152d4cdadd06d ]---

kprobe is not prepared to handle events in real mode and functions
running in real mode should have been blacklisted, so kprobe_handler()
can safely bail out telling 'this trap is not mine' for any trap that
happened while in real-mode.

If the trap happened with MSR_IR or MSR_DR cleared, return 0
immediately.

Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Fixes: 6cc89bad60a6 ("powerpc/kprobes: Invoke handlers directly")
Cc: stable@vger.kernel.org # v4.10+
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Reviewed-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/424331e2006e7291a1bfe40e7f3fa58825f565e1.1582054578.git.christophe.leroy@c-s.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/kprobes.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/powerpc/kernel/kprobes.c
+++ b/arch/powerpc/kernel/kprobes.c
@@ -279,6 +279,9 @@ int kprobe_handler(struct pt_regs *regs)
 	if (user_mode(regs))
 		return 0;
 
+	if (!(regs->msr & MSR_IR) || !(regs->msr & MSR_DR))
+		return 0;
+
 	/*
 	 * We don't want to be preempted for the entire
 	 * duration of kprobe processing


