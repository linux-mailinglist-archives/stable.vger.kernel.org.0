Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C558849421
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbfFQVf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:35:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729501AbfFQVWR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:22:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E7D420861;
        Mon, 17 Jun 2019 21:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806536;
        bh=s5fDWmwWmrDxUH/d22JDRo/fiF3jlxW6KHX6xmItwZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VJ70kvQ9HZsZPD/SBJQcudOSEDEY8fza83VGjDO2pS5xr1WkOuR2t03tw68Zv6bKz
         pG/mGd0R2iI21eA9OvSkDgzdMZMsv3WsI7lZPENvuEYcUOiaOTeMNLm2m4zyan1Ssn
         3bGvOPNOzCvsUUPgHe9KS3Q3Sks8wFLrVX2fYebA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 084/115] KVM: nVMX: really fix the size checks on KVM_SET_NESTED_STATE
Date:   Mon, 17 Jun 2019 23:09:44 +0200
Message-Id: <20190617210804.287554747@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit db80927ea1977a845230a161df643b48fd1e1ea4 ]

The offset for reading the shadow VMCS is sizeof(*kvm_state)+VMCS12_SIZE,
so the correct size must be that plus sizeof(*vmcs12).  This could lead
to KVM reading garbage data from userspace and not reporting an error,
but is otherwise not sensitive.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8f6f69c26c35..5fa0c17d0b41 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5467,7 +5467,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	    vmcs12->vmcs_link_pointer != -1ull) {
 		struct vmcs12 *shadow_vmcs12 = get_shadow_vmcs12(vcpu);
 
-		if (kvm_state->size < sizeof(*kvm_state) + 2 * sizeof(*vmcs12))
+		if (kvm_state->size < sizeof(*kvm_state) + VMCS12_SIZE + sizeof(*vmcs12))
 			return -EINVAL;
 
 		if (copy_from_user(shadow_vmcs12,
-- 
2.20.1



