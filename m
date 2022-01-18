Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D532549180E
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344241AbiARCoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:44:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48424 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345634AbiARCjO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:39:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2776AB81259;
        Tue, 18 Jan 2022 02:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E8FC36AE3;
        Tue, 18 Jan 2022 02:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473551;
        bh=nzPRbG+YEleZyM90F7lOhrrmw0dnK62nvAH2uKUNkoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WtAG9eRRzAs6njgj9BP65EOVqRupLznx1xtFd276nKhHWZ6L1TO90Orgs27roSSvj
         fDjcI3DwmdfwnlDSRYg/Zup0WhNSi7NlIn1UuyFGSa9Ts2RZY5CgMz5dTuh4j6Y9mA
         CvsE4wUQS6ls7EV2uHkjiLTOFHXFdOnwnocbvtQ0m91uhWeirU2kyyQId+e9Q2amzb
         pKwaOTJ3ks0Fdfu9Ud+ilUx4ZV+rf3UMlDe7v7x+33EvE7GGt51SLPhrq7jrD7bOos
         xt2ouuDWnWi5I176jJWmkHZxjROT1b0QOG9L0QRMcEr+vnEcrNG0ac58cY/JBo6M79
         ugTmDuu4Eyshg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Jinzhou Su <Jinzhou.Su@amd.com>, Huang Rui <ray.huang@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 163/188] ACPI: CPPC: Check present CPUs for determining _CPC is valid
Date:   Mon, 17 Jan 2022 21:31:27 -0500
Message-Id: <20220118023152.1948105-163-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 2aeca6bd02776d7f56a49a32be0dd184f204d888 ]

As this is a static check, it should be based upon what is currently
present on the system. This makes probeing more deterministic.

While local APIC flags field (lapic_flags) of cpu core in MADT table is
0, then the cpu core won't be enabled. In this case, _CPC won't be found
in this core, and return back to _CPC invalid with walking through
possible cpus (include disable cpus). This is not expected, so switch to
check present CPUs instead.

Reported-by: Jinzhou Su <Jinzhou.Su@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 3fbb17ecce2d5..6fe28a2d387bd 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -411,7 +411,7 @@ bool acpi_cpc_valid(void)
 	struct cpc_desc *cpc_ptr;
 	int cpu;
 
-	for_each_possible_cpu(cpu) {
+	for_each_present_cpu(cpu) {
 		cpc_ptr = per_cpu(cpc_desc_ptr, cpu);
 		if (!cpc_ptr)
 			return false;
-- 
2.34.1

