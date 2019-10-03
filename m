Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE61CA8F1
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390545AbfJCQey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:34:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404229AbfJCQew (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:34:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A4AC215EA;
        Thu,  3 Oct 2019 16:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120492;
        bh=Y+sjdArzs1nxVQ7xmrts51UkkdFRYeUm6jRCoeUmoqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tjOuRgYat3KFmZTEzcH8U5a8mOsQDIeRjL6oMksdicNDTpZK2osmXhr08/6OM4dRw
         zPr0G08bHVI7w/m4xivAdjw6SqyncPUYdDUu392DVwGS4aaj5dH2tN1Jl2HaGGhrHY
         U0JzVlQHLsgebvpKEMXsfUcgv1xhR+kwndQm9jCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Lunev <den@virtuozzo.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Denis Plotnikov <dplotnikov@virtuozzo.com>,
        Jan Dakinevich <jan.dakinevich@virtuozzo.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.2 240/313] KVM: x86: always stop emulation on page fault
Date:   Thu,  3 Oct 2019 17:53:38 +0200
Message-Id: <20191003154556.672949528@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
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
@@ -6481,8 +6481,10 @@ int x86_emulate_instruction(struct kvm_v
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
 			return handle_emulation_failure(vcpu, emulation_type);


