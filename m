Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF67505064
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238424AbiDRMYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238412AbiDRMYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:24:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4B31C112;
        Mon, 18 Apr 2022 05:19:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94870B80ED6;
        Mon, 18 Apr 2022 12:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45E5C385A1;
        Mon, 18 Apr 2022 12:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284348;
        bh=I2bv2t5XZ8U/levWLZuCsmK2on3Lpul6SH2CZmzcaDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g90TRH5b4AHC3NUHMGyODktrd4Z/zoeXc52AIeaJMLbJO7cy70keIPws7+WyMBl7B
         n69sUi8orTNYroKUst3SmNz3IbWGGR50BNmPC+KC6WnY/Fo7ASx9VMJFC9s61UaRP5
         qkSU//nlJiW3lUm99tmTu4te96qhxZ6MTQR/ueok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 082/219] KVM: selftests: riscv: Fix alignment of the guest_hang() function
Date:   Mon, 18 Apr 2022 14:10:51 +0200
Message-Id: <20220418121208.591239042@linuxfoundation.org>
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

[ Upstream commit ebdef0de2dbc40e697adaa6b3408130f7a7b8351 ]

The guest_hang() function is used as the default exception handler
for various KVM selftests applications by setting it's address in
the vstvec CSR. The vstvec CSR requires exception handler base address
to be at least 4-byte aligned so this patch fixes alignment of the
guest_hang() function.

Fixes: 3e06cdf10520 ("KVM: selftests: Add initial support for RISC-V
64-bit")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Tested-by: Mayuresh Chitale <mchitale@ventanamicro.com>
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/lib/riscv/processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index d377f2603d98..3961487a4870 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -268,7 +268,7 @@ void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
 		core.regs.t3, core.regs.t4, core.regs.t5, core.regs.t6);
 }
 
-static void guest_hang(void)
+static void __aligned(16) guest_hang(void)
 {
 	while (1)
 		;
-- 
2.35.1



