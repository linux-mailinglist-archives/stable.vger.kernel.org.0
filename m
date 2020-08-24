Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A777E2504CA
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 19:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgHXRHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 13:07:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727935AbgHXQiZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:38:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81DE52311B;
        Mon, 24 Aug 2020 16:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598287069;
        bh=xDG+pJ7fQ7DBgurPYXIhh1rMxem6hqnH68efCV1JqmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oWuZMkaoxnPrdClLllf/eFlGQGnQ/GycisAtdWalPuN4P3l8Lq4PqKgHvw4Sf1L+l
         /Z0QOJLTkGpbp6Sicl2BBMcnUOYerJhk13JbR7a3lnbCtlODm3NA1eMqmX9Wi+RmUo
         RwabVuJRMZMHhV1/+6cMV89gyywukB3gObPf9SRo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 54/54] arm64: Allow booting of late CPUs affected by erratum 1418040
Date:   Mon, 24 Aug 2020 12:36:33 -0400
Message-Id: <20200824163634.606093-54-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163634.606093-1-sashal@kernel.org>
References: <20200824163634.606093-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit bf87bb0881d0f59181fe3bbcf29c609f36483ff8 ]

As we can now switch from a system that isn't affected by 1418040
to a system that globally is affected, let's allow affected CPUs
to come in at a later time.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Tested-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20200731173824.107480-3-maz@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cpu_errata.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index f9387c1252325..5e1686ffae0e9 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -906,6 +906,8 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.desc = "ARM erratum 1418040",
 		.capability = ARM64_WORKAROUND_1418040,
 		ERRATA_MIDR_RANGE_LIST(erratum_1418040_list),
+		.type = (ARM64_CPUCAP_SCOPE_LOCAL_CPU |
+			 ARM64_CPUCAP_PERMITTED_FOR_LATE_CPU),
 	},
 #endif
 #ifdef CONFIG_ARM64_WORKAROUND_SPECULATIVE_AT_VHE
-- 
2.25.1

