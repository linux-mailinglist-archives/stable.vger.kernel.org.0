Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E992E9AC7
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbhADP7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 10:59:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:36582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727973AbhADP7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 10:59:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8239922510;
        Mon,  4 Jan 2021 15:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775913;
        bh=dasKtHTCYIrQxpY8qIuQBndCSh8AFrxZODHylccCWf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AwZ70UOErw0t4HlQJsJH2BHNRWF32ty2puCBSlkonl7k+QcM6lO4T/ZZa9yQtAA/G
         a/YdZX69NcbhM29aH626kgHtbPiaZTZuZ/YIOAXvax2qU75POJZbXNDbBS97wwKk9X
         t7cjbynSTut2DnF2vPReh1iaR3IiFFyvpI7X7rIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhiyi Guo <zhguo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>
Subject: [PATCH 4.19 09/35] KVM: SVM: relax conditions for allowing MSR_IA32_SPEC_CTRL accesses
Date:   Mon,  4 Jan 2021 16:57:12 +0100
Message-Id: <20210104155703.850260579@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155703.375788488@linuxfoundation.org>
References: <20210104155703.375788488@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit df7e8818926eb4712b67421442acf7d568fe2645 ]

Userspace that does not know about the AMD_IBRS bit might still
allow the guest to protect itself with MSR_IA32_SPEC_CTRL using
the Intel SPEC_CTRL bit.  However, svm.c disallows this and will
cause a #GP in the guest when writing to the MSR.  Fix this by
loosening the test and allowing the Intel CPUID bit, and in fact
allow the AMD_STIBP bit as well since it allows writing to
MSR_IA32_SPEC_CTRL too.

Reported-by: Zhiyi Guo <zhguo@redhat.com>
Analyzed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Analyzed-by: Laszlo Ersek <lersek@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a0c3d1b4b295b..f513110983d4c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4209,6 +4209,8 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
 			return 1;
@@ -4312,6 +4314,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
 			return 1;
-- 
2.27.0



