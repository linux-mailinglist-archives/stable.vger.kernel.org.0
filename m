Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E7C41A7C1
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239204AbhI1F7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:59:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239170AbhI1F6i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:58:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DD2B61352;
        Tue, 28 Sep 2021 05:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808593;
        bh=9tzfcVt12E3AJYpIaInQ2Tfai7WKL1gsFLA5d12jAmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PE4gipqDEtu9QqPy4t/zJKFD8uxyBquiFLI19bYrzQaBoqbZG3NmOD/V4X++JEYzc
         AqhouiL8SGHKHobSmi/gDgjYxRp434euSQQCZMOSG8padygIwW7aEBXg32FRAk6ikR
         fI8KcybKjtiwNgayEiViTkLBXdAbJEI6vh4Q7hOC1GOxn19VHkVMVwsfJOlqJB4cTN
         094g7JbiLwEW2yrGgqKqgU19bGNhczO6dbKbR7ig08JSdMUTB3/scrDaFVRaSLZqgB
         K9BPdW8Vx7U16jUcxG7xU4sJ9DKHSgvl8iIOWxAYDZuuiox3mY0kd0DGWtR1Kgwcfq
         RTL0uwRK6TTIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        bjorn.andersson@linaro.org, amitk@kernel.org,
        thara.gopinath@linaro.org, rui.zhang@intel.com,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 32/40] thermal/drivers/tsens: Fix wrong check for tzd in irq handlers
Date:   Tue, 28 Sep 2021 01:55:16 -0400
Message-Id: <20210928055524.172051-32-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ansuel Smith <ansuelsmth@gmail.com>

[ Upstream commit cf96921876dcee4d6ac07b9de470368a075ba9ad ]

Some devices can have some thermal sensors disabled from the
factory. The current two irq handler functions check all the sensor by
default and the check if the sensor was actually registered is
wrong. The tzd is actually never set if the registration fails hence
the IS_ERR check is wrong.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210907212543.20220-1-ansuelsmth@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/tsens.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/qcom/tsens.c b/drivers/thermal/qcom/tsens.c
index 4c7ebd1d3f9c..b1162e566a70 100644
--- a/drivers/thermal/qcom/tsens.c
+++ b/drivers/thermal/qcom/tsens.c
@@ -417,7 +417,7 @@ static irqreturn_t tsens_critical_irq_thread(int irq, void *data)
 		const struct tsens_sensor *s = &priv->sensor[i];
 		u32 hw_id = s->hw_id;
 
-		if (IS_ERR(s->tzd))
+		if (!s->tzd)
 			continue;
 		if (!tsens_threshold_violated(priv, hw_id, &d))
 			continue;
@@ -467,7 +467,7 @@ static irqreturn_t tsens_irq_thread(int irq, void *data)
 		const struct tsens_sensor *s = &priv->sensor[i];
 		u32 hw_id = s->hw_id;
 
-		if (IS_ERR(s->tzd))
+		if (!s->tzd)
 			continue;
 		if (!tsens_threshold_violated(priv, hw_id, &d))
 			continue;
-- 
2.33.0

