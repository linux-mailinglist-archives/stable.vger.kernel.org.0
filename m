Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9345A16F3
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 12:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbfH2KwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 06:52:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728579AbfH2KvS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 06:51:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B85C723427;
        Thu, 29 Aug 2019 10:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567075877;
        bh=LUbZq5RNgQvDztv0DBqWpD+rrSm6QAldMQFxXL2DynQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/F3+Ys8Zu3e5HDY6eVsmMMWyv4g6ksGcW1goytWpkTel3CpViG+frfyQfjJCUCrW
         yrWgZVnhKbvhSmnwALgLP4wr0IhR/CN7Id96w60FOUY35vdwfK5xhj2FBVaZR7Gqk9
         EOeU/V6OBvb1lVe4zEhR/NoV9NhmfxfZsb05fMLM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 5/6] KVM: arm/arm64: Only skip MMIO insn once
Date:   Thu, 29 Aug 2019 06:51:09 -0400
Message-Id: <20190829105110.2748-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829105110.2748-1-sashal@kernel.org>
References: <20190829105110.2748-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Jones <drjones@redhat.com>

[ Upstream commit 2113c5f62b7423e4a72b890bd479704aa85c81ba ]

If after an MMIO exit to userspace a VCPU is immediately run with an
immediate_exit request, such as when a signal is delivered or an MMIO
emulation completion is needed, then the VCPU completes the MMIO
emulation and immediately returns to userspace. As the exit_reason
does not get changed from KVM_EXIT_MMIO in these cases we have to
be careful not to complete the MMIO emulation again, when the VCPU is
eventually run again, because the emulation does an instruction skip
(and doing too many skips would be a waste of guest code :-) We need
to use additional VCPU state to track if the emulation is complete.
As luck would have it, we already have 'mmio_needed', which even
appears to be used in this way by other architectures already.

Fixes: 0d640732dbeb ("arm64: KVM: Skip MMIO insn after emulation")
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kvm/mmio.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
index ae61e2ea7255b..d2efc033ef8b4 100644
--- a/arch/arm/kvm/mmio.c
+++ b/arch/arm/kvm/mmio.c
@@ -98,6 +98,12 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	unsigned int len;
 	int mask;
 
+	/* Detect an already handled MMIO return */
+	if (unlikely(!vcpu->mmio_needed))
+		return 0;
+
+	vcpu->mmio_needed = 0;
+
 	if (!run->mmio.is_write) {
 		len = run->mmio.len;
 		if (len > sizeof(unsigned long))
@@ -206,6 +212,7 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	run->mmio.is_write	= is_write;
 	run->mmio.phys_addr	= fault_ipa;
 	run->mmio.len		= len;
+	vcpu->mmio_needed	= 1;
 
 	if (!ret) {
 		/* We handled the access successfully in the kernel. */
-- 
2.20.1

