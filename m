Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4F63D5F6C
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236913AbhGZPRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:17:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236655AbhGZPMC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:12:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 275AE60F44;
        Mon, 26 Jul 2021 15:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314745;
        bh=CE5gWQ4pc9cN4I+gpmiNt6+jqpf3ayHuXU0UHSTuHYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2II5meeOSshpAwLph5bgP8ICcHXtBf9B94ESv9HZPoPctLgjuxQbSfgvxnHmmJlxG
         5wATOxOUmnKUGSw0h1KJXMww6cXQaErxg+sl8D+7mYFnWRnJCyS58Nldf80IjycnZg
         tOR2pTpdnqYIEknfiZudIvgGUU8KV/k7W0Hm8SoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 077/120] KVM: PPC: Fix kvm_arch_vcpu_ioctl vcpu_load leak
Date:   Mon, 26 Jul 2021 17:38:49 +0200
Message-Id: <20210726153834.864225743@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit bc4188a2f56e821ea057aca6bf444e138d06c252 ]

vcpu_put is not called if the user copy fails. This can result in preempt
notifier corruption and crashes, among other issues.

Fixes: b3cebfe8c1ca ("KVM: PPC: Move vcpu_load/vcpu_put down to each ioctl case in kvm_arch_vcpu_ioctl")
Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210716024310.164448-2-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/powerpc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 7c8354dfe80e..ad5a871a6cbf 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -1995,9 +1995,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	{
 		struct kvm_enable_cap cap;
 		r = -EFAULT;
-		vcpu_load(vcpu);
 		if (copy_from_user(&cap, argp, sizeof(cap)))
 			goto out;
+		vcpu_load(vcpu);
 		r = kvm_vcpu_ioctl_enable_cap(vcpu, &cap);
 		vcpu_put(vcpu);
 		break;
@@ -2021,9 +2021,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_DIRTY_TLB: {
 		struct kvm_dirty_tlb dirty;
 		r = -EFAULT;
-		vcpu_load(vcpu);
 		if (copy_from_user(&dirty, argp, sizeof(dirty)))
 			goto out;
+		vcpu_load(vcpu);
 		r = kvm_vcpu_ioctl_dirty_tlb(vcpu, &dirty);
 		vcpu_put(vcpu);
 		break;
-- 
2.30.2



