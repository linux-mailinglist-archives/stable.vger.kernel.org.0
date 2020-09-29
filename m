Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEFDE27CD81
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgI2Moa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:44:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728983AbgI2LIZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:08:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B75C2395A;
        Tue, 29 Sep 2020 11:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377689;
        bh=z6WH/dxbI5lzFkCLiIYwfprIJLDsUsAMekmZzPTs7iQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5562mlnToLX7T7yHiULpcr2Gvw06bnNOCHOXrO0yXD+Hl1RyT6OS75ortH4JQhkt
         vn/UKnmjg07tJUSOuujxEvRJtwJGPhcTPDDghXmmP9iWIDkG3H53ZDQXICROG2iLMe
         iOFbkK7oAuFckcNPY9NhVXO3d7/Bk5fcwmzkoYLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 019/121] PM / devfreq: tegra30: Fix integer overflow on CPUs freq max out
Date:   Tue, 29 Sep 2020 12:59:23 +0200
Message-Id: <20200929105931.137368490@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 53b4b2aeee26f42cde5ff2a16dd0d8590c51a55a ]

There is another kHz-conversion bug in the code, resulting in integer
overflow. Although, this time the resulting value is 4294966296 and it's
close to ULONG_MAX, which is okay in this case.

Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
Tested-by: Peter Geis <pgwipeout@gmail.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/tegra-devfreq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/devfreq/tegra-devfreq.c b/drivers/devfreq/tegra-devfreq.c
index fe9dce0245bf0..a20267d93f8a4 100644
--- a/drivers/devfreq/tegra-devfreq.c
+++ b/drivers/devfreq/tegra-devfreq.c
@@ -79,6 +79,8 @@
 
 #define KHZ							1000
 
+#define KHZ_MAX						(ULONG_MAX / KHZ)
+
 /* Assume that the bus is saturated if the utilization is 25% */
 #define BUS_SATURATION_RATIO					25
 
@@ -179,7 +181,7 @@ struct tegra_actmon_emc_ratio {
 };
 
 static struct tegra_actmon_emc_ratio actmon_emc_ratios[] = {
-	{ 1400000, ULONG_MAX },
+	{ 1400000,    KHZ_MAX },
 	{ 1200000,    750000 },
 	{ 1100000,    600000 },
 	{ 1000000,    500000 },
-- 
2.25.1



