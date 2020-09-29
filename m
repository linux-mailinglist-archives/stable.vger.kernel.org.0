Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449C127CA6B
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732030AbgI2MS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:18:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729968AbgI2LgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:36:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D65FE23E20;
        Tue, 29 Sep 2020 11:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379086;
        bh=TK3KTJrOUeJtUEJM8SYNzxXjFuxt4pvQMMBPqwEUqQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rjyiDM7xLoo7Xg1wNp4MNWUE1r8zuMDpmHCCIB4OhlCy4i4JNwRT9nsMBOIWhsowP
         zG0168QYYMt06J6kqXstUtJY6PUYaxyPg43pIm24lUDoWCgkKstDORIC/BZTpc/7yF
         HaXND2XogywJnDnYJNhtYO8lYYqXTWJUHP9T/OJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 235/245] KVM: SVM: Add a dedicated INVD intercept routine
Date:   Tue, 29 Sep 2020 13:01:26 +0200
Message-Id: <20200929105958.427433072@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

[ Upstream commit 4bb05f30483fd21ea5413eaf1182768f251cf625 ]

The INVD instruction intercept performs emulation. Emulation can't be done
on an SEV guest because the guest memory is encrypted.

Provide a dedicated intercept routine for the INVD intercept. And since
the instruction is emulated as a NOP, just skip it instead.

Fixes: 1654efcbc431 ("KVM: SVM: Add KVM_SEV_INIT command")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Message-Id: <a0b9a19ffa7fef86a3cc700c7ea01cb2731e04e5.1600972918.git.thomas.lendacky@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 2aafb6c791345..cb09a0ec87500 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3942,6 +3942,12 @@ static int iret_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
+static int invd_interception(struct vcpu_svm *svm)
+{
+	/* Treat an INVD instruction as a NOP and just skip it. */
+	return kvm_skip_emulated_instruction(&svm->vcpu);
+}
+
 static int invlpg_interception(struct vcpu_svm *svm)
 {
 	if (!static_cpu_has(X86_FEATURE_DECODEASSISTS))
@@ -4831,7 +4837,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_RDPMC]			= rdpmc_interception,
 	[SVM_EXIT_CPUID]			= cpuid_interception,
 	[SVM_EXIT_IRET]                         = iret_interception,
-	[SVM_EXIT_INVD]                         = emulate_on_interception,
+	[SVM_EXIT_INVD]                         = invd_interception,
 	[SVM_EXIT_PAUSE]			= pause_interception,
 	[SVM_EXIT_HLT]				= halt_interception,
 	[SVM_EXIT_INVLPG]			= invlpg_interception,
-- 
2.25.1



