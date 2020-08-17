Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075FA247482
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390195AbgHQTKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:10:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730753AbgHQPlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:41:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05C382075B;
        Mon, 17 Aug 2020 15:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678895;
        bh=ZP78nRBu0zFa6HikHbRlcMnRoQrOzDOzp1XtjT6hGhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fcoACj3KE218q7U1qc7Kf26gmoJsv+5oGQWbNxbQLR9EagWGfGhbuErCLwvUPJwxZ
         EwZWCXk4BTC64o7cRJTIiRNvzJM223DA+p2SrT0eUvyTKjk9H+4iT/1xVrjB0ZgQYM
         yU87yxjEiysgRvLrammdIX91H33AYA+wBILqGi+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Giovanni Gherdovich <ggherdovich@suse.cz>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 008/393] x86, sched: Bail out of frequency invariance if turbo frequency is unknown
Date:   Mon, 17 Aug 2020 17:10:58 +0200
Message-Id: <20200817143819.989905377@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
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



