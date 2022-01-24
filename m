Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64AB24999F2
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378174AbiAXViw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:38:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48810 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358050AbiAXV2a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:28:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C83A614CB;
        Mon, 24 Jan 2022 21:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F6FC340E4;
        Mon, 24 Jan 2022 21:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059707;
        bh=g46A/5qUCfI59y4i02SYj+GUKatopABI5zCyp83hnhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iPUp1UHDU6fjnaQGcG31JU1jfzms27x1NFpGMPkeuTeFKt7GNakGS5SHuOFWGvUDY
         0VOPKQgvdBLBg2gcLvVBWZJpkTmSkX3m9dzCbmSAUJ1DGkE3l3rfmWRrC1kAyPfD1t
         YaItYf+OEBQVXhwI7bKmWPAOBqdB8yBpxLXe+6lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jinzhou Su <Jinzhou.Su@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0707/1039] ACPI: CPPC: Check present CPUs for determining _CPC is valid
Date:   Mon, 24 Jan 2022 19:41:36 +0100
Message-Id: <20220124184149.100976704@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



