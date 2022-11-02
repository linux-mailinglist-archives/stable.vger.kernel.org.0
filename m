Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B15E615860
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbiKBCux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbiKBCux (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:50:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3571C209A7
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:50:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3937B82063
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A210C433C1;
        Wed,  2 Nov 2022 02:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357449;
        bh=IL9mwkCOqQDeh2v5PAetMyxa34X3gq4p4FU9iDhEzHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d30fTvpyLxlHox9xNjeLI+GaoPY8lY20pStQVGN75/XMoK9kRj72zv2C9yH4HUR3P
         n+8EClwPEXp33fKq2nrdMZeHnA5lAoyiMYjni8Epd4NawgcgWjCo6myl8IuCI2nVIc
         mpUDHvRHC4hSH9i/dmKcRRHjyWnyfykfPKNilEe8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrew Jones <ajones@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 171/240] RISC-V: KVM: Provide UAPI for Zicbom block size
Date:   Wed,  2 Nov 2022 03:32:26 +0100
Message-Id: <20221102022115.252964232@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Jones <ajones@ventanamicro.com>

[ Upstream commit afd5dde9a186b8fc5742fff707f184760c4af1a9 ]

We're about to allow guests to use the Zicbom extension. KVM
userspace needs to know the cache block size in order to
properly advertise it to the guest. Provide a virtual config
register for userspace to get it with the GET_ONE_REG API, but
setting it cannot be supported, so disallow SET_ONE_REG.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Anup Patel <anup@brainfault.org>
Stable-dep-of: 5c20a3a9df19 ("RISC-V: Fix compilation without RISCV_ISA_ZICBOM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/uapi/asm/kvm.h | 1 +
 arch/riscv/kvm/vcpu.c             | 8 ++++++++
 arch/riscv/mm/dma-noncoherent.c   | 2 ++
 3 files changed, 11 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 7351417afd62..b9a4cf36be4b 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -48,6 +48,7 @@ struct kvm_sregs {
 /* CONFIG registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
 struct kvm_riscv_config {
 	unsigned long isa;
+	unsigned long zicbom_block_size;
 };
 
 /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index d0f08d5b4282..2ef33d5d94d1 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -18,6 +18,7 @@
 #include <linux/fs.h>
 #include <linux/kvm_host.h>
 #include <asm/csr.h>
+#include <asm/cacheflush.h>
 #include <asm/hwcap.h>
 
 const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
@@ -254,6 +255,11 @@ static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
 	case KVM_REG_RISCV_CONFIG_REG(isa):
 		reg_val = vcpu->arch.isa[0] & KVM_RISCV_BASE_ISA_MASK;
 		break;
+	case KVM_REG_RISCV_CONFIG_REG(zicbom_block_size):
+		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOM))
+			return -EINVAL;
+		reg_val = riscv_cbom_block_size;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -311,6 +317,8 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 			return -EOPNOTSUPP;
 		}
 		break;
+	case KVM_REG_RISCV_CONFIG_REG(zicbom_block_size):
+		return -EOPNOTSUPP;
 	default:
 		return -EINVAL;
 	}
diff --git a/arch/riscv/mm/dma-noncoherent.c b/arch/riscv/mm/dma-noncoherent.c
index e3f9bdf47c5f..b0add983530a 100644
--- a/arch/riscv/mm/dma-noncoherent.c
+++ b/arch/riscv/mm/dma-noncoherent.c
@@ -13,6 +13,8 @@
 #include <asm/cacheflush.h>
 
 unsigned int riscv_cbom_block_size;
+EXPORT_SYMBOL_GPL(riscv_cbom_block_size);
+
 static bool noncoherent_supported;
 
 void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
-- 
2.35.1



