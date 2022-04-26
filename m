Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 470E650F73E
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346009AbiDZJGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347321AbiDZJF1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:05:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A5410FF35;
        Tue, 26 Apr 2022 01:44:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 90520CE1BC9;
        Tue, 26 Apr 2022 08:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B240C385A4;
        Tue, 26 Apr 2022 08:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962662;
        bh=DmMGXqK7DS2Xf58XdTr8GbA0QdOIbiW13DwxnpGq0S8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fp440xzHA8bW9i4PISZ6DpncbW2z0sUhjMPWYisnRIoh3mhTL1pg6J6a8swrkWV5q
         3ZOHfbw7kn5R+BoRny3dsRR9sHewN9z95mkY4CFurg4oEYHN4c4ihwg3yU7DWXtOvo
         zYOw+V+j0mpx4rsnq8lMwX7GP0TGo8mGk3LRZkSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 046/146] RISC-V: KVM: Restrict the extensions that can be disabled
Date:   Tue, 26 Apr 2022 10:20:41 +0200
Message-Id: <20220426081751.364424754@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Atish Patra <atishp@rivosinc.com>

[ Upstream commit 38d9a4ac65f204f264b33b966f0af4366f5518a8 ]

Currently, the config isa register allows us to disable all allowed
single letter ISA extensions. It shouldn't be the case as vmm shouldn't
be able to disable base extensions (imac).

These extensions should always be enabled as long as they are enabled
in the host ISA.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Anup Patel <anup@brainfault.org>
Fixes: 92ad82002c39 ("RISC-V: KVM: Implement
KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 2e25a7b83a1b..aad430668bb4 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -38,12 +38,16 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
 		       sizeof(kvm_vcpu_stats_desc),
 };
 
-#define KVM_RISCV_ISA_ALLOWED	(riscv_isa_extension_mask(a) | \
-				 riscv_isa_extension_mask(c) | \
-				 riscv_isa_extension_mask(d) | \
-				 riscv_isa_extension_mask(f) | \
-				 riscv_isa_extension_mask(i) | \
-				 riscv_isa_extension_mask(m))
+#define KVM_RISCV_ISA_DISABLE_ALLOWED	(riscv_isa_extension_mask(d) | \
+					riscv_isa_extension_mask(f))
+
+#define KVM_RISCV_ISA_DISABLE_NOT_ALLOWED	(riscv_isa_extension_mask(a) | \
+						riscv_isa_extension_mask(c) | \
+						riscv_isa_extension_mask(i) | \
+						riscv_isa_extension_mask(m))
+
+#define KVM_RISCV_ISA_ALLOWED (KVM_RISCV_ISA_DISABLE_ALLOWED | \
+			       KVM_RISCV_ISA_DISABLE_NOT_ALLOWED)
 
 static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 {
@@ -217,7 +221,8 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 	switch (reg_num) {
 	case KVM_REG_RISCV_CONFIG_REG(isa):
 		if (!vcpu->arch.ran_atleast_once) {
-			vcpu->arch.isa = reg_val;
+			/* Ignore the disable request for these extensions */
+			vcpu->arch.isa = reg_val | KVM_RISCV_ISA_DISABLE_NOT_ALLOWED;
 			vcpu->arch.isa &= riscv_isa_extension_base(NULL);
 			vcpu->arch.isa &= KVM_RISCV_ISA_ALLOWED;
 			kvm_riscv_vcpu_fp_reset(vcpu);
-- 
2.35.1



