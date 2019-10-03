Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC32CA734
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733083AbfJCQvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:51:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406067AbfJCQvj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:51:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0C96222D2;
        Thu,  3 Oct 2019 16:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121499;
        bh=eeeJp0FNAAAiyZPK5GMb6KHfkDpMg42jZSSgPnP5/NA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2TO2xSWTWeGqN2gERY8FtS5tqWjkb+slAsVK3Hr9cq+SBgVPOwVAupciBN1JDaXmH
         jMHotBsyZ2JLOMIjJZdO/kop/V7DxvCcHZLlc1RMSzohjWbG1Sx3/oae0zpULeVYE+
         uSZTvqEQAyyY0zPpGSordngAXH6joAUYhXFpIo08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Lunev <den@virtuozzo.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Denis Plotnikov <dplotnikov@virtuozzo.com>,
        Jan Dakinevich <jan.dakinevich@virtuozzo.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.3 263/344] KVM: x86: set ctxt->have_exception in x86_decode_insn()
Date:   Thu,  3 Oct 2019 17:53:48 +0200
Message-Id: <20191003154606.391152333@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
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
@@ -5395,6 +5395,8 @@ done_prefixes:
 					ctxt->memopp->addr.mem.ea + ctxt->_eip);
 
 done:
+	if (rc == X86EMUL_PROPAGATE_FAULT)
+		ctxt->have_exception = true;
 	return (rc != X86EMUL_CONTINUE) ? EMULATION_FAILED : EMULATION_OK;
 }
 
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6529,6 +6529,12 @@ int x86_emulate_instruction(struct kvm_v
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


