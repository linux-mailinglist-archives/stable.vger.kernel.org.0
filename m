Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E92B1781DB
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732257AbgCCSHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:07:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:36590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732662AbgCCRzL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:55:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D538206D5;
        Tue,  3 Mar 2020 17:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258111;
        bh=+mchgu3W1Zhiq9EjAEp+MD9MvnwX3VIu2UILJKHK1ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zl9UwJG+Z40Cce0RHVFglY1L3X7wl6ioSdUyg7nvaqJBHi1Udhfu7i48wkXLNKOQ3
         ydrkRSbMaX0xuHRRYXK3cpdnF6MaDPyZEoxveWsowCn06rbCnu0eNwIA7/cpcBQxe5
         Nm5Lb/9MnSLkBPHGs7WSngU+P3vp9G5zJ+oz0DMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kiszka <jan.kiszka@web.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>
Subject: [PATCH 5.4 075/152] KVM: VMX: check descriptor table exits on instruction emulation
Date:   Tue,  3 Mar 2020 18:42:53 +0100
Message-Id: <20200303174311.022080640@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Upton <oupton@google.com>

commit 86f7e90ce840aa1db407d3ea6e9b3a52b2ce923c upstream.

KVM emulates UMIP on hardware that doesn't support it by setting the
'descriptor table exiting' VM-execution control and performing
instruction emulation. When running nested, this emulation is broken as
KVM refuses to emulate L2 instructions by default.

Correct this regression by allowing the emulation of descriptor table
instructions if L1 hasn't requested 'descriptor table exiting'.

Fixes: 07721feee46b ("KVM: nVMX: Don't emulate instructions in guest mode")
Reported-by: Jan Kiszka <jan.kiszka@web.de>
Cc: stable@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/vmx.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7165,6 +7165,7 @@ static int vmx_check_intercept_io(struct
 	else
 		intercept = nested_vmx_check_io_bitmaps(vcpu, port, size);
 
+	/* FIXME: produce nested vmexit and return X86EMUL_INTERCEPTED.  */
 	return intercept ? X86EMUL_UNHANDLEABLE : X86EMUL_CONTINUE;
 }
 
@@ -7194,6 +7195,20 @@ static int vmx_check_intercept(struct kv
 	case x86_intercept_outs:
 		return vmx_check_intercept_io(vcpu, info);
 
+	case x86_intercept_lgdt:
+	case x86_intercept_lidt:
+	case x86_intercept_lldt:
+	case x86_intercept_ltr:
+	case x86_intercept_sgdt:
+	case x86_intercept_sidt:
+	case x86_intercept_sldt:
+	case x86_intercept_str:
+		if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_DESC))
+			return X86EMUL_CONTINUE;
+
+		/* FIXME: produce nested vmexit and return X86EMUL_INTERCEPTED.  */
+		break;
+
 	/* TODO: check more intercepts... */
 	default:
 		break;


