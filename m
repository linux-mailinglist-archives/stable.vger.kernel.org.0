Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA902597EB
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731975AbgIAQUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:20:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728009AbgIAPcr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:32:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E1C120866;
        Tue,  1 Sep 2020 15:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974366;
        bh=mHJBKvhnUJ/S+3nxeAcbt10YL0vWVfmMtJO8E7cMELs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wNmK28yFIAbcIOiNRSboQBJhjWX7LRLT9PrmesQhYDE4WwJ24oF+gr/sGjyNG9zdR
         zsQ2QMlBpp6ZA5+gVFKOS8sUWsuIEsN2MoLO/hXSVuRwLy4mFDnQJR+jr7QtNgOfHH
         Tjiz1vmHfDRtcO0l9wCW0qTPpT2saeLalMb2bCW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 148/214] arm64: Allow booting of late CPUs affected by erratum 1418040
Date:   Tue,  1 Sep 2020 17:10:28 +0200
Message-Id: <20200901151000.062847132@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 0b2830379fe03..51462c59ab5da 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -917,6 +917,8 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.desc = "ARM erratum 1418040",
 		.capability = ARM64_WORKAROUND_1418040,
 		ERRATA_MIDR_RANGE_LIST(erratum_1418040_list),
+		.type = (ARM64_CPUCAP_SCOPE_LOCAL_CPU |
+			 ARM64_CPUCAP_PERMITTED_FOR_LATE_CPU),
 	},
 #endif
 #ifdef CONFIG_ARM64_ERRATUM_1165522
-- 
2.25.1



