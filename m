Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27913658305
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbiL1QoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:44:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234997AbiL1Qnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:43:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DAD1A055
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:38:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF04C6157D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0BAC433EF;
        Wed, 28 Dec 2022 16:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245487;
        bh=PdMP5C30ft0X8j7AZsrvp3AOrowRZsfzSKyJNsTzGmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CWFdg/sLUkWsM8lR6JthV4yXnUAKz3GgswTlvR7xtr9lsZZzzV3kRmTwTh4Phxt2B
         w20ej3uP6Eb2FzivoNfSS2OAHihlCi3FNkXAzui/NlrIorNPsR3X5kkEcfobXu0Lo6
         phb24v574m2yUfDYfxQQ+JeTJJkcxjQz1kOGqP3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anup Patel <apatel@ventanamicro.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0869/1146] RISC-V: KVM: Fix reg_val check in kvm_riscv_vcpu_set_reg_config()
Date:   Wed, 28 Dec 2022 15:40:08 +0100
Message-Id: <20221228144353.772276525@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anup Patel <apatel@ventanamicro.com>

[ Upstream commit e482d9e33d5b0f222cbef7341dcd52cead6b9edc ]

The reg_val check in kvm_riscv_vcpu_set_reg_config() should only
be done for isa config register.

Fixes: 9bfd900beeec ("RISC-V: KVM: Improve ISA extension by using a bitmap")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 71ebbc4821f0..5174ef54ad1d 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -296,12 +296,15 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
 
-	/* This ONE REG interface is only defined for single letter extensions */
-	if (fls(reg_val) >= RISCV_ISA_EXT_BASE)
-		return -EINVAL;
-
 	switch (reg_num) {
 	case KVM_REG_RISCV_CONFIG_REG(isa):
+		/*
+		 * This ONE REG interface is only defined for
+		 * single letter extensions.
+		 */
+		if (fls(reg_val) >= RISCV_ISA_EXT_BASE)
+			return -EINVAL;
+
 		if (!vcpu->arch.ran_atleast_once) {
 			/* Ignore the enable/disable request for certain extensions */
 			for (i = 0; i < RISCV_ISA_EXT_BASE; i++) {
-- 
2.35.1



