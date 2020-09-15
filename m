Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28AA26B481
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgIOXZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:25:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727174AbgIOOh4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:37:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A2102242F;
        Tue, 15 Sep 2020 14:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180052;
        bh=g/VmdeB4hbH7WT2yK30vPOn+5WAfrG4C0aRQKCQuXuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UR3oNFNzAvcZvAQoP3m/C6jqv4keFd1mZoh1uDGRPyeUyMfSkbaQRg0J5TgGMV4FS
         JQ1kbADuK+CMeHMToEU3faRD2RcGyikAQGfPGJFcOWNLQwcvVtls+IvYwqGp2waSIm
         MX+ah5cjobBP794IVYxgfB691opWgm6Sbvia9k04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 060/177] KVM: x86: always allow writing 0 to MSR_KVM_ASYNC_PF_EN
Date:   Tue, 15 Sep 2020 16:12:11 +0200
Message-Id: <20200915140656.510678492@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit d831de177217cd494bfb99f2c849a0d40c2a7890 ]

Even without in-kernel LAPIC we should allow writing '0' to
MSR_KVM_ASYNC_PF_EN as we're not enabling the mechanism. In
particular, QEMU with 'kernel-irqchip=off' fails to start
a guest with

qemu-system-x86_64: error: failed to set MSR 0x4b564d02 to 0x0

Fixes: 9d3c447c72fb2 ("KVM: X86: Fix async pf caused null-ptr-deref")
Reported-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20200911093147.484565-1-vkuznets@redhat.com>
[Actually commit the version proposed by Sean Christopherson. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f7304132d5907..f5481ae588aff 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2696,7 +2696,7 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 		return 1;
 
 	if (!lapic_in_kernel(vcpu))
-		return 1;
+		return data ? 1 : 0;
 
 	vcpu->arch.apf.msr_en_val = data;
 
-- 
2.25.1



