Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5250C330189
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhCGN6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:58:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:43548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231512AbhCGN5w (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 08:57:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2191565105;
        Sun,  7 Mar 2021 13:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615125471;
        bh=9TCSJgcR6u2SdCY9KvCmvnAp+LuBrYghyXysTkfVj8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i7AlBR0p8RgmZ4JO2SVfz03PcpLyfJroey8nLtjVLDyd14gT31l1kct0P3f3Nq5D4
         nlOZtg/LiqZNkPTVY3hr9lflRo4Wb38+13eFLkokuhXd/uto8HlGoselHGgki0mGDY
         ERWphI1bop7qeP6qstLet0MyrENoOO1gf1rpOUUSRIEW1hr8HdISf4WswooGsBsS3G
         Bak65PdApIHbu5Z1uwrVY1WkYYXm5BwKqXwbaztTBQhJ/1g81qHCCGr+3hsvrjwvLm
         vpC+9xTgVvImcPEVBtJsqfN9vnOO3RAGUnm7Qns0qohPEyuMn8Xj+c9BJFRuqDGki5
         2GVAWkKHZjJyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Steve Rutherford <srutherford@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 04/12] selftests: kvm: Mmap the entire vcpu mmap area
Date:   Sun,  7 Mar 2021 08:57:38 -0500
Message-Id: <20210307135746.967418-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210307135746.967418-1-sashal@kernel.org>
References: <20210307135746.967418-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Lewis <aaronlewis@google.com>

[ Upstream commit 6528fc0a11de3d16339cf17639e2f69a68fcaf4d ]

The vcpu mmap area may consist of more than just the kvm_run struct.
Allocate enough space for the entire vcpu mmap area. Without this, on
x86, the PIO page, for example, will be missing.  This is problematic
when dealing with an unhandled exception from the guest as the exception
vector will be incorrectly reported as 0x0.

Message-Id: <20210210165035.3712489-1-aaronlewis@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Co-developed-by: Steve Rutherford <srutherford@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index fa5a90e6c6f0..859a0b57c683 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -21,6 +21,8 @@
 #define KVM_UTIL_PGS_PER_HUGEPG 512
 #define KVM_UTIL_MIN_PFN	2
 
+static int vcpu_mmap_sz(void);
+
 /* Aligns x up to the next multiple of size. Size must be a power of 2. */
 static void *align(void *x, size_t size)
 {
@@ -509,7 +511,7 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
 		vcpu->dirty_gfns = NULL;
 	}
 
-	ret = munmap(vcpu->state, sizeof(*vcpu->state));
+	ret = munmap(vcpu->state, vcpu_mmap_sz());
 	TEST_ASSERT(ret == 0, "munmap of VCPU fd failed, rc: %i "
 		"errno: %i", ret, errno);
 	close(vcpu->fd);
@@ -978,7 +980,7 @@ void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
 	TEST_ASSERT(vcpu_mmap_sz() >= sizeof(*vcpu->state), "vcpu mmap size "
 		"smaller than expected, vcpu_mmap_sz: %i expected_min: %zi",
 		vcpu_mmap_sz(), sizeof(*vcpu->state));
-	vcpu->state = (struct kvm_run *) mmap(NULL, sizeof(*vcpu->state),
+	vcpu->state = (struct kvm_run *) mmap(NULL, vcpu_mmap_sz(),
 		PROT_READ | PROT_WRITE, MAP_SHARED, vcpu->fd, 0);
 	TEST_ASSERT(vcpu->state != MAP_FAILED, "mmap vcpu_state failed, "
 		"vcpu id: %u errno: %i", vcpuid, errno);
-- 
2.30.1

