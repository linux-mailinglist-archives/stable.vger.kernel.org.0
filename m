Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDA4CA26A
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731235AbfJCQFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:05:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732499AbfJCQFA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:05:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03B63222BE;
        Thu,  3 Oct 2019 16:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118699;
        bh=rH23hAnLzNISvEHaOXTSYqOud5dtE9qKwqYzmL3JTXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5H2LJRf7Xol34HQV5KCcSTgaaZbrGPIaRaCsLAqWFzE9XxCBzNt3J3yBvArkHCbD
         hpHTyrCh7g7T+eDJLwZkPHr5oB6wn6DsSrVrZnko5vX3RQmq/hGulwcQH1i+EKMjsg
         YzHox9uMUCpN4pusAURdGm4aIgBWJatVfqlMW3Vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Lunev <den@virtuozzo.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Denis Plotnikov <dplotnikov@virtuozzo.com>,
        Jan Dakinevich <jan.dakinevich@virtuozzo.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.9 105/129] KVM: x86: always stop emulation on page fault
Date:   Thu,  3 Oct 2019 17:53:48 +0200
Message-Id: <20191003154407.528591625@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154318.081116689@linuxfoundation.org>
References: <20191003154318.081116689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Dakinevich <jan.dakinevich@virtuozzo.com>

commit 8530a79c5a9f4e29e6ffb35ec1a79d81f4968ec8 upstream.

inject_emulated_exception() returns true if and only if nested page
fault happens. However, page fault can come from guest page tables
walk, either nested or not nested. In both cases we should stop an
attempt to read under RIP and give guest to step over its own page
fault handler.

This is also visible when an emulated instruction causes a #GP fault
and the VMware backdoor is enabled.  To handle the VMware backdoor,
KVM intercepts #GP faults; with only the next patch applied,
x86_emulate_instruction() injects a #GP but returns EMULATE_FAIL
instead of EMULATE_DONE.   EMULATE_FAIL causes handle_exception_nmi()
(or gp_interception() for SVM) to re-inject the original #GP because it
thinks emulation failed due to a non-VMware opcode.  This patch prevents
the issue as x86_emulate_instruction() will return EMULATE_DONE after
injecting the #GP.

Fixes: 6ea6e84309ca ("KVM: x86: inject exceptions produced by x86_decode_insn")
Cc: stable@vger.kernel.org
Cc: Denis Lunev <den@virtuozzo.com>
Cc: Roman Kagan <rkagan@virtuozzo.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5764,8 +5764,10 @@ int x86_emulate_instruction(struct kvm_v
 			if (reexecute_instruction(vcpu, cr2, write_fault_to_spt,
 						emulation_type))
 				return EMULATE_DONE;
-			if (ctxt->have_exception && inject_emulated_exception(vcpu))
+			if (ctxt->have_exception) {
+				inject_emulated_exception(vcpu);
 				return EMULATE_DONE;
+			}
 			if (emulation_type & EMULTYPE_SKIP)
 				return EMULATE_FAIL;
 			return handle_emulation_failure(vcpu);


