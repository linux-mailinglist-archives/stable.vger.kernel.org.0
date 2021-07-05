Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C39F3BC03C
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbhGEPfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:35:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232001AbhGEPeF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:34:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 572B5619A4;
        Mon,  5 Jul 2021 15:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499061;
        bh=oDvovcN5l1PEO5RqqP7lJg2pmMSUw9WkKp0f59e4kTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F911+1+G6+tSwaE/GHNbAAnbbcMwty8XWR0plEm5Sf+RZzVtQJeZ4rwxbLeOKJqea
         sXTf9dxIIZTNGKT6LrHQD+IIRTmSY2BFPUpBmUIdkQBH/zc2Yh8HSkuXqwTBBK2uiq
         C4Kc4MRKJAaCbMlPJs3QsEMqxKkutByv9uWYKyT8RDoW6wspwdEbgKUHICK+bRjgCk
         HNBILS45whIBdFVia6REaRoX0Q6zwYIhj5n9ZMY548IePzsT2Z7SnaRoHAeDI9XalW
         o0sEQNxBnpKgqnVCCQOkZhZgT9uPuakWnS3oxSwCpY8hY+Bq01GhGcnVFNSvUeQku2
         K8Xo1h69LfH1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>, linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 17/26] EDAC/Intel: Do not load EDAC driver when running as a guest
Date:   Mon,  5 Jul 2021 11:30:30 -0400
Message-Id: <20210705153039.1521781-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153039.1521781-1-sashal@kernel.org>
References: <20210705153039.1521781-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Luck, Tony" <tony.luck@intel.com>

[ Upstream commit f0a029fff4a50eb01648810a77ba1873e829fdd4 ]

There's little to no point in loading an EDAC driver running in a guest:
1) The CPU model reported by CPUID may not represent actual h/w
2) The hypervisor likely does not pass in access to memory controller devices
3) Hypervisors generally do not pass corrected error details to guests

Add a check in each of the Intel EDAC drivers for X86_FEATURE_HYPERVISOR
and simply return -ENODEV in the init routine.

Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20210615174419.GA1087688@agluck-desk2.amr.corp.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i10nm_base.c | 3 +++
 drivers/edac/pnd2_edac.c  | 3 +++
 drivers/edac/sb_edac.c    | 3 +++
 drivers/edac/skx_base.c   | 3 +++
 4 files changed, 12 insertions(+)

diff --git a/drivers/edac/i10nm_base.c b/drivers/edac/i10nm_base.c
index dfcde7ed9500..f72be5f94e6f 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -249,6 +249,9 @@ static int __init i10nm_init(void)
 	if (owner && strncmp(owner, EDAC_MOD_STR, sizeof(EDAC_MOD_STR)))
 		return -EBUSY;
 
+	if (cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
+		return -ENODEV;
+
 	id = x86_match_cpu(i10nm_cpuids);
 	if (!id)
 		return -ENODEV;
diff --git a/drivers/edac/pnd2_edac.c b/drivers/edac/pnd2_edac.c
index dac45e2071b3..e054eb038903 100644
--- a/drivers/edac/pnd2_edac.c
+++ b/drivers/edac/pnd2_edac.c
@@ -1555,6 +1555,9 @@ static int __init pnd2_init(void)
 	if (owner && strncmp(owner, EDAC_MOD_STR, sizeof(EDAC_MOD_STR)))
 		return -EBUSY;
 
+	if (cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
+		return -ENODEV;
+
 	id = x86_match_cpu(pnd2_cpuids);
 	if (!id)
 		return -ENODEV;
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index b557a53c75c4..d39f5bfb8bd9 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -3512,6 +3512,9 @@ static int __init sbridge_init(void)
 	if (owner && strncmp(owner, EDAC_MOD_STR, sizeof(EDAC_MOD_STR)))
 		return -EBUSY;
 
+	if (cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
+		return -ENODEV;
+
 	id = x86_match_cpu(sbridge_cpuids);
 	if (!id)
 		return -ENODEV;
diff --git a/drivers/edac/skx_base.c b/drivers/edac/skx_base.c
index 77cd370bd62f..b1d717cb8df9 100644
--- a/drivers/edac/skx_base.c
+++ b/drivers/edac/skx_base.c
@@ -605,6 +605,9 @@ static int __init skx_init(void)
 	if (owner && strncmp(owner, EDAC_MOD_STR, sizeof(EDAC_MOD_STR)))
 		return -EBUSY;
 
+	if (cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
+		return -ENODEV;
+
 	id = x86_match_cpu(skx_cpuids);
 	if (!id)
 		return -ENODEV;
-- 
2.30.2

