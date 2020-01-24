Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE24147C72
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388116AbgAXJwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:52:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388109AbgAXJwE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:52:04 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6923221556;
        Fri, 24 Jan 2020 09:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859524;
        bh=n/1j+psUlXSEutQ8JlTkMgKXO4dx2uETUlwwgpaLJmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BiLNpVVoQFfHZh/zZXylEGqBTyx3lDmAqdMW06TZQtcp3etsjCrW4sWmcjGbCJjpU
         tkzCLL2ufDVw9LZb+2zjWxfRFUjAZ/z8hdPmD/+U6YFGErOUe5OBFPxNKIiUBzUAhE
         UnUZrXUUvMyXVuylz7uFmp/gC4vON310cHbrPHhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Donnellan <andrew.donnellan@au1.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 123/343] powerpc/64s: Fix logic when handling unknown CPU features
Date:   Fri, 24 Jan 2020 10:29:01 +0100
Message-Id: <20200124092936.177470361@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2357df60de952..7ed2b1b6643cc 100644
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



