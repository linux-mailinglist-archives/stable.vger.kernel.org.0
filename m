Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29EEB426993
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242180AbhJHLj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:39:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240716AbhJHLhy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:37:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DEE6613E6;
        Fri,  8 Oct 2021 11:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692760;
        bh=9tzfcVt12E3AJYpIaInQ2Tfai7WKL1gsFLA5d12jAmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NWTt6sXR7rKhrCQvB5AGcTk4CfFtnmUy2YgqLU+YururtlMRyfNfueoG5m0vQfU72
         uU4RjYruibqDIYAID/lnWBcDdievlnW0F5NdVsU25GsZxZz+7cS5Vv9ljIfEFIc/Fa
         LLwQe75liMbuF5rwNrhKwPcLSFjjXXnAc+sSFRBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ansuel Smith <ansuelsmth@gmail.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 31/48] thermal/drivers/tsens: Fix wrong check for tzd in irq handlers
Date:   Fri,  8 Oct 2021 13:28:07 +0200
Message-Id: <20211008112721.059846819@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



