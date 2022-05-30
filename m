Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD442537C42
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237039AbiE3NbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237309AbiE3NaU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:30:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DE88B0BC;
        Mon, 30 May 2022 06:27:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6F9BB80D84;
        Mon, 30 May 2022 13:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A9FC3411A;
        Mon, 30 May 2022 13:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917227;
        bh=8RMiVVctj3sV0L6ZoUUur3BAGcCQ+VEqyIgyBivg9YM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/DG/UZgDYlYks7dEwKqDo91ZK/dr2ImlOqmtFiwDe0Q/bBksZzTgcJXhWCdq0os5
         m4iACe6lC8T4B2NKNFVcszbVz42WLAf60dQ8jl0G0XTnHx+B9EWEG9v7dLcg1zaRNM
         eLWfI1SaupRdG09wW24E/XfYtk4MCYn5lGixO7TRCCnRldfa4JbCy8Y8WWQrEA825m
         ay8qrQHNAMbfWtd5QkDOEiM2ZrRwk2sZMxpHSgFgVPxUHfSaRYmWcqW1C1bD+9Otys
         MyFoC1DoC2/6lkdN2XlBlFuhZR9zmZf/AvAmrmEBY0cZ96kyauLaIPHRnIwbgDZNfQ
         ep1wM/QTcoELw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>, will@kernel.org,
        maz@kernel.org, mark.rutland@arm.com, vladimir.murzin@arm.com,
        joey.gouly@arm.com, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 063/159] arm64/sme: Add ID_AA64SMFR0_EL1 to __read_sysreg_by_encoding()
Date:   Mon, 30 May 2022 09:22:48 -0400
Message-Id: <20220530132425.1929512-63-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 8a58bcd00e2e8d46afce468adc09fcd7968f514c ]

We need to explicitly enumerate all the ID registers which we rely on
for CPU capabilities in __read_sysreg_by_encoding(), ID_AA64SMFR0_EL1 was
missed from this list so we trip a BUG() in paths which rely on that
function such as CPU hotplug. Add the register.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20220427130828.162615-1-broonie@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 2cb9cc9e0eff..0182da409ec9 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1287,6 +1287,7 @@ u64 __read_sysreg_by_encoding(u32 sys_id)
 	read_sysreg_case(SYS_ID_AA64PFR0_EL1);
 	read_sysreg_case(SYS_ID_AA64PFR1_EL1);
 	read_sysreg_case(SYS_ID_AA64ZFR0_EL1);
+	read_sysreg_case(SYS_ID_AA64SMFR0_EL1);
 	read_sysreg_case(SYS_ID_AA64DFR0_EL1);
 	read_sysreg_case(SYS_ID_AA64DFR1_EL1);
 	read_sysreg_case(SYS_ID_AA64MMFR0_EL1);
-- 
2.35.1

