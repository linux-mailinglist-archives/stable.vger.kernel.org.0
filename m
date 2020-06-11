Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB871F6458
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 11:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgFKJKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 05:10:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbgFKJKK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 05:10:10 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF148207C3;
        Thu, 11 Jun 2020 09:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591866609;
        bh=vyQtmLIVDneB1pJMn5qI66pBjWc2deqISXcaIMIqJvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCstSVIq4qIy/CblpW3/Nhxqlw7R6wj6Do3NnrtHBOKR5T8G1wCznmoizZJ54rlG4
         4XtX486RkJ4mUiIjNPBR0T2zVxAu/pYjpIJm3HMPDO9zNUdCLFSDpS9ars481d0fCK
         CtV5Vd7r6Zop+HfX9DlM8D3nd7cxuiYwnCHGv2fo=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jjJDs-0022ZT-Cf; Thu, 11 Jun 2020 10:10:08 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: [PATCH 02/11] KVM: arm64: Stop writing aarch32's CSSELR into ACTLR
Date:   Thu, 11 Jun 2020 10:09:47 +0100
Message-Id: <20200611090956.1537104-3-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611090956.1537104-1-maz@kernel.org>
References: <20200611090956.1537104-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, ascull@google.com, james.morse@arm.com, mark.rutland@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

aarch32 has pairs of registers to access the high and low parts of 64bit
registers. KVM has a union of 64bit sys_regs[] and 32bit copro[]. The
32bit accessors read the high or low part of the 64bit sys_reg[] value
through the union.

Both sys_reg_descs[] and cp15_regs[] list access_csselr() as the accessor
for CSSELR{,_EL1}. access_csselr() is only aware of the 64bit sys_regs[],
and expects r->reg to be 'CSSELR_EL1' in the enum, index 2 of the 64bit
array.

cp15_regs[] uses the 32bit copro[] alias of sys_regs[]. Here CSSELR is
c0_CSSELR which is the same location in sys_reg[]. r->reg is 'c0_CSSELR',
index 4 in the 32bit array.

access_csselr() uses the 32bit r->reg value to access the 64bit array,
so reads and write the wrong value. sys_regs[4], is ACTLR_EL1, which
is subsequently save/restored when we enter the guest.

ACTLR_EL1 is supposed to be read-only for the guest. This register
only affects execution at EL1, and the host's value is restored before
we return to host EL1.

Convert the 32bit register index back to the 64bit version.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200529150656.7339-2-james.morse@arm.com
---
 arch/arm64/kvm/sys_regs.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ad1d57501d6d..12f8d57a3cb8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1319,10 +1319,16 @@ static bool access_clidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 static bool access_csselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
+	int reg = r->reg;
+
+	/* See the 32bit mapping in kvm_host.h */
+	if (p->is_aarch32)
+		reg = r->reg / 2;
+
 	if (p->is_write)
-		vcpu_write_sys_reg(vcpu, p->regval, r->reg);
+		vcpu_write_sys_reg(vcpu, p->regval, reg);
 	else
-		p->regval = vcpu_read_sys_reg(vcpu, r->reg);
+		p->regval = vcpu_read_sys_reg(vcpu, reg);
 	return true;
 }
 
-- 
2.26.2

