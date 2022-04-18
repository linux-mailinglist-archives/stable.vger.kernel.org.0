Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15458505062
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238394AbiDRMYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238389AbiDRMY0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:24:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857A81FCC7;
        Mon, 18 Apr 2022 05:19:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 009CF60F01;
        Mon, 18 Apr 2022 12:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148EBC385A1;
        Mon, 18 Apr 2022 12:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284345;
        bh=B0VnKu5hWY8Nkmb9H9cq2QHkp/C1sAFGmLN4yP3jlG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ui5J+W08h5H+x6vBj3N1ML549K7BJSIVosPUfsKHCkBCLDZptizZmFf7ogz4zh6yU
         5obLlUZ8gnaio/r3C6Uvac/H4SSq0LClk0wt41YSn5dyL5I5BNPGpFEy0muoXSuEiv
         2q4om+kzWjWvWJ/kQSN6v8gKHg4Q9h2HkAoXODAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 081/219] KVM: selftests: riscv: Set PTE A and D bits in VS-stage page table
Date:   Mon, 18 Apr 2022 14:10:50 +0200
Message-Id: <20220418121208.514660383@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anup Patel <apatel@ventanamicro.com>

[ Upstream commit fac3725364397f9a40a101f089b86ea655a58d06 ]

Supporting hardware updates of PTE A and D bits is optional for any
RISC-V implementation so current software strategy is to always set
these bits in both G-stage (hypervisor) and VS-stage (guest kernel).

If PTE A and D bits are not set by software (hypervisor or guest)
then RISC-V implementations not supporting hardware updates of these
bits will cause traps even for perfectly valid PTEs.

Based on above explanation, the VS-stage page table created by various
KVM selftest applications is not correct because PTE A and D bits are
not set. This patch fixes VS-stage page table programming of PTE A and
D bits for KVM selftests.

Fixes: 3e06cdf10520 ("KVM: selftests: Add initial support for RISC-V
64-bit")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Tested-by: Mayuresh Chitale <mchitale@ventanamicro.com>
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/include/riscv/processor.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/tools/testing/selftests/kvm/include/riscv/processor.h
index dc284c6bdbc3..eca5c622efd2 100644
--- a/tools/testing/selftests/kvm/include/riscv/processor.h
+++ b/tools/testing/selftests/kvm/include/riscv/processor.h
@@ -101,7 +101,9 @@ static inline void set_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t id,
 #define PGTBL_PTE_WRITE_SHIFT			2
 #define PGTBL_PTE_READ_MASK			0x0000000000000002ULL
 #define PGTBL_PTE_READ_SHIFT			1
-#define PGTBL_PTE_PERM_MASK			(PGTBL_PTE_EXECUTE_MASK | \
+#define PGTBL_PTE_PERM_MASK			(PGTBL_PTE_ACCESSED_MASK | \
+						 PGTBL_PTE_DIRTY_MASK | \
+						 PGTBL_PTE_EXECUTE_MASK | \
 						 PGTBL_PTE_WRITE_MASK | \
 						 PGTBL_PTE_READ_MASK)
 #define PGTBL_PTE_VALID_MASK			0x0000000000000001ULL
-- 
2.35.1



