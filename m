Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C5C23A653
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbgHCM0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:26:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728347AbgHCM0W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:26:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6879207DF;
        Mon,  3 Aug 2020 12:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457581;
        bh=z/62umX2iyzbwCdVpvGAfwegoxn3Mj8qDdtq/KT0das=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g/QaLW9vnLhQMC2UbnqJdvVxaLaXIcBPEUCz+UCqkzTSCS5/qdEjp1a7HPoCrFz+9
         rrn1bqiCWyIhpxFBVlXB7P14sHw3udeuXFYtPRFTxBm4gIPSSJHcddss5Hvh5fp+3e
         p64FoZnJ9Ifay/3ssnsHlKiqYClbfg9D+PdBk0hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiwei Li <lihaiwei@tencent.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.7 119/120] KVM: SVM: Fix disable pause loop exit/pause filtering capability on SVM
Date:   Mon,  3 Aug 2020 14:19:37 +0200
Message-Id: <20200803121908.684431080@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

commit 830f01b089b12bbe93bd55f2d62837253012a30e upstream.

'Commit 8566ac8b8e7c ("KVM: SVM: Implement pause loop exit logic in SVM")'
drops disable pause loop exit/pause filtering capability completely, I
guess it is a merge fault by Radim since disable vmexits capabilities and
pause loop exit for SVM patchsets are merged at the same time. This patch
reintroduces the disable pause loop exit/pause filtering capability support.

Reported-by: Haiwei Li <lihaiwei@tencent.com>
Tested-by: Haiwei Li <lihaiwei@tencent.com>
Fixes: 8566ac8b ("KVM: SVM: Implement pause loop exit logic in SVM")
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Message-Id: <1596165141-28874-3-git-send-email-wanpengli@tencent.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/svm/svm.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1105,7 +1105,7 @@ static void init_vmcb(struct vcpu_svm *s
 	svm->nested.vmcb = 0;
 	svm->vcpu.arch.hflags = 0;
 
-	if (pause_filter_count) {
+	if (!kvm_pause_in_guest(svm->vcpu.kvm)) {
 		control->pause_filter_count = pause_filter_count;
 		if (pause_filter_thresh)
 			control->pause_filter_thresh = pause_filter_thresh;
@@ -2682,7 +2682,7 @@ static int pause_interception(struct vcp
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	bool in_kernel = (svm_get_cpl(vcpu) == 0);
 
-	if (pause_filter_thresh)
+	if (!kvm_pause_in_guest(vcpu->kvm))
 		grow_ple_window(vcpu);
 
 	kvm_vcpu_on_spin(vcpu, in_kernel);
@@ -3727,7 +3727,7 @@ static void svm_handle_exit_irqoff(struc
 
 static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
-	if (pause_filter_thresh)
+	if (!kvm_pause_in_guest(vcpu->kvm))
 		shrink_ple_window(vcpu);
 }
 
@@ -3892,6 +3892,9 @@ static void svm_vm_destroy(struct kvm *k
 
 static int svm_vm_init(struct kvm *kvm)
 {
+	if (!pause_filter_count || !pause_filter_thresh)
+		kvm->arch.pause_in_guest = true;
+
 	if (avic) {
 		int ret = avic_vm_init(kvm);
 		if (ret)


