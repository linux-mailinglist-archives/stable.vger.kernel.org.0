Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1DA2CA1F2
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbfJCQAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:00:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731580AbfJCQA1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:00:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 686E120700;
        Thu,  3 Oct 2019 16:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118426;
        bh=F5QrHJ8dW3ius4QmW17jT6/U5gly7/R3QyccOZun8hY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u820+P7YAWfjMvZ6/im9M3GcUs/ZmERNkgliYHqxduh5h58nhpOhaJ7xujdkOFraz
         Kwc8b1IhNh4uMU4/pUAiVQ8OvyGdJ84RuSTl9q+Nj5NZ1QGBJN8J4YrZh5vpMUeFWL
         LW8F4BJlon3SRhM4yC7jmM2AyTq7Ckzz6BlifnFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Lunev <den@virtuozzo.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Denis Plotnikov <dplotnikov@virtuozzo.com>,
        Jan Dakinevich <jan.dakinevich@virtuozzo.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.4 82/99] KVM: x86: set ctxt->have_exception in x86_decode_insn()
Date:   Thu,  3 Oct 2019 17:53:45 +0200
Message-Id: <20191003154336.086758733@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Dakinevich <jan.dakinevich@virtuozzo.com>

commit c8848cee74ff05638e913582a476bde879c968ad upstream.

x86_emulate_instruction() takes into account ctxt->have_exception flag
during instruction decoding, but in practice this flag is never set in
x86_decode_insn().

Fixes: 6ea6e84309ca ("KVM: x86: inject exceptions produced by x86_decode_insn")
Cc: stable@vger.kernel.org
Cc: Denis Lunev <den@virtuozzo.com>
Cc: Roman Kagan <rkagan@virtuozzo.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/emulate.c |    2 ++
 arch/x86/kvm/x86.c     |    6 ++++++
 2 files changed, 8 insertions(+)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5245,6 +5245,8 @@ done_prefixes:
 					ctxt->memopp->addr.mem.ea + ctxt->_eip);
 
 done:
+	if (rc == X86EMUL_PROPAGATE_FAULT)
+		ctxt->have_exception = true;
 	return (rc != X86EMUL_CONTINUE) ? EMULATION_FAILED : EMULATION_OK;
 }
 
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5487,6 +5487,12 @@ int x86_emulate_instruction(struct kvm_v
 						emulation_type))
 				return EMULATE_DONE;
 			if (ctxt->have_exception) {
+				/*
+				 * #UD should result in just EMULATION_FAILED, and trap-like
+				 * exception should not be encountered during decode.
+				 */
+				WARN_ON_ONCE(ctxt->exception.vector == UD_VECTOR ||
+					     exception_type(ctxt->exception.vector) == EXCPT_TRAP);
 				inject_emulated_exception(vcpu);
 				return EMULATE_DONE;
 			}


