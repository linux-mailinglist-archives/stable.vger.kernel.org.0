Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50298426947
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241640AbhJHLf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:35:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241617AbhJHLdz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:33:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9961B6103C;
        Fri,  8 Oct 2021 11:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692665;
        bh=Hv6zhBgHG460Lq2ZwpA4zetkrNeCBkz0ebL3kw8dHp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nX70TfAbNxD2UIDVHwwc2vAcY9GJrN96DZeje8ns8b0a0ejmb1lG7slMShHKTUey1
         Or/YM/JwV01LpxK+XckPlTlKpq6vqKU+J1k/vvI791eGKRMtqdmssezr+MEhxf1NOq
         e05s89dmZIWWd7/rvHAjBQsyJL3if5YHo91ANj5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ansuel Smith <ansuelsmth@gmail.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 19/29] thermal/drivers/tsens: Fix wrong check for tzd in irq handlers
Date:   Fri,  8 Oct 2021 13:28:06 +0200
Message-Id: <20211008112717.600045003@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112716.914501436@linuxfoundation.org>
References: <20211008112716.914501436@linuxfoundation.org>
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



