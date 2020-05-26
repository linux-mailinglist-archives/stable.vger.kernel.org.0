Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61C31E26B8
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 18:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbgEZQTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 12:19:12 -0400
Received: from foss.arm.com ([217.140.110.172]:53038 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728280AbgEZQTM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 12:19:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6946330E;
        Tue, 26 May 2020 09:19:11 -0700 (PDT)
Received: from merodach.members.linode.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6250A3F52E;
        Tue, 26 May 2020 09:19:10 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc:     Marc Zyngier <maz@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>, stable@vger.kernel.org
Subject: [PATCH 1/3] KVM: arm64: Stop writing aarch32's CSSELR into ACTLR
Date:   Tue, 26 May 2020 16:18:32 +0000
Message-Id: <20200526161834.29165-2-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200526161834.29165-1-james.morse@arm.com>
References: <20200526161834.29165-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Rename access_csselr() to access_csselr_el1(), to indicate it expects
the 64bit register index, and pass it CSSELR_EL1 from cp15_regs[].

Cc: stable@vger.kernel.org
Signed-off-by: James Morse <james.morse@arm.com>
----
Providing access_csselr_cp15() wouldn't work as with VHE CSSELR_EL1 is
loaded on the CPU while this code runs. access_csselr_cp15() would have
to map it back the 64bit resgister to use vcpu_write_sys_reg(). We may
as well do it in the table.

 arch/arm64/kvm/sys_regs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 51db934702b6..2eda539f3281 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1302,7 +1302,7 @@ static bool access_clidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
-static bool access_csselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+static bool access_csselr_el1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
 	if (p->is_write)
@@ -1566,7 +1566,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_CCSIDR_EL1), access_ccsidr },
 	{ SYS_DESC(SYS_CLIDR_EL1), access_clidr },
-	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
+	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr_el1, reset_unknown, CSSELR_EL1 },
 	{ SYS_DESC(SYS_CTR_EL0), access_ctr },
 
 	{ SYS_DESC(SYS_PMCR_EL0), access_pmcr, reset_pmcr, PMCR_EL0 },
@@ -2060,7 +2060,7 @@ static const struct sys_reg_desc cp15_regs[] = {
 
 	{ Op1(1), CRn( 0), CRm( 0), Op2(0), access_ccsidr },
 	{ Op1(1), CRn( 0), CRm( 0), Op2(1), access_clidr },
-	{ Op1(2), CRn( 0), CRm( 0), Op2(0), access_csselr, NULL, c0_CSSELR },
+	{ Op1(2), CRn( 0), CRm( 0), Op2(0), access_csselr_el1, NULL, CSSELR_EL1 },
 };
 
 static const struct sys_reg_desc cp15_64_regs[] = {
-- 
2.20.1

