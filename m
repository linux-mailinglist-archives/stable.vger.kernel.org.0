Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6903CE244
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347959AbhGSP3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:29:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348125AbhGSPYf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C95536144F;
        Mon, 19 Jul 2021 16:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710531;
        bh=h43gT/8OGzJOb2FYk9ON/Zy2mZXYXGpYFRt3u0xvfVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d73LMZ27EIWrgRdGSbebHWqJ9E8GNSioKTnuyvaoriAMwJ5OYiqfRy3TL+zKrJReT
         TMmmad+z/jhfLyRTFRP7L2xYdPnIT8DmvyMQmIpzOj31ccm0qb5gHkCOW6WrZkvw+/
         7ZV+2AqJ4ElM+oM7t3lLdgYZG8gYnvFLGU9S3Ozw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.13 012/351] KVM: SVM: #SMI interception must not skip the instruction
Date:   Mon, 19 Jul 2021 16:49:18 +0200
Message-Id: <20210719144944.934850912@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

commit 991afbbee8ac93b055a27477278a5fb556af1ff4 upstream.

Commit 5ff3a351f687 ("KVM: x86: Move trivial instruction-based
exit handlers to common code"), unfortunately made a mistake of
treating nop_on_interception and nop_interception in the same way.

Former does truly nothing while the latter skips the instruction.

SMI VM exit handler should do nothing.
(SMI itself is handled by the host when we do STGI)

Fixes: 5ff3a351f687 ("KVM: x86: Move trivial instruction-based exit handlers to common code")
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20210707125100.677203-2-mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2080,6 +2080,11 @@ static int nmi_interception(struct kvm_v
 	return 1;
 }
 
+static int smi_interception(struct kvm_vcpu *vcpu)
+{
+	return 1;
+}
+
 static int intr_interception(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.irq_exits;
@@ -3063,7 +3068,7 @@ static int (*const svm_exit_handlers[])(
 	[SVM_EXIT_EXCP_BASE + GP_VECTOR]	= gp_interception,
 	[SVM_EXIT_INTR]				= intr_interception,
 	[SVM_EXIT_NMI]				= nmi_interception,
-	[SVM_EXIT_SMI]				= kvm_emulate_as_nop,
+	[SVM_EXIT_SMI]				= smi_interception,
 	[SVM_EXIT_INIT]				= kvm_emulate_as_nop,
 	[SVM_EXIT_VINTR]			= interrupt_window_interception,
 	[SVM_EXIT_RDPMC]			= kvm_emulate_rdpmc,


