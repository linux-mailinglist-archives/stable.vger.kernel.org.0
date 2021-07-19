Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528E73CE248
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346892AbhGSP3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:29:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348124AbhGSPYf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3037B61414;
        Mon, 19 Jul 2021 16:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710533;
        bh=Nt71ATj0KwVhLuqT2oOfSg/mtQATBcjDteQfvjiRlz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R1ymCdUPZWQYczmQ36J3B1H3KivZa7fZu1zJatjFyK3rT5IKbNt0EguFE+tsJR/hB
         QxKMl/Df2TMDND/7m5JPD/k0izwUIjqGFsUG4Djql4iNO3LRARdnbLuvAmhv0uSAhd
         kVSbWf5fFuSv7zApAmUjTAAX5sYSIQQlNgl0eHjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.13 013/351] KVM: SVM: remove INIT intercept handler
Date:   Mon, 19 Jul 2021 16:49:19 +0200
Message-Id: <20210719144944.967681029@linuxfoundation.org>
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

commit 896707c212d440a6863ce0a3930c8a609e24497d upstream.

Kernel never sends real INIT even to CPUs, other than on boot.

Thus INIT interception is an error which should be caught
by a check for an unknown VMexit reason.

On top of that, the current INIT VM exit handler skips
the current instruction which is wrong.
That was added in commit 5ff3a351f687 ("KVM: x86: Move trivial
instruction-based exit handlers to common code").

Fixes: 5ff3a351f687 ("KVM: x86: Move trivial instruction-based exit handlers to common code")
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20210707125100.677203-3-mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3069,7 +3069,6 @@ static int (*const svm_exit_handlers[])(
 	[SVM_EXIT_INTR]				= intr_interception,
 	[SVM_EXIT_NMI]				= nmi_interception,
 	[SVM_EXIT_SMI]				= smi_interception,
-	[SVM_EXIT_INIT]				= kvm_emulate_as_nop,
 	[SVM_EXIT_VINTR]			= interrupt_window_interception,
 	[SVM_EXIT_RDPMC]			= kvm_emulate_rdpmc,
 	[SVM_EXIT_CPUID]			= kvm_emulate_cpuid,


