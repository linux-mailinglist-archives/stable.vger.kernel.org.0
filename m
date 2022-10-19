Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB26603F6C
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbiJSJbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233802AbiJSJ33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:29:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF1FE5ED7;
        Wed, 19 Oct 2022 02:12:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7C056185A;
        Wed, 19 Oct 2022 09:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0185CC433C1;
        Wed, 19 Oct 2022 09:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170322;
        bh=5I3kwVes2iD1BRUK93OgLmE9qSZLIgNDQvzyOR7UBEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H1rbBvtwOReNtTxoVO55E93J5g7Ifh1Fpc2JqHI22c4hEAbFdXxNNTlWTqzQgveHB
         KdMCGtGaT97ueLh934Iir/eMhZfh1SXVglUkhdAkTmNpr0M0GzcbNZJYwFhSrnzJnk
         MKsp8OTebeNOZb8aiLnhvQzIP8I86lU8SD9Y+LtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 612/862] cpuidle: riscv-sbi: Fix CPU_PM_CPU_IDLE_ENTER_xyz() macro usage
Date:   Wed, 19 Oct 2022 10:31:39 +0200
Message-Id: <20221019083316.963105291@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
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
index 862a2876f1c9..05fe2902df9a 100644
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



