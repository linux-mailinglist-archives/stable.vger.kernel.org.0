Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266923CE439
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243279AbhGSPmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:42:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245415AbhGSPiF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:38:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4856A61422;
        Mon, 19 Jul 2021 16:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711500;
        bh=6HTHVIOonIARUObqEiWAXa0pMPP6v6IGfStkdlr7Hss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IyV0Q8SbbVY8I4EHq7ktbsMnHURRMY3KrwfHHOoyFD47XhBOEvmawKJIv3CVEYuKd
         QbruFhtiHRIxm3kIt/pMAL/giTneLZ+F38ck1RDqD2YacYBbroI+pwUXMvw7+PFtvn
         bb/j8Z1N01gFwFc3m0JwVu7dAgRz08KQ1llMKVoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.12 008/292] KVM: X86: Disable hardware breakpoints unconditionally before kvm_x86->run()
Date:   Mon, 19 Jul 2021 16:51:10 +0200
Message-Id: <20210719144942.797770948@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

commit f85d40160691881a17a397c448d799dfc90987ba upstream.

When the host is using debug registers but the guest is not using them
nor is the guest in guest-debug state, the kvm code does not reset
the host debug registers before kvm_x86->run().  Rather, it relies on
the hardware vmentry instruction to automatically reset the dr7 registers
which ensures that the host breakpoints do not affect the guest.

This however violates the non-instrumentable nature around VM entry
and exit; for example, when a host breakpoint is set on vcpu->arch.cr2,

Another issue is consistency.  When the guest debug registers are active,
the host breakpoints are reset before kvm_x86->run(). But when the
guest debug registers are inactive, the host breakpoints are delayed to
be disabled.  The host tracing tools may see different results depending
on what the guest is doing.

To fix the problems, we clear %db7 unconditionally before kvm_x86->run()
if the host has set any breakpoints, no matter if the guest is using
them or not.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Message-Id: <20210628172632.81029-1-jiangshanlai@gmail.com>
Cc: stable@vger.kernel.org
[Only clear %db7 instead of reloading all debug registers. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9194,6 +9194,8 @@ static int vcpu_enter_guest(struct kvm_v
 		set_debugreg(vcpu->arch.eff_db[3], 3);
 		set_debugreg(vcpu->arch.dr6, 6);
 		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
+	} else if (unlikely(hw_breakpoint_active())) {
+		set_debugreg(0, 7);
 	}
 
 	for (;;) {


