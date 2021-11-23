Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44CF845A853
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 17:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239359AbhKWQkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 11:40:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236983AbhKWQkY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 11:40:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13D4160FE7;
        Tue, 23 Nov 2021 16:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685435;
        bh=+2nW/cKUU85rDaInywuytDhd30VkHQrYkOcr8URVJ6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ems+nProHdyY2oJSWznvKTkIVsMCsucDi3d8Vl6UaodQ9BWP9z/aZeOfu8L6CnmaN
         5CaeCRDrQH+h5mHnMuaic2ecsNXu/Gt28E8A7reypbLB6IuLo6JOyi6XoXfp2om+69
         SjepYcxaBbanDw1k1kvJ1O4FZCbIZccfnHh1TaRDpZmZBc5QY9LFULo7GWK4O2tgf2
         Mp97zWREB8w6xM5rZ93heW0Nsu0Ovi5Ab4JTJOtWSVXYHw1H5S5uw5Jd0Y/zBnM8pQ
         e9zfn6HsRQgK/+7YjLrwju16jYa4s45ICnt1wVkKYDL12u/BZNSyAEAH8DnkrfPGqv
         H1qi+6l2tBV4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, chenhuacai@kernel.org,
        aleksandar.qemu.devel@gmail.com, tsbogend@alpha.franken.de,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.4 4/4] KVM: MIPS: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
Date:   Tue, 23 Nov 2021 11:37:03 -0500
Message-Id: <20211123163706.289562-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211123163706.289562-1-sashal@kernel.org>
References: <20211123163706.289562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit 57a2e13ebdda8b65602b44ec8b80e385603eb84c ]

It doesn't make sense to return the recommended maximum number of
vCPUs which exceeds the maximum possible number of vCPUs.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20211116163443.88707-3-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kvm/mips.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index b22a3565e1330..f5ea5700b2e5c 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1109,7 +1109,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = 1;
 		break;
 	case KVM_CAP_NR_VCPUS:
-		r = num_online_cpus();
+		r = min_t(unsigned int, num_online_cpus(), KVM_MAX_VCPUS);
 		break;
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
-- 
2.33.0

