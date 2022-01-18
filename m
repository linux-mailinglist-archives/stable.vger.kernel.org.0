Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB26149179A
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346163AbiARCmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:42:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345575AbiARCbn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:31:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070A1C0612DF;
        Mon, 17 Jan 2022 18:29:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE578B8125A;
        Tue, 18 Jan 2022 02:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C062C36AF3;
        Tue, 18 Jan 2022 02:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472983;
        bh=g46A/5qUCfI59y4i02SYj+GUKatopABI5zCyp83hnhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YE+cJ6/5CDUYG4o61pP8WvSkt4zkzwd/SbvqmWdheIZsF2Sa+4LxJjDIef0cTCBuK
         g82bp6qyrz2WPKJh4NwJR11L9gcE/BL+2hZH1MzuZMMra1tbjPgvscJPbemxY+f4Fa
         mNdZU0yFQMi8Jx6XBVl8uLdvuFNA81eld/DOz9lFBAtC3pWTT31bqlEmYE8El/UvKj
         Yz1uTdcRG1nNtD9/7yFsTqPMBPApGLBHggBnvYsy3cptNL9RYnltq4B/fRHw9jx0gm
         UICzLADprn2mHUIcb3i4HlKPF5o6KEIZDgtOPMYFgdC0Uvrt5OVXiD2g5VOIzf7of5
         Mt/3BavCTw2zg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Jinzhou Su <Jinzhou.Su@amd.com>, Huang Rui <ray.huang@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 190/217] ACPI: CPPC: Check present CPUs for determining _CPC is valid
Date:   Mon, 17 Jan 2022 21:19:13 -0500
Message-Id: <20220118021940.1942199-190-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index b62c87b8ce4a9..12a156d8283e6 100644
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

