Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D3137CBBA
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235889AbhELQh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:37:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237880AbhELQ2B (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:28:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33D7C61461;
        Wed, 12 May 2021 15:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834961;
        bh=feGBGZ6G839HD36t7DZkDVprzfXHcdWXVlp4ZpSeKbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKqoLKPHW+4PZyLBQZsHUzHWn1JFmiD1P+Gmmtic2eohgzKoABEU2ezh4+6ySob2Q
         eXUrs+l7T+bFbQfg0yFcpWEQ3JG9+I2pqzMjhweCimpDKEwpWp51WBav4uE7hpNCa8
         mTUVNGDFBNKK7tmkwJBKc5nHw08sQC2THVLreRsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.12 108/677] KVM: X86: Fix failure to boost kernel lock holder candidate in SEV-ES guests
Date:   Wed, 12 May 2021 16:42:34 +0200
Message-Id: <20210512144840.811548808@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

commit b86bb11e3a79ac0db9a6786b1fe80f74321cb076 upstream.

Commit f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under
SEV-ES") prevents hypervisor accesses guest register state when the guest is
running under SEV-ES. The initial value of vcpu->arch.guest_state_protected
is false, it will not be updated in preemption notifiers after this commit which
means that the kernel spinlock lock holder will always be skipped to boost. Let's
fix it by always treating preempted is in the guest kernel mode, false positive
is better than skip completely.

Fixes: f1c6366e3043 (KVM: SVM: Add required changes to support intercepts under SEV-ES)
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Message-Id: <1619080459-30032-1-git-send-email-wanpengli@tencent.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11020,6 +11020,9 @@ bool kvm_arch_dy_runnable(struct kvm_vcp
 
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 {
+	if (vcpu->arch.guest_state_protected)
+		return true;
+
 	return vcpu->arch.preempted_in_kernel;
 }
 


