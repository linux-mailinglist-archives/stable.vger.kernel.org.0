Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23FF737C9EE
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235457AbhELQX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:23:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240588AbhELQSY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:18:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37D1161454;
        Wed, 12 May 2021 15:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834276;
        bh=rttTnCwfjfmsnLPiV/CV+L0rzLaFEhlGgmiokshtVH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CnuwtWkxeJ4amdn24dPJWPmURj0AqPEA38uIeoVpn6Aa4seqeM2xbtQOHdSr4fnyT
         60wcO0voqwlx8Y3clxbDawXTLeZB9dtCPw1gJI9PekTXeEl8rlNuNPbgLO9BubalKD
         jvfDSr1BIHFy9Ad6LFnx93i0rB74N0b5L+ji7hpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 478/601] KVM: PPC: Book3S HV P9: Restore host CTRL SPR after guest exit
Date:   Wed, 12 May 2021 16:49:15 +0200
Message-Id: <20210512144843.585572573@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 5088eb4092df12d701af8e0e92860b7186365279 ]

The host CTRL (runlatch) value is not restored after guest exit. The
host CTRL should always be 1 except in CPU idle code, so this can result
in the host running with runlatch clear, and potentially switching to
a different vCPU which then runs with runlatch clear as well.

This has little effect on P9 machines, CTRL is only responsible for some
PMU counter logic in the host and so other than corner cases of software
relying on that, or explicitly reading the runlatch value (Linux does
not appear to be affected but it's possible non-Linux guests could be),
there should be no execution correctness problem, though it could be
used as a covert channel between guests.

There may be microcontrollers, firmware or monitoring tools that sample
the runlatch value out-of-band, however since the register is writable
by guests, these values would (should) not be relied upon for correct
operation of the host, so suboptimal performance or incorrect reporting
should be the worst problem.

Fixes: 95a6432ce9038 ("KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix guests")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210412014845.1517916-2-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 6f612d240392..138556cb559d 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3709,7 +3709,10 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	vcpu->arch.dec_expires = dec + tb;
 	vcpu->cpu = -1;
 	vcpu->arch.thread_cpu = -1;
+	/* Save guest CTRL register, set runlatch to 1 */
 	vcpu->arch.ctrl = mfspr(SPRN_CTRLF);
+	if (!(vcpu->arch.ctrl & 1))
+		mtspr(SPRN_CTRLT, vcpu->arch.ctrl | 1);
 
 	vcpu->arch.iamr = mfspr(SPRN_IAMR);
 	vcpu->arch.pspb = mfspr(SPRN_PSPB);
-- 
2.30.2



