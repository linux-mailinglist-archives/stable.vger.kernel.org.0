Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC40A23FB45
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgHHXsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:48:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727981AbgHHXha (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:37:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 262AD2073E;
        Sat,  8 Aug 2020 23:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929849;
        bh=ZP78nRBu0zFa6HikHbRlcMnRoQrOzDOzp1XtjT6hGhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PMQTR8HaRIvFGgrgrjGJn6oDDjoXU6ZOy1P9wquXdHuT5uu7BmNPW87p7OJ8AB7X2
         0ryluCDF25quubk5oxweZ3xZDmYxantkQ1ITxOOXo3ZyPcXR89ZNa+5jOJf6PViHUD
         9uADV2TrWc5iRh8OI69rEuYClAfazgf5xeeuDD58=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Giovanni Gherdovich <ggherdovich@suse.cz>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.7 04/58] x86, sched: Bail out of frequency invariance if turbo frequency is unknown
Date:   Sat,  8 Aug 2020 19:36:30 -0400
Message-Id: <20200808233724.3618168-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233724.3618168-1-sashal@kernel.org>
References: <20200808233724.3618168-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giovanni Gherdovich <ggherdovich@suse.cz>

[ Upstream commit 51beea8862a3095559862df39554f05042e1195b ]

There may be CPUs that support turbo boost but don't declare any turbo
ratio, i.e. their MSR_TURBO_RATIO_LIMIT is all zeroes. In that condition
scale-invariant calculations can't be performed.

Fixes: 1567c3e3467c ("x86, sched: Add support for frequency invariance")
Suggested-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Signed-off-by: Giovanni Gherdovich <ggherdovich@suse.cz>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Link: https://lkml.kernel.org/r/20200531182453.15254-3-ggherdovich@suse.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/smpboot.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 2f24c334a938b..3917a2de1580c 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1999,9 +1999,11 @@ static bool intel_set_max_freq_ratio(void)
 	/*
 	 * Some hypervisors advertise X86_FEATURE_APERFMPERF
 	 * but then fill all MSR's with zeroes.
+	 * Some CPUs have turbo boost but don't declare any turbo ratio
+	 * in MSR_TURBO_RATIO_LIMIT.
 	 */
-	if (!base_freq) {
-		pr_debug("Couldn't determine cpu base frequency, necessary for scale-invariant accounting.\n");
+	if (!base_freq || !turbo_freq) {
+		pr_debug("Couldn't determine cpu base or turbo frequency, necessary for scale-invariant accounting.\n");
 		return false;
 	}
 
-- 
2.25.1

