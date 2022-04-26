Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B09750F8F9
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346116AbiDZJGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347259AbiDZJFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:05:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB5910771F;
        Tue, 26 Apr 2022 01:44:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D4F560A56;
        Tue, 26 Apr 2022 08:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A84AC385A4;
        Tue, 26 Apr 2022 08:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962660;
        bh=ac3HYVGc0CjlMIGOg7yoMrHUVzc5WDX2OrhG5mg8J5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZK2KR/goc4OVnlT/GsKigYus0RVWbXWC2Gb9ZMAGVD0qS/j0K1WHuJiloI7V+QS3
         AmRx0IOlhsqknRMIZg/vWZtz164IJb8T45GYMYqDcc76Um2GTev3zEabnZMR7rhVip
         YuL4Zo4cFo9+vICsTuhFR/EugJ5yjMWAFf4XMT8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 045/146] RISC-V: KVM: Remove s & u as valid ISA extension
Date:   Tue, 26 Apr 2022 10:20:40 +0200
Message-Id: <20220426081751.336985407@linuxfoundation.org>
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

[ Upstream commit 3ab75a793e4939519d288ef1994db73b8e2d1d86 ]

There are no ISA extension defined as 's' & 'u' in RISC-V specifications.
The misa register defines 's' & 'u' bit as Supervisor/User privilege mode
enabled. But it should not appear in the ISA extension in the device tree.

Remove those from the allowed ISA extension for kvm.

Fixes: a33c72faf2d7 ("RISC-V: KVM: Implement VCPU create, init and
destroy functions")
Signed-off-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 6785aef4cbd4..2e25a7b83a1b 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -43,9 +43,7 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
 				 riscv_isa_extension_mask(d) | \
 				 riscv_isa_extension_mask(f) | \
 				 riscv_isa_extension_mask(i) | \
-				 riscv_isa_extension_mask(m) | \
-				 riscv_isa_extension_mask(s) | \
-				 riscv_isa_extension_mask(u))
+				 riscv_isa_extension_mask(m))
 
 static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 {
-- 
2.35.1



