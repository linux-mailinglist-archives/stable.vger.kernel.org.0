Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4765F3D61A0
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbhGZPc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231603AbhGZPa3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:30:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB18160FBF;
        Mon, 26 Jul 2021 16:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315857;
        bh=pQW89YAYR2HIz9OaHPj/TOK2qBZCX0ew7u1HPvPdIec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BepJq4aXonU83mh/tCUH03d8SvAQ4rOh4lSPB9xvLAhKvYVIwd2mCqXsz/kYd/Lql
         unL1IYz0D7d5ClMDuih05HOLj5UStkSrDUE3T0wECJnDy+rEngXttFifOHAWmg0qQ1
         mjFYoCxlkTX6PY2lMecg8iC5chMPCxbABWZfimdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 094/223] KVM: PPC: Fix kvm_arch_vcpu_ioctl vcpu_load leak
Date:   Mon, 26 Jul 2021 17:38:06 +0200
Message-Id: <20210726153849.328213130@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
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
index a2a68a958fa0..6e4f03c02a0a 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -2045,9 +2045,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
@@ -2071,9 +2071,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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



