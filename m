Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2932064E3
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388859AbgFWUPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:15:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388957AbgFWUP3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:15:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 930742064B;
        Tue, 23 Jun 2020 20:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943329;
        bh=Z4VOTIIyq5JB3bD3z7va4wE0DaTk44CmG0na4h0Esqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gOtoz1M7odIxyV6rVR1qdNO1vvVlvKAGe1u/L38n9ScjMBLrGh2h/x1jvDHEc5Wu0
         EsA7+32dE+q+PQbVnegl+EPyrgKCdTo7sZkafS10W4OW/TdU89wozzeqBDg4M1CW6T
         e8wX9Gchx4PHqHemAfUOAo7c1AP9vf3L5tRGPZgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 350/477] drivers/perf: hisi: Fix wrong value for all counters enable
Date:   Tue, 23 Jun 2020 21:55:47 +0200
Message-Id: <20200623195424.083390368@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
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
index 1151e99b241cb..479de4be99eba 100644
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



