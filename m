Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCF811AF8C
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731393AbfLKPNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:13:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:37752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731495AbfLKPNp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 688E22467D;
        Wed, 11 Dec 2019 15:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077224;
        bh=+yk9mYXVKl5XA7S+vRIKSBQqHBlADY3o4I5YiwvkXdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dvuPtkVWSpiUGCUuqIkb6OUYW3JkfIjaYXba7qxyBoTuhd1jtkTUS3pRjLBgYII9Z
         F51jTOhwllDLTFjWXdO+AoXxsITjlacpjqQOxRkmUAttYRiEmgaNVh4oLqAVys1R54
         0f6iDPfLfslMoBMUbHJ+PeXVbwq2Vvzkao9g6ohQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gayatri Kammela <gayatri.kammela@intel.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kan Liang <kan.liang@intel.com>,
        "David E . Box" <david.e.box@intel.com>,
        Rajneesh Bhardwaj <rajneesh.bhardwaj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 103/134] platform/x86: intel_pmc_core: Add Comet Lake (CML) platform support to intel_pmc_core driver
Date:   Wed, 11 Dec 2019 10:11:19 -0500
Message-Id: <20191211151150.19073-103-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gayatri Kammela <gayatri.kammela@intel.com>

[ Upstream commit 5406327d43edd9a171bd260f49c752d148727eaf ]

Add Comet Lake to the list of the platforms that intel_pmc_core driver
supports for pmc_core device.

Just like Ice Lake, Comet Lake can also reuse all the Cannon Lake PCH
IPs. No additional effort is needed to enable but to simply reuse them.

Cc: Mario Limonciello <mario.limonciello@dell.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Kan Liang <kan.liang@intel.com>
Cc: David E. Box <david.e.box@intel.com>
Cc: Rajneesh Bhardwaj <rajneesh.bhardwaj@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Gayatri Kammela <gayatri.kammela@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_pmc_core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel_pmc_core.c b/drivers/platform/x86/intel_pmc_core.c
index 6b6edc30f8359..571b4754477c5 100644
--- a/drivers/platform/x86/intel_pmc_core.c
+++ b/drivers/platform/x86/intel_pmc_core.c
@@ -160,6 +160,7 @@ static const struct pmc_reg_map spt_reg_map = {
 
 /* Cannon Lake: PGD PFET Enable Ack Status Register(s) bitmap */
 static const struct pmc_bit_map cnp_pfear_map[] = {
+	/* Reserved for Cannon Lake but valid for Comet Lake */
 	{"PMC",                 BIT(0)},
 	{"OPI-DMI",             BIT(1)},
 	{"SPI/eSPI",            BIT(2)},
@@ -185,7 +186,7 @@ static const struct pmc_bit_map cnp_pfear_map[] = {
 	{"SDX",                 BIT(4)},
 	{"SPE",                 BIT(5)},
 	{"Fuse",                BIT(6)},
-	/* Reserved for Cannon Lake but valid for Ice Lake */
+	/* Reserved for Cannon Lake but valid for Ice Lake and Comet Lake */
 	{"SBR8",		BIT(7)},
 
 	{"CSME_FSC",            BIT(0)},
@@ -229,7 +230,7 @@ static const struct pmc_bit_map cnp_pfear_map[] = {
 	{"HDA_PGD4",            BIT(2)},
 	{"HDA_PGD5",            BIT(3)},
 	{"HDA_PGD6",            BIT(4)},
-	/* Reserved for Cannon Lake but valid for Ice Lake */
+	/* Reserved for Cannon Lake but valid for Ice Lake and Comet Lake */
 	{"PSF6",		BIT(5)},
 	{"PSF7",		BIT(6)},
 	{"PSF8",		BIT(7)},
@@ -813,6 +814,8 @@ static const struct x86_cpu_id intel_pmc_core_ids[] = {
 	INTEL_CPU_FAM6(CANNONLAKE_L, cnp_reg_map),
 	INTEL_CPU_FAM6(ICELAKE_L, icl_reg_map),
 	INTEL_CPU_FAM6(ICELAKE_NNPI, icl_reg_map),
+	INTEL_CPU_FAM6(COMETLAKE, cnp_reg_map),
+	INTEL_CPU_FAM6(COMETLAKE_L, cnp_reg_map),
 	{}
 };
 
-- 
2.20.1

