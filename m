Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C8141A815
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239709AbhI1GBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 02:01:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239415AbhI1F7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:59:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C16766127A;
        Tue, 28 Sep 2021 05:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808619;
        bh=Hv6zhBgHG460Lq2ZwpA4zetkrNeCBkz0ebL3kw8dHp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PgrxY7k3UanllSA3fu353MrXCk+JSbR6DnkvgJtpvRapN9oXMiOZB9R+gUwXIoBnT
         MOe89h1oMA9fOoUv2fWydVyuooF1I7wp6NjHtuooMeHEF9RspVze0Bo55DY3Nthnvk
         I/UxFe4H6SVklumcSNR1dV/06WW7qesjXWobbEpwGHXUukl2WlzQLTliCco/Hbd7Ji
         sIMTXPy3NiUq0Z5aNnxrzLNtfurOF/pFvKzinMGKMAOUovCPgfSWmdZZoPoLSOzqLq
         /INStys1S0PmHu3C/IAt5n10XxqQvKbO3ZeTi355vRxIPSWh4fnnFRhPWrNqccRzDg
         tFV/w4Hoq6BXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        bjorn.andersson@linaro.org, amitk@kernel.org,
        thara.gopinath@linaro.org, rui.zhang@intel.com,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 19/23] thermal/drivers/tsens: Fix wrong check for tzd in irq handlers
Date:   Tue, 28 Sep 2021 01:56:40 -0400
Message-Id: <20210928055645.172544-19-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055645.172544-1-sashal@kernel.org>
References: <20210928055645.172544-1-sashal@kernel.org>
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
index 3c4c0516e58a..cb4f4b522446 100644
--- a/drivers/thermal/qcom/tsens.c
+++ b/drivers/thermal/qcom/tsens.c
@@ -415,7 +415,7 @@ static irqreturn_t tsens_critical_irq_thread(int irq, void *data)
 		const struct tsens_sensor *s = &priv->sensor[i];
 		u32 hw_id = s->hw_id;
 
-		if (IS_ERR(s->tzd))
+		if (!s->tzd)
 			continue;
 		if (!tsens_threshold_violated(priv, hw_id, &d))
 			continue;
@@ -465,7 +465,7 @@ static irqreturn_t tsens_irq_thread(int irq, void *data)
 		const struct tsens_sensor *s = &priv->sensor[i];
 		u32 hw_id = s->hw_id;
 
-		if (IS_ERR(s->tzd))
+		if (!s->tzd)
 			continue;
 		if (!tsens_threshold_violated(priv, hw_id, &d))
 			continue;
-- 
2.33.0

