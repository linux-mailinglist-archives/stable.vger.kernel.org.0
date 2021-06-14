Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2623A6226
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233559AbhFNK4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:56:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234714AbhFNKyO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:54:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A5E361420;
        Mon, 14 Jun 2021 10:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667211;
        bh=Ai6QrPle0aVWEa77ZCFI5Nqvc4azHS+DWW55+gah+1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQoBymFNYVpkKiWs2BtLO0vv1h0DL6mrpPWKhpgV5/nFXYPgs+vonZN2N6XoJ3nG6
         JgZn83I+8Sl78DUwCRwHNP6lApdXRbc6o209o5p2UGDikyYhlk3H0qoDQP0vE9zdnR
         Pilk2UuQPxnpyXvKEqIDoGR/TNs/Gr/P91cB03ik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.4 70/84] KVM: x86: Ensure liveliness of nested VM-Enter fail tracepoint message
Date:   Mon, 14 Jun 2021 12:27:48 +0200
Message-Id: <20210614102648.741191107@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit f31500b0d437a2464ca5972d8f5439e156b74960 upstream.

Use the __string() machinery provided by the tracing subystem to make a
copy of the string literals consumed by the "nested VM-Enter failed"
tracepoint.  A complete copy is necessary to ensure that the tracepoint
can't outlive the data/memory it consumes and deference stale memory.

Because the tracepoint itself is defined by kvm, if kvm-intel and/or
kvm-amd are built as modules, the memory holding the string literals
defined by the vendor modules will be freed when the module is unloaded,
whereas the tracepoint and its data in the ring buffer will live until
kvm is unloaded (or "indefinitely" if kvm is built-in).

This bug has existed since the tracepoint was added, but was recently
exposed by a new check in tracing to detect exactly this type of bug.

  fmt: '%s%s
  ' current_buffer: ' vmx_dirty_log_t-140127  [003] ....  kvm_nested_vmenter_failed: '
  WARNING: CPU: 3 PID: 140134 at kernel/trace/trace.c:3759 trace_check_vprintf+0x3be/0x3e0
  CPU: 3 PID: 140134 Comm: less Not tainted 5.13.0-rc1-ce2e73ce600a-req #184
  Hardware name: ASUS Q87M-E/Q87M-E, BIOS 1102 03/03/2014
  RIP: 0010:trace_check_vprintf+0x3be/0x3e0
  Code: <0f> 0b 44 8b 4c 24 1c e9 a9 fe ff ff c6 44 02 ff 00 49 8b 97 b0 20
  RSP: 0018:ffffa895cc37bcb0 EFLAGS: 00010282
  RAX: 0000000000000000 RBX: ffffa895cc37bd08 RCX: 0000000000000027
  RDX: 0000000000000027 RSI: 00000000ffffdfff RDI: ffff9766cfad74f8
  RBP: ffffffffc0a041d4 R08: ffff9766cfad74f0 R09: ffffa895cc37bad8
  R10: 0000000000000001 R11: 0000000000000001 R12: ffffffffc0a041d4
  R13: ffffffffc0f4dba8 R14: 0000000000000000 R15: ffff976409f2c000
  FS:  00007f92fa200740(0000) GS:ffff9766cfac0000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000559bd11b0000 CR3: 000000019fbaa002 CR4: 00000000001726e0
  Call Trace:
   trace_event_printf+0x5e/0x80
   trace_raw_output_kvm_nested_vmenter_failed+0x3a/0x60 [kvm]
   print_trace_line+0x1dd/0x4e0
   s_show+0x45/0x150
   seq_read_iter+0x2d5/0x4c0
   seq_read+0x106/0x150
   vfs_read+0x98/0x180
   ksys_read+0x5f/0xe0
   do_syscall_64+0x40/0xb0
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Cc: Steven Rostedt <rostedt@goodmis.org>
Fixes: 380e0055bc7e ("KVM: nVMX: trace nested VM-Enter failures detected by H/W")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Message-Id: <20210607175748.674002-1-seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/trace.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1483,16 +1483,16 @@ TRACE_EVENT(kvm_nested_vmenter_failed,
 	TP_ARGS(msg, err),
 
 	TP_STRUCT__entry(
-		__field(const char *, msg)
+		__string(msg, msg)
 		__field(u32, err)
 	),
 
 	TP_fast_assign(
-		__entry->msg = msg;
+		__assign_str(msg, msg);
 		__entry->err = err;
 	),
 
-	TP_printk("%s%s", __entry->msg, !__entry->err ? "" :
+	TP_printk("%s%s", __get_str(msg), !__entry->err ? "" :
 		__print_symbolic(__entry->err, VMX_VMENTER_INSTRUCTION_ERRORS))
 );
 


