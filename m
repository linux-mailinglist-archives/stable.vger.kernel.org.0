Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044C03BCBD7
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbhGFLRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:17:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232058AbhGFLRZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:17:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32CF561C2C;
        Tue,  6 Jul 2021 11:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570087;
        bh=S9VUqqUxP5x+jTKZE7p+pVTUqhUjDBrgfdDQIXg5el4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L577jWlcWI3yqonOMy6SmKvpwXzc8HXOTRUU5OYHxn+DfFMH//iwNt2lVJ0BPmQ7l
         pniLY6je8n0awYlIUe20TUfojes7YNtNslXh3oldJC2jT+zpb9JQzBRCt9WLoRKgLO
         pV30MjjgDn/QWPFzq0b43l6iw7Bb+Vkij2JfY6ZFXwXwoMCCwjHW280hVx4ESPo/pU
         +mbkBQP9Jxl+sN44caF2lBojgiMsCc+8REyTqqED4x7aXcH0AJGBvJUODq9uUTm4OB
         O4lrvFlG7p6CMd7B28RGKPhi4/BGE/F4wcK8uORZXkqK2decD8gJl3h2u4tDiovkxo
         dLfy0T2cDbvZw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Boichat <drinkcat@chromium.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 026/189] drm/panfrost: devfreq: Disable devfreq when num_supplies > 1
Date:   Tue,  6 Jul 2021 07:11:26 -0400
Message-Id: <20210706111409.2058071-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Boichat <drinkcat@chromium.org>

[ Upstream commit 09da3191827f2fd326205fb58881838e6ea36fb7 ]

GPUs with more than a single regulator (e.g. G72 on MT8183) will
require platform-specific handling for devfreq, for 2 reasons:
 1. The opp core (drivers/opp/core.c:_generic_set_opp_regulator)
    does not support multiple regulators, so we'll need custom
    handlers.
 2. Generally, platforms with 2 regulators have platform-specific
    constraints on how the voltages should be set (e.g.
    minimum/maximum voltage difference between them), so we
    should not just create generic handlers that simply
    change the voltages without taking care of those constraints.

Disable devfreq for now on those GPUs.

Signed-off-by: Nicolas Boichat <drinkcat@chromium.org>
Reviewed-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210421132841.v13.3.I3af068abe30c9c85cabc4486385c52e56527a509@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_devfreq.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/panfrost/panfrost_devfreq.c b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
index 47d27e54a34f..3644652f726f 100644
--- a/drivers/gpu/drm/panfrost/panfrost_devfreq.c
+++ b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
@@ -92,6 +92,15 @@ int panfrost_devfreq_init(struct panfrost_device *pfdev)
 	struct thermal_cooling_device *cooling;
 	struct panfrost_devfreq *pfdevfreq = &pfdev->pfdevfreq;
 
+	if (pfdev->comp->num_supplies > 1) {
+		/*
+		 * GPUs with more than 1 supply require platform-specific handling:
+		 * continue without devfreq
+		 */
+		DRM_DEV_INFO(dev, "More than 1 supply is not supported yet\n");
+		return 0;
+	}
+
 	ret = devm_pm_opp_set_regulators(dev, pfdev->comp->supply_names,
 					 pfdev->comp->num_supplies);
 	if (ret) {
-- 
2.30.2

