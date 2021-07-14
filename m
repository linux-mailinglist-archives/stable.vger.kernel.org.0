Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03FD73C8FAE
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240019AbhGNTxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240347AbhGNTtl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7720F6142E;
        Wed, 14 Jul 2021 19:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291908;
        bh=FQXIRt4S9fKQcn3FknQpuVukK2IJVmAwxwDQPkJ1EHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aMT+ARkm6PqX6xSgYyPE0KriOIqTtmIc+lADcJl+cUx/toucZFMcbBTG9P18kQ6ks
         Lz9LtrYM6QRjrY8q3dGLg2SxnrdqtYSkxxbBPkXcanbbBp/7nNojd8H8ZWBKlgXc0b
         sEW72abrRTuLcJbULAe6OHctx4jLY0OK+FG1RX/GPMpHJsz+OUbxD3WzVHGXEfJ5aD
         4JaixwUqdm6I5tjQDLmqxCSxxNVEeDyythx6+x8xNtuiBBkFsXdcdgCLeGYF/HD6KF
         x7CJwH9uKEXAZyGFtNBpzUIyxI2uf9UPLMcFD7kDkR0E/upt1Cy+S7GQKwdeK8rmsB
         hbhdXmbcnkKkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 85/88] thermal/core/thermal_of: Stop zone device before unregistering it
Date:   Wed, 14 Jul 2021 15:43:00 -0400
Message-Id: <20210714194303.54028-85-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 5e5c9f9a75fc4532980c2e699caf8a36070a3a2e ]

Zone device is enabled after thermal_zone_of_sensor_register() completion,
but it's not disabled before senor is unregistered, leaving temperature
polling active. This results in accessing a disabled zone device and
produces a warning about this problem. Stop zone device before
unregistering it in order to fix this "use-after-free" problem.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210616190417.32214-3-digetx@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_of.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
index 5b76f9a1280d..6379f26a335f 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -559,6 +559,9 @@ void thermal_zone_of_sensor_unregister(struct device *dev,
 	if (!tz)
 		return;
 
+	/* stop temperature polling */
+	thermal_zone_device_disable(tzd);
+
 	mutex_lock(&tzd->lock);
 	tzd->ops->get_temp = NULL;
 	tzd->ops->get_trend = NULL;
-- 
2.30.2

