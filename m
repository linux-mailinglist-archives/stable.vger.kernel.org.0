Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6ECA1FE604
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgFRBPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:15:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729519AbgFRBPt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:15:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18A2E221EB;
        Thu, 18 Jun 2020 01:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442948;
        bh=R2PNha6qCcoAHK74FUO8nj9Oo5Z9Vc/67a0l8/WO8Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IgPC/KZKjVM7yXiLxJUijrO38AOpiWjgPzlBwv22t+6nBF1C7AvtX30wC6/GXLQBX
         vwCy9OoM5elz7vWyGxRTay0tOoL5sw/HzUys7mC4I4hKALBcJQfIzOb9OezNgMNnbm
         SqJCgsCIzKYSUPl9cIM54tmpd+6C9IPy9ya09/xc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.7 358/388] drivers/perf: hisi: Fix wrong value for all counters enable
Date:   Wed, 17 Jun 2020 21:07:35 -0400
Message-Id: <20200618010805.600873-358-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 1151e99b241c..479de4be99eb 100644
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

