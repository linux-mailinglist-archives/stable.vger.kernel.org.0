Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCC51FB9D4
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731912AbgFPQHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731610AbgFPPrU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:47:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D41FB20776;
        Tue, 16 Jun 2020 15:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322440;
        bh=tXCInQ492qS0VJvjkWDrgHfS0WMGwrboSxRtphkF/Fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rW5U0YRKejJCyG0AD5hBEeWUZvu+xpQEZ+bRpgD6unz95Dk3LQ4aMkYcxRFZp9bEs
         LVjxyCL/CgFXrbLrOezhDfnIv5ORY3BpxLVdyoLoekLk77T3f1CLXH5rv0nPcxRgci
         ZL2DmEjJi596TdZs1aB1Np8qRPlW4msyFAASmMY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.7 133/163] KVM: arm64: Stop writing aarch32s CSSELR into ACTLR
Date:   Tue, 16 Jun 2020 17:35:07 +0200
Message-Id: <20200616153113.183145359@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit 7c582bf4ed84f3eb58bdd1f63024a14c17551e7d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kvm/sys_regs.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1305,10 +1305,16 @@ static bool access_clidr(struct kvm_vcpu
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
 


