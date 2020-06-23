Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2822063E4
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387840AbgFWVMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:12:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391193AbgFWUbJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:31:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B524D20702;
        Tue, 23 Jun 2020 20:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944269;
        bh=2r7uTYuQVHNV87dOGG+pMpiOz1mjBgWFbqNJKi/EFeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UcaGhclBBerpPcgQYXyD3gmMACE6wK5hcw2aJE637R/FBTfp+jKsJTH9GdV/hURB6
         1J/ALnNqU41vQcmDbzCxi+tn6gw1F7k8vbK+dqs8YCMqNlSKTArFbDe7VdVXLtFTFc
         5dV8IHMN5U97mq4gh733L30tE5vrhBbGNnRFPtu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 239/314] drivers/perf: hisi: Fix wrong value for all counters enable
Date:   Tue, 23 Jun 2020 21:57:14 +0200
Message-Id: <20200623195350.356456258@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shaokun Zhang <zhangshaokun@hisilicon.com>

[ Upstream commit 961abd78adcb4c72c343fcd9f9dc5e2ebbe9b448 ]

In L3C uncore PMU drivers, bit16 is used to control all counters enable &
disable. Wrong value is given in the driver and its default value is 1'b1,
it can work because each PMU counter has its own control bits too.
Let's fix the wrong value.

Fixes: 2940bc433370 ("perf: hisi: Add support for HiSilicon SoC L3C PMU driver")
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/1591350221-32275-1-git-send-email-zhangshaokun@hisilicon.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c b/drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c
index 078b8dc572503..c5b0950c2a7a9 100644
--- a/drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c
+++ b/drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c
@@ -35,7 +35,7 @@
 /* L3C has 8-counters */
 #define L3C_NR_COUNTERS		0x8
 
-#define L3C_PERF_CTRL_EN	0x20000
+#define L3C_PERF_CTRL_EN	0x10000
 #define L3C_EVTYPE_NONE		0xff
 
 /*
-- 
2.25.1



