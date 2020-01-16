Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 375B813F1D1
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391913AbgAPRZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:25:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:32888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391675AbgAPRZT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:25:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0110246CA;
        Thu, 16 Jan 2020 17:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195518;
        bh=q1PD+9BrGNCyY77bHX9F2/vlz59WAA3Rrgfxbt/G5iU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t5GB6zd57yhLkK/8ltUCpGOglxz6xjCH11cNprSCGXW5WlUphoHAVJBjGbcxrDgcf
         e/l58Jc10fI/xFiCQV8XGqDnDvME6Qcmum3VjCZu1lJBeYShmH3ZWSufK0kOD5EilK
         PhiCPhEVdssevd4SqrYTE7kGqrM2u6t0t7G2gDaI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Andrew Donnellan <andrew.donnellan@au1.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 116/371] powerpc/64s: Fix logic when handling unknown CPU features
Date:   Thu, 16 Jan 2020 12:19:48 -0500
Message-Id: <20200116172403.18149-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 8cfaf106918a8c13abb24c641556172afbb9545c ]

In cpufeatures_process_feature(), if a provided CPU feature is unknown and
enable_unknown is false, we erroneously print that the feature is being
enabled and return true, even though no feature has been enabled, and
may also set feature bits based on the last entry in the match table.

Fix this so that we only set feature bits from the match table if we have
actually enabled a feature from that table, and when failing to enable an
unknown feature, always print the "not enabling" message and return false.

Coincidentally, some older gccs (<GCC 7), when invoked with
-fsanitize-coverage=trace-pc, cause a spurious uninitialised variable
warning in this function:

  arch/powerpc/kernel/dt_cpu_ftrs.c: In function ‘cpufeatures_process_feature’:
  arch/powerpc/kernel/dt_cpu_ftrs.c:686:7: warning: ‘m’ may be used uninitialized in this function [-Wmaybe-uninitialized]
    if (m->cpu_ftr_bit_mask)

An upcoming patch will enable support for kcov, which requires this option.
This patch avoids the warning.

Fixes: 5a61ef74f269 ("powerpc/64s: Support new device tree binding for discovering CPU features")
Reported-by: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
[ajd: add commit message]
Signed-off-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/dt_cpu_ftrs.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kernel/dt_cpu_ftrs.c b/arch/powerpc/kernel/dt_cpu_ftrs.c
index 2357df60de95..7ed2b1b6643c 100644
--- a/arch/powerpc/kernel/dt_cpu_ftrs.c
+++ b/arch/powerpc/kernel/dt_cpu_ftrs.c
@@ -705,8 +705,10 @@ static bool __init cpufeatures_process_feature(struct dt_cpu_feature *f)
 		m = &dt_cpu_feature_match_table[i];
 		if (!strcmp(f->name, m->name)) {
 			known = true;
-			if (m->enable(f))
+			if (m->enable(f)) {
+				cur_cpu_spec->cpu_features |= m->cpu_ftr_bit_mask;
 				break;
+			}
 
 			pr_info("not enabling: %s (disabled or unsupported by kernel)\n",
 				f->name);
@@ -714,17 +716,12 @@ static bool __init cpufeatures_process_feature(struct dt_cpu_feature *f)
 		}
 	}
 
-	if (!known && enable_unknown) {
-		if (!feat_try_enable_unknown(f)) {
-			pr_info("not enabling: %s (unknown and unsupported by kernel)\n",
-				f->name);
-			return false;
-		}
+	if (!known && (!enable_unknown || !feat_try_enable_unknown(f))) {
+		pr_info("not enabling: %s (unknown and unsupported by kernel)\n",
+			f->name);
+		return false;
 	}
 
-	if (m->cpu_ftr_bit_mask)
-		cur_cpu_spec->cpu_features |= m->cpu_ftr_bit_mask;
-
 	if (known)
 		pr_debug("enabling: %s\n", f->name);
 	else
-- 
2.20.1

