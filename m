Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56D1E12C535
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbfL2Reo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:34:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:38282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729316AbfL2Ren (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:34:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A73AA20722;
        Sun, 29 Dec 2019 17:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640883;
        bh=uy6XzSnsfF+rRlYvmuxeFt+VH4vVhWNMPLzSt27uK4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VbKDccZLLdcn5wS0bAL2zp3nomrh8d3ZjrY3JxuilpDfSxzELt0dzfWI1hb8dIw7j
         nidyFFgNs847YkbABOXoRxOmDIm2Te3uNohakyhEEWLQTZPoosGsuYcMZbx/qYUNck
         xB4tXNNfbYg0Ydp5mhly4Rx0rXGkHGU6FluZ0+Bg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 171/219] ASoC: wm2200: add missed operations in remove and probe failure
Date:   Sun, 29 Dec 2019 18:19:33 +0100
Message-Id: <20191229162534.724503078@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 2dab09be49a1e7a4dd13cb47d3a1441a2ef33a87 ]

This driver misses calls to pm_runtime_disable and regulator_bulk_disable
in remove and a call to free_irq in probe failure.
Add the calls to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Link: https://lore.kernel.org/r/20191118073633.28237-1-hslester96@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm2200.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/codecs/wm2200.c b/sound/soc/codecs/wm2200.c
index deff65161504..0a3b746fb909 100644
--- a/sound/soc/codecs/wm2200.c
+++ b/sound/soc/codecs/wm2200.c
@@ -2413,6 +2413,8 @@ static int wm2200_i2c_probe(struct i2c_client *i2c,
 
 err_pm_runtime:
 	pm_runtime_disable(&i2c->dev);
+	if (i2c->irq)
+		free_irq(i2c->irq, wm2200);
 err_reset:
 	if (wm2200->pdata.reset)
 		gpio_set_value_cansleep(wm2200->pdata.reset, 0);
@@ -2429,12 +2431,15 @@ static int wm2200_i2c_remove(struct i2c_client *i2c)
 {
 	struct wm2200_priv *wm2200 = i2c_get_clientdata(i2c);
 
+	pm_runtime_disable(&i2c->dev);
 	if (i2c->irq)
 		free_irq(i2c->irq, wm2200);
 	if (wm2200->pdata.reset)
 		gpio_set_value_cansleep(wm2200->pdata.reset, 0);
 	if (wm2200->pdata.ldo_ena)
 		gpio_set_value_cansleep(wm2200->pdata.ldo_ena, 0);
+	regulator_bulk_disable(ARRAY_SIZE(wm2200->core_supplies),
+			       wm2200->core_supplies);
 
 	return 0;
 }
-- 
2.20.1



