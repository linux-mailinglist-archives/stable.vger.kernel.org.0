Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE7B441236C
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348220AbhITSZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:25:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377967AbhITSWR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:22:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED402613D3;
        Mon, 20 Sep 2021 17:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158643;
        bh=66r49HTNwkwE+JMJG+EQWMjUJv8oQQa5yygb5WMrK88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ym6chfVT1Ssk1n4Z7he4PlGnAvXL894JSxXFS6hYkrZ4qP/ivwnmVJm88frfGxfiL
         P4MOlG7Hq5V0qBPYK9QsXuBjx8vEAYVoqqTsn8PNXztF7Ec/EHCIhhUaN+wmsG3Ykz
         Pzyx6wj7XXJj12tEW3kaBYeaQXnd8uAUY9s32KlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 250/260] KVM: arm64: Handle PSCI resets before userspace touches vCPU state
Date:   Mon, 20 Sep 2021 18:44:28 +0200
Message-Id: <20210920163939.606845863@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
 virt/kvm/arm/arm.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 4af85605730e..f7150fbeeb55 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1141,6 +1141,14 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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



