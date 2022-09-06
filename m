Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1575AEBDB
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240748AbiIFOGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241621AbiIFOFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:05:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A4183F3A;
        Tue,  6 Sep 2022 06:45:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CFD161555;
        Tue,  6 Sep 2022 13:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6C4C433C1;
        Tue,  6 Sep 2022 13:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471916;
        bh=BVgdd5KVmPd4740TftEEeBD8uRSIcx8EK9LQunhv0Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oONJkgW8qVnEvAEjaC/VTV60s1MDKayMOIpA7BUov9EZKFfk8IfH9EHndU5AfuRKy
         Q3gUXRbVQZMmSK82HzS6CkKFXaM6SgJzUQaUUt9wvUI3EmlUMXclNMPa2S4pJEZuQ3
         B4CMHBgkwjHJEpU3LurPzj8AwocJFWiouUYanFcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Anup Patel <anup@brainfault.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 084/155] riscv: kvm: move extern sbi_ext declarations to a header
Date:   Tue,  6 Sep 2022 15:30:32 +0200
Message-Id: <20220906132832.989324594@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit 3e5e56c60a14776e2a49837b55b03bc193fd91f7 ]

Sparse complains about missing statics in the declarations of several
variables:
arch/riscv/kvm/vcpu_sbi_replace.c:38:37: warning: symbol 'vcpu_sbi_ext_time' was not declared. Should it be static?
arch/riscv/kvm/vcpu_sbi_replace.c:73:37: warning: symbol 'vcpu_sbi_ext_ipi' was not declared. Should it be static?
arch/riscv/kvm/vcpu_sbi_replace.c:126:37: warning: symbol 'vcpu_sbi_ext_rfence' was not declared. Should it be static?
arch/riscv/kvm/vcpu_sbi_replace.c:170:37: warning: symbol 'vcpu_sbi_ext_srst' was not declared. Should it be static?
arch/riscv/kvm/vcpu_sbi_base.c:69:37: warning: symbol 'vcpu_sbi_ext_base' was not declared. Should it be static?
arch/riscv/kvm/vcpu_sbi_base.c:90:37: warning: symbol 'vcpu_sbi_ext_experimental' was not declared. Should it be static?
arch/riscv/kvm/vcpu_sbi_base.c:96:37: warning: symbol 'vcpu_sbi_ext_vendor' was not declared. Should it be static?
arch/riscv/kvm/vcpu_sbi_hsm.c:115:37: warning: symbol 'vcpu_sbi_ext_hsm' was not declared. Should it be static?

These variables are however used in vcpu_sbi.c where they are declared
as extern. Move them to kvm_vcpu_sbi.h which is handily already
included by the three other files.

Fixes: a046c2d8578c ("RISC-V: KVM: Reorganize SBI code by moving SBI v0.1 to its own file")
Fixes: 5f862df5585c ("RISC-V: KVM: Add v0.1 replacement SBI extensions defined in v0.2")
Fixes: 3e1d86569c21 ("RISC-V: KVM: Add SBI HSM extension in KVM")
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h | 12 ++++++++++++
 arch/riscv/kvm/vcpu_sbi.c             | 12 +-----------
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index 83d6d4d2b1dff..26a446a34057b 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -33,4 +33,16 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
 				     u32 type, u64 flags);
 const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid);
 
+#ifdef CONFIG_RISCV_SBI_V01
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01;
+#endif
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor;
+
 #endif /* __RISCV_KVM_VCPU_SBI_H__ */
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index d45e7da3f0d32..f96991d230bfc 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -32,23 +32,13 @@ static int kvm_linux_err_map_sbi(int err)
 	};
 }
 
-#ifdef CONFIG_RISCV_SBI_V01
-extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01;
-#else
+#ifndef CONFIG_RISCV_SBI_V01
 static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
 	.extid_start = -1UL,
 	.extid_end = -1UL,
 	.handler = NULL,
 };
 #endif
-extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base;
-extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time;
-extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi;
-extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence;
-extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst;
-extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm;
-extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental;
-extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor;
 
 static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
 	&vcpu_sbi_ext_v01,
-- 
2.35.1



