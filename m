Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9902608BA6
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 12:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiJVKbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 06:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiJVKbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 06:31:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772D62E00A7;
        Sat, 22 Oct 2022 02:47:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E4B2B82DF8;
        Sat, 22 Oct 2022 07:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95811C433D6;
        Sat, 22 Oct 2022 07:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425426;
        bh=r0iJe32ob/GSHTmdUuVBkNeqx/9YvNjYROZ+D4DgXUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SV9MakjAkT46H87yoXwgyrSHpLQ4n+HncD1PRp0hALX0Mn38tFXiCvMgowyfxiOiZ
         T6wnXRPq9c2Exn6kg4LXY8rBx/9srKBkpaPdCYO13ZwgexFpKggxgsfKUWPrAERgxZ
         ATOS1zBJ+nY5eBMNoJ+NZ1I/kCSOo/T6xpIuhKpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 498/717] cpuidle: riscv-sbi: Fix CPU_PM_CPU_IDLE_ENTER_xyz() macro usage
Date:   Sat, 22 Oct 2022 09:26:17 +0200
Message-Id: <20221022072520.297041515@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anup Patel <apatel@ventanamicro.com>

[ Upstream commit cfadbb9df8c4dc917787da4458327e5ec14743d4 ]

Currently, we are using CPU_PM_CPU_IDLE_ENTER_PARAM() for all SBI HSM
suspend types so retentive suspend types are also treated non-retentive
and kernel will do redundant additional work for these states.

The BIT[31] of SBI HSM suspend types allows us to differentiate between
retentive and non-retentive suspend types so we should use this BIT
to call appropriate CPU_PM_CPU_IDLE_ENTER_xyz() macro.

Fixes: 6abf32f1d9c5 ("cpuidle: Add RISC-V SBI CPU idle driver")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Link: https://lore.kernel.org/r/20220718084553.2056169-1-apatel@ventanamicro.com/
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/cpuidle-riscv-sbi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/cpuidle/cpuidle-riscv-sbi.c b/drivers/cpuidle/cpuidle-riscv-sbi.c
index 1151e5e2ba82..33c92fec4365 100644
--- a/drivers/cpuidle/cpuidle-riscv-sbi.c
+++ b/drivers/cpuidle/cpuidle-riscv-sbi.c
@@ -97,8 +97,13 @@ static int sbi_cpuidle_enter_state(struct cpuidle_device *dev,
 				   struct cpuidle_driver *drv, int idx)
 {
 	u32 *states = __this_cpu_read(sbi_cpuidle_data.states);
+	u32 state = states[idx];
 
-	return CPU_PM_CPU_IDLE_ENTER_PARAM(sbi_suspend, idx, states[idx]);
+	if (state & SBI_HSM_SUSP_NON_RET_BIT)
+		return CPU_PM_CPU_IDLE_ENTER_PARAM(sbi_suspend, idx, state);
+	else
+		return CPU_PM_CPU_IDLE_ENTER_RETENTION_PARAM(sbi_suspend,
+							     idx, state);
 }
 
 static int __sbi_enter_domain_idle_state(struct cpuidle_device *dev,
-- 
2.35.1



