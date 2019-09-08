Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 027B6ACE7E
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 15:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbfIHMp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:45:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727213AbfIHMpx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:45:53 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB6EF21924;
        Sun,  8 Sep 2019 12:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946753;
        bh=cuk9IKddEYJFNC0reOXs5WcbRFOnRLMgpOZPlixQSzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=umm81KxpGozBjKxjNlbwLte/39nqDKVKKKZeXSGrOvp2tj2cwKDtSRfVJ/gnvCVH1
         ozHpqDPfkhSNzwS0s+RP8gzRyKqfVc4d9zucFy1APQWwfmaSk8sMIyygTPdkTUybQR
         rhR2oprdfujxbo5zK5clWBxjJSYimhcu7Vj8g58I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 27/40] KVM: arm/arm64: Only skip MMIO insn once
Date:   Sun,  8 Sep 2019 13:42:00 +0100
Message-Id: <20190908121127.281680454@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121114.260662089@linuxfoundation.org>
References: <20190908121114.260662089@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
 virt/kvm/arm/mmio.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
index 08443a15e6be8..3caee91bca089 100644
--- a/virt/kvm/arm/mmio.c
+++ b/virt/kvm/arm/mmio.c
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
@@ -200,6 +206,7 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	run->mmio.is_write	= is_write;
 	run->mmio.phys_addr	= fault_ipa;
 	run->mmio.len		= len;
+	vcpu->mmio_needed	= 1;
 
 	if (!ret) {
 		/* We handled the access successfully in the kernel. */
-- 
2.20.1



