Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B211F365A
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 10:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgFIItn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 04:49:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727124AbgFIItm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 04:49:42 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81E60207ED;
        Tue,  9 Jun 2020 08:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591692581;
        bh=X59E0JdQCbUCQrXwXF6MsA/SOxG0/0G1ya5dh8JIgH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=csXoyx6NoetAEumOCwv3V2U08twEkRIfcS+FHU1N0YUiPJgmGLDBJ92AhSmlBKgtf
         yS/+g+zgl2B0wn3f6HmJW+AmecyxIFq6Npn7rzKTblk13J0KWFehuvF21TQX37+EhC
         U3Fj21L2cC73mDm+i2G0P7uH+WC9r7ZCiqlga4Y8=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jiZwy-001PEa-2e; Tue, 09 Jun 2020 09:49:40 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, stable@vger.kernel.org
Subject: [PATCH 1/2] KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts
Date:   Tue,  9 Jun 2020 09:49:20 +0100
Message-Id: <20200609084921.1448445-2-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200609084921.1448445-1-maz@kernel.org>
References: <20200609084921.1448445-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

AArch32 CP1x registers are overlayed on their AArch64 counterparts
in the vcpu struct. This leads to an interesting problem as they
are stored in their CPU-local format, and thus a CP1x register
doesn't "hit" the lower 32bit portion of the AArch64 register on
a BE host.

To workaround this unfortunate situation, introduce a bias trick
in the vcpu_cp1x() accessors which picks the correct half of the
64bit register.

Cc: stable@vger.kernel.org
Reported-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 59029e90b557..e80c0e06f235 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -404,8 +404,14 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg);
  * CP14 and CP15 live in the same array, as they are backed by the
  * same system registers.
  */
-#define vcpu_cp14(v,r)		((v)->arch.ctxt.copro[(r)])
-#define vcpu_cp15(v,r)		((v)->arch.ctxt.copro[(r)])
+#ifdef CPU_BIG_ENDIAN
+#define CPx_OFFSET	1
+#else
+#define CPx_OFFSET	0
+#endif
+
+#define vcpu_cp14(v,r)		((v)->arch.ctxt.copro[(r) ^ CPx_OFFSET])
+#define vcpu_cp15(v,r)		((v)->arch.ctxt.copro[(r) ^ CPx_OFFSET])
 
 struct kvm_vm_stat {
 	ulong remote_tlb_flush;
-- 
2.26.2

