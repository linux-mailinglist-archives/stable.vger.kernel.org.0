Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94AAF1194EF
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbfLJVRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:17:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:38634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729162AbfLJVNA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:13:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8733721D7D;
        Tue, 10 Dec 2019 21:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012380;
        bh=cp4phJm/TezhfmFoD663bW+TwsJsekUBu7sOpwQxN5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xqBkxtHuTToxyhbWQHC9XvQvIWrcP2x6+U0Mrlhekrk8oyzB00vkgax5xmrerc+nH
         xQ+8VBg+0q8Ceq2u8r47fD89soyo1Mjrb0byvKhc58J/VDW2ai6Byy4T7TE3Y1RjOD
         XQKLqUB1pm3QOQVFc+w9kCEJQY+dGfYRxde3a+vk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, patches@opensource.cirrus.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 304/350] ASoC: wm5100: add missed pm_runtime_disable
Date:   Tue, 10 Dec 2019 16:06:49 -0500
Message-Id: <20191210210735.9077-265-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit b1176bbb70866f24099cd2720283c7219fb4a81c ]

The driver forgets to call pm_runtime_disable in remove and
probe failure.
Add the calls to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20191118073707.28298-1-hslester96@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm5100.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/wm5100.c b/sound/soc/codecs/wm5100.c
index 4af0e519e6235..91cc63c5a51fa 100644
--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -2617,6 +2617,7 @@ static int wm5100_i2c_probe(struct i2c_client *i2c,
 	return ret;
 
 err_reset:
+	pm_runtime_disable(&i2c->dev);
 	if (i2c->irq)
 		free_irq(i2c->irq, wm5100);
 	wm5100_free_gpio(i2c);
@@ -2640,6 +2641,7 @@ static int wm5100_i2c_remove(struct i2c_client *i2c)
 {
 	struct wm5100_priv *wm5100 = i2c_get_clientdata(i2c);
 
+	pm_runtime_disable(&i2c->dev);
 	if (i2c->irq)
 		free_irq(i2c->irq, wm5100);
 	wm5100_free_gpio(i2c);
-- 
2.20.1

