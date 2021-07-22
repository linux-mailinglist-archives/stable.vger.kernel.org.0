Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE2D3D29F2
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234027AbhGVQHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:07:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234191AbhGVQF7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:05:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE0A061D2C;
        Thu, 22 Jul 2021 16:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972393;
        bh=FQXIRt4S9fKQcn3FknQpuVukK2IJVmAwxwDQPkJ1EHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0m9nyMLDliC3HU2w2rH/ldod54S+CnO9zC5a1Dfq/c/tVuyjAh1K25RHuu0d3toQ0
         fLUyefvoX/Ryw0UeNvoJan104aKi2nYelyKs7fsUbpbk+ErdItzQ1fWlxA0/hAV55o
         Yfszsx7w1d7i7vTC0nAblQP/+dPzRm4nxCEgBQbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 097/156] thermal/core/thermal_of: Stop zone device before unregistering it
Date:   Thu, 22 Jul 2021 18:31:12 +0200
Message-Id: <20210722155631.519039541@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



