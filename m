Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6DB412621
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386091AbhITSxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:53:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1385512AbhITSue (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:50:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B98BB61B1B;
        Mon, 20 Sep 2021 17:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159296;
        bh=S9GpUT2zPaFCVHTn4TLRuJ0//T5Z664GS/xBdhStYvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q4AMaL8EVKnq5kLzxlryKtWzMt9E4MkUGsyrjfwJTp5D/3k6HoHPsx/VNc15ELcGh
         5N/lOv6MUQvZNiqb6+4WD9+92R28QxxU0+UeTjF3PWeg8E/4O0IVr13r6dJjh3MsyA
         BZ0rxf1lAVUMDfiB8l4sFs96APkD49ZB0DBIERbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 134/168] KVM: arm64: Handle PSCI resets before userspace touches vCPU state
Date:   Mon, 20 Sep 2021 18:44:32 +0200
Message-Id: <20210920163926.070528257@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Upton <oupton@google.com>

[ Upstream commit 6826c6849b46aaa91300201213701eb861af4ba0 ]

The CPU_ON PSCI call takes a payload that KVM uses to configure a
destination vCPU to run. This payload is non-architectural state and not
exposed through any existing UAPI. Effectively, we have a race between
CPU_ON and userspace saving/restoring a guest: if the target vCPU isn't
ran again before the VMM saves its state, the requested PC and context
ID are lost. When restored, the target vCPU will be runnable and start
executing at its old PC.

We can avoid this race by making sure the reset payload is serviced
before userspace can access a vCPU's state.

Fixes: 358b28f09f0a ("arm/arm64: KVM: Allow a VCPU to fully reset itself")
Signed-off-by: Oliver Upton <oupton@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210818202133.1106786-3-oupton@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/arm.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5d1fc9c4bca5..45ee8abcf202 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1220,6 +1220,14 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (copy_from_user(&reg, argp, sizeof(reg)))
 			break;
 
+		/*
+		 * We could owe a reset due to PSCI. Handle the pending reset
+		 * here to ensure userspace register accesses are ordered after
+		 * the reset.
+		 */
+		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
+			kvm_reset_vcpu(vcpu);
+
 		if (ioctl == KVM_SET_ONE_REG)
 			r = kvm_arm_set_reg(vcpu, &reg);
 		else
-- 
2.30.2



