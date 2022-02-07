Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A36394ABCBE
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387087AbiBGLjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384361AbiBGL2A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:28:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AC3C03FEFF;
        Mon,  7 Feb 2022 03:26:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83E96B811B3;
        Mon,  7 Feb 2022 11:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95ECC004E1;
        Mon,  7 Feb 2022 11:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233166;
        bh=tzgF2lLRVeO9JbCxJ6yO7uNVPTSA0/Rh2rbE1TmBoxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uX7ZnLp0r+ITwFkZPBvmyMgfN/ZG0pFX/kYkXIS60NYtUy31kPRIQ4pF4fttZw7kQ
         AaGFcdQx9bu0lNERJRl22TINzxqkVZDQeglJ3qp5k+RF0ams6NmAEqNCG5PkDsOd5t
         ngCHmCq+qr+k2jRdg0SJuaW3L+K39qMOIapdN2rU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Price <steven.price@arm.com>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.15 037/110] KVM: arm64: Avoid consuming a stale esr value when SError occur
Date:   Mon,  7 Feb 2022 12:06:10 +0100
Message-Id: <20220207103803.530037238@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit 1c71dbc8a179d99dd9bb7e7fc1888db613cf85de upstream.

When any exception other than an IRQ occurs, the CPU updates the ESR_EL2
register with the exception syndrome. An SError may also become pending,
and will be synchronised by KVM. KVM notes the exception type, and whether
an SError was synchronised in exit_code.

When an exception other than an IRQ occurs, fixup_guest_exit() updates
vcpu->arch.fault.esr_el2 from the hardware register. When an SError was
synchronised, the vcpu esr value is used to determine if the exception
was due to an HVC. If so, ELR_EL2 is moved back one instruction. This
is so that KVM can process the SError first, and re-execute the HVC if
the guest survives the SError.

But if an IRQ synchronises an SError, the vcpu's esr value is stale.
If the previous non-IRQ exception was an HVC, KVM will corrupt ELR_EL2,
causing an unrelated guest instruction to be executed twice.

Check ARM_EXCEPTION_CODE() before messing with ELR_EL2, IRQs don't
update this register so don't need to check.

Fixes: defe21f49bc9 ("KVM: arm64: Move PC rollback on SError to HYP")
Cc: stable@vger.kernel.org
Reported-by: Steven Price <steven.price@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220127122052.1584324-3-james.morse@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -425,7 +425,8 @@ static inline bool fixup_guest_exit(stru
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
 		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
 
-	if (ARM_SERROR_PENDING(*exit_code)) {
+	if (ARM_SERROR_PENDING(*exit_code) &&
+	    ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ) {
 		u8 esr_ec = kvm_vcpu_trap_get_class(vcpu);
 
 		/*


