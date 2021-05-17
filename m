Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A53383065
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239440AbhEQO0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:26:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239752AbhEQOYq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:24:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C280361492;
        Mon, 17 May 2021 14:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260789;
        bh=tOjdbv3reowCEeF77LzsZV2jZhw3zHhG610IDc5p/VQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0bxZctW9sdMZ/oKEufE7f+SG27ScivoCTjPVTekb1Epjt4bGiawsxdUfErQ8+Vdid
         qO9ya7n+a78NzNhaBI5vUXUBF2kxZVO65wWFc+K8BBAIRjt2xhBHkaIpfy2hQYR+8S
         1162FCIRM4A57cp0Y5PZw2Un5h1ysOGjx2b4njeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.11 005/329] KVM: SVM: Make sure GHCB is mapped before updating
Date:   Mon, 17 May 2021 15:58:36 +0200
Message-Id: <20210517140302.218719849@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

commit a3ba26ecfb569f4aa3f867e80c02aa65f20aadad upstream.

Access to the GHCB is mainly in the VMGEXIT path and it is known that the
GHCB will be mapped. But there are two paths where it is possible the GHCB
might not be mapped.

The sev_vcpu_deliver_sipi_vector() routine will update the GHCB to inform
the caller of the AP Reset Hold NAE event that a SIPI has been delivered.
However, if a SIPI is performed without a corresponding AP Reset Hold,
then the GHCB might not be mapped (depending on the previous VMEXIT),
which will result in a NULL pointer dereference.

The svm_complete_emulated_msr() routine will update the GHCB to inform
the caller of a RDMSR/WRMSR operation about any errors. While it is likely
that the GHCB will be mapped in this situation, add a safe guard
in this path to be certain a NULL pointer dereference is not encountered.

Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
Fixes: 647daca25d24 ("KVM: SVM: Add support for booting APs in an SEV-ES guest")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org
Message-Id: <a5d3ebb600a91170fc88599d5a575452b3e31036.1617979121.git.thomas.lendacky@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    3 +++
 arch/x86/kvm/svm/svm.c |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2062,5 +2062,8 @@ void sev_vcpu_deliver_sipi_vector(struct
 	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
 	 * non-zero value.
 	 */
+	if (!svm->ghcb)
+		return;
+
 	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
 }
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2724,7 +2724,7 @@ static int svm_get_msr(struct kvm_vcpu *
 static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	if (!sev_es_guest(svm->vcpu.kvm) || !err)
+	if (!err || !sev_es_guest(vcpu->kvm) || WARN_ON_ONCE(!svm->ghcb))
 		return kvm_complete_insn_gp(&svm->vcpu, err);
 
 	ghcb_set_sw_exit_info_1(svm->ghcb, 1);


