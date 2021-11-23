Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9202145A861
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 17:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235648AbhKWQlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 11:41:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239026AbhKWQkb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 11:40:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50A1860F9D;
        Tue, 23 Nov 2021 16:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685442;
        bh=x9kazOj5xmu8CcSGoQdyaGj4+h5gviBqE8dLUXfhz0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g35t7ep5JJTtQ5Rp/9pqWnhohwXK0BRF9LmSRQ6OA9WTgfZN7K/igPdlZMqYLGQuj
         5Gkaaq85wXAawA0ZHpdk+1W68bVoUusUm+W/rdumw4yw6Sl5lFWyESPupSlz8fwvYw
         LhDtJFKQ2Xhq1IpywkinzcT34mvsfq4o9lJef5oVyLG77mT2U9P+XiwTptObA11esA
         9w71b6vjLCjqF5xqe1Xghu/gT3Zm8QCSnNKPqlAzo6yF6/TPRyYBSk0Xh5k8olxhbm
         hDHoPktlnCkw+JNX52UqeCAo+WQOACeqsBh/QEp+03S4vbmGttL6bWUuCXXzsL30Hw
         owkn/DOlotWqA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, mpe@ellerman.id.au,
        paulus@ozlabs.org, christophe.leroy@csgroup.eu,
        segher@kernel.crashing.org, ndesaulniers@google.com,
        npiggin@gmail.com, jgross@suse.com, clg@kaod.org,
        ravi.bangoria@linux.ibm.com, bharata@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH MANUALSEL 4.19 3/4] KVM: PPC: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
Date:   Tue, 23 Nov 2021 11:37:14 -0500
Message-Id: <20211123163715.289631-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211123163715.289631-1-sashal@kernel.org>
References: <20211123163715.289631-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit b7915d55b1ac0e68a7586697fa2d06c018135c49 ]

It doesn't make sense to return the recommended maximum number of
vCPUs which exceeds the maximum possible number of vCPUs.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20211116163443.88707-4-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/powerpc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index ad5a871a6cbfd..e68b1bc86824a 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -627,9 +627,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		 * implementations just count online CPUs.
 		 */
 		if (hv_enabled)
-			r = num_present_cpus();
+			r = min_t(unsigned int, num_present_cpus(), KVM_MAX_VCPUS);
 		else
-			r = num_online_cpus();
+			r = min_t(unsigned int, num_online_cpus(), KVM_MAX_VCPUS);
 		break;
 	case KVM_CAP_NR_MEMSLOTS:
 		r = KVM_USER_MEM_SLOTS;
-- 
2.33.0

