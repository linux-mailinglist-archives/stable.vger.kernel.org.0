Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F79026F477
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgIRDOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgIRCBo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:01:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B79A1235FA;
        Fri, 18 Sep 2020 02:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394503;
        bh=olcSovhd3mqxcStuyRQwJpR7Kpxz7YoVX9eWDOiAVEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GcnlEkM9DpS3aOEsWMtitzrrdI6LnJVjEZ62LzECo7UGaW21gPspj7tKkFKBjJFLp
         CwsbihE6feT12eXerKTnUKI915QnYq7NIcsy+7tjSOZj2afnTa+dR1h9+0LSmOo08b
         G7SXprcM3Tvmlwm0xoyVY7a6N7LSUVTzBqIhe69c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 027/330] PM / devfreq: tegra30: Fix integer overflow on CPU's freq max out
Date:   Thu, 17 Sep 2020 21:56:07 -0400
Message-Id: <20200918020110.2063155-27-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/devfreq/tegra30-devfreq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/devfreq/tegra30-devfreq.c b/drivers/devfreq/tegra30-devfreq.c
index a6ba75f4106d8..e273011c83fbd 100644
--- a/drivers/devfreq/tegra30-devfreq.c
+++ b/drivers/devfreq/tegra30-devfreq.c
@@ -68,6 +68,8 @@
 
 #define KHZ							1000
 
+#define KHZ_MAX						(ULONG_MAX / KHZ)
+
 /* Assume that the bus is saturated if the utilization is 25% */
 #define BUS_SATURATION_RATIO					25
 
@@ -169,7 +171,7 @@ struct tegra_actmon_emc_ratio {
 };
 
 static struct tegra_actmon_emc_ratio actmon_emc_ratios[] = {
-	{ 1400000, ULONG_MAX },
+	{ 1400000,    KHZ_MAX },
 	{ 1200000,    750000 },
 	{ 1100000,    600000 },
 	{ 1000000,    500000 },
-- 
2.25.1

