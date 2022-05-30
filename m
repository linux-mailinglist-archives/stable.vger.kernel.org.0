Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365DE537F2E
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239915AbiE3OKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238898AbiE3OEy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:04:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB60D994E6;
        Mon, 30 May 2022 06:40:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47B5F60F14;
        Mon, 30 May 2022 13:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABD3C385B8;
        Mon, 30 May 2022 13:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918054;
        bh=BGfVVxAsAf78mYgg00a1N32o3qU1TBRZu6X1C354dqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gF2Y1XsKjxjbFpszVpDZ2554HDP8It0/e+hlOp7bUSeri7gt16W/i8wrusHIZWCsk
         YsLPOvoKdRjpUV5YyVOutlrmpU0xw0+FLk9wksOSGQxsb1B1DBkAZioYWZYkPhgAP2
         D7Pl0Mi3VrQovp9RFd4ZDWcpNeonFChoEzdQye/DrEmglZBGNlLYG6lnDrL9zjRcIB
         kecJIDxS8RvNwoRO9Guv9ZAELqybN7HpKZtobNbjwWOwFHKufzkakTOjdTOtZiN/Jl
         oHk0LtkeRp8BhEc4vke+S4u/CARXwUNiFnRyvWPVaaIdCmlEHPTsWz2sS1fLJzurYP
         kHEvS0Xtqn/Gw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>, will@kernel.org,
        maz@kernel.org, suzuki.poulose@arm.com, vladimir.murzin@arm.com,
        james.morse@arm.com, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 044/109] arm64/sme: Add ID_AA64SMFR0_EL1 to __read_sysreg_by_encoding()
Date:   Mon, 30 May 2022 09:37:20 -0400
Message-Id: <20220530133825.1933431-44-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
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
index e71c9cfb46e8..ca417167675a 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1281,6 +1281,7 @@ u64 __read_sysreg_by_encoding(u32 sys_id)
 	read_sysreg_case(SYS_ID_AA64PFR0_EL1);
 	read_sysreg_case(SYS_ID_AA64PFR1_EL1);
 	read_sysreg_case(SYS_ID_AA64ZFR0_EL1);
+	read_sysreg_case(SYS_ID_AA64SMFR0_EL1);
 	read_sysreg_case(SYS_ID_AA64DFR0_EL1);
 	read_sysreg_case(SYS_ID_AA64DFR1_EL1);
 	read_sysreg_case(SYS_ID_AA64MMFR0_EL1);
-- 
2.35.1

