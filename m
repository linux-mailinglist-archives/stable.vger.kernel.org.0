Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C7C2477A8
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732841AbgHQTve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:51:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729118AbgHQPSc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:18:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A17D8205CB;
        Mon, 17 Aug 2020 15:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677512;
        bh=3SszuFnMRkh91EddoT1fiCaR7YvhFDLhQ6A0QGRX8Ro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F7oJ4i/9DwcAAKyAJofquyi/Y9gOz2qphMVUZp3UkuMlXlJDqGoz7mEJN+Bf2+jyL
         u8dIMzdIzRrOFYQBGtZOKz6Tz8x3tyqCR7qgbN++1W0NLeWVDhp8UVzaxKmJpKC75X
         2CDQwfgb7kZr84jPWl4Urcd6tHGBZXHAJUoPHhoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Giovanni Gherdovich <ggherdovich@suse.cz>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 010/464] x86, sched: Bail out of frequency invariance if turbo frequency is unknown
Date:   Mon, 17 Aug 2020 17:09:23 +0200
Message-Id: <20200817143834.247565223@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 18d292fc466cb..20e1cea262e4b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -2002,9 +2002,11 @@ static bool intel_set_max_freq_ratio(void)
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



