Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581573785BC
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbhEJLBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:01:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234600AbhEJK4l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9C936198A;
        Mon, 10 May 2021 10:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643633;
        bh=yG9grq+n316f7uqm/525+H1xUD6NZDUwXohc5xjtg3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0wAwANrTRLJ8cTWjeRh4JKuVX06yXGxAAFvJ9c0LXHi3O02WTqOTvQqrHLxA+LVmw
         Q71eICCtavz3R5a5kVhLoEKR7pDO0tWoueEvLfwoM3bTZTBCEdm4D+FvxgAdbwNodw
         i+D6Wuo/46rmvk8NPN1DqXUoqaLuDFwfUCEsgFYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 093/342] perf/arm_pmu_platform: Use dev_err_probe() for IRQ errors
Date:   Mon, 10 May 2021 12:18:03 +0200
Message-Id: <20210510102013.182576504@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 11fa1dc8020a2a9e0c59998920092d4df3fb7308 ]

By virtue of using platform_irq_get_optional() under the covers,
platform_irq_count() needs the target interrupt controller to be
available and may return -EPROBE_DEFER if it isn't. Let's use
dev_err_probe() to avoid a spurious error log (and help debug any
deferral issues) in that case.

Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/073d5e0d3ed1f040592cb47ca6fe3759f40cc7d1.1616774562.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_pmu_platform.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/perf/arm_pmu_platform.c b/drivers/perf/arm_pmu_platform.c
index 933bd8410fc2..bb6ae955083a 100644
--- a/drivers/perf/arm_pmu_platform.c
+++ b/drivers/perf/arm_pmu_platform.c
@@ -6,6 +6,7 @@
  * Copyright (C) 2010 ARM Ltd., Will Deacon <will.deacon@arm.com>
  */
 #define pr_fmt(fmt) "hw perfevents: " fmt
+#define dev_fmt pr_fmt
 
 #include <linux/bug.h>
 #include <linux/cpumask.h>
@@ -100,10 +101,8 @@ static int pmu_parse_irqs(struct arm_pmu *pmu)
 	struct pmu_hw_events __percpu *hw_events = pmu->hw_events;
 
 	num_irqs = platform_irq_count(pdev);
-	if (num_irqs < 0) {
-		pr_err("unable to count PMU IRQs\n");
-		return num_irqs;
-	}
+	if (num_irqs < 0)
+		return dev_err_probe(&pdev->dev, num_irqs, "unable to count PMU IRQs\n");
 
 	/*
 	 * In this case we have no idea which CPUs are covered by the PMU.
-- 
2.30.2



