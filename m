Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E39D3291E0F
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388078AbgJRTtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:49:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727954AbgJRTVh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:21:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18D66222E8;
        Sun, 18 Oct 2020 19:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048896;
        bh=ntGs+necpS3D8VcETvW96bdW1Z+vD8P3JvUYLYzXTpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DksKIUji6iC8RCzy11L2G4TNto99M25Tgao1AFztpekP60/m5iLc5ooE0E57xgNc1
         BqOBnbOCZ7mb3mD3+asxPjPn/VpXMhnMxrIDrBGfMBCWB/zRXeb10IgHHoMNDLzj0W
         eVZYfHIRDs73/FwljE0swZ1eCG9FlzYx6oYDEPos=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        Steven Price <steven.price@arm.com>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 058/101] drm/panfrost: add Amlogic GPU integration quirks
Date:   Sun, 18 Oct 2020 15:19:43 -0400
Message-Id: <20201018192026.4053674-58-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit afcd0c7d3d4c22afc8befcfc906db6ce3058d3ee ]

This adds the required GPU quirks, including the quirk in the PWR
registers at the GPU reset time and the IOMMU quirk for shareability
issues observed on G52 in Amlogic G12B SoCs.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200916150147.25753-4-narmstrong@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_drv.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index 882fecc33fdb1..6e11a73e81aa3 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -667,7 +667,18 @@ static const struct panfrost_compatible default_data = {
 	.pm_domain_names = NULL,
 };
 
+static const struct panfrost_compatible amlogic_data = {
+	.num_supplies = ARRAY_SIZE(default_supplies),
+	.supply_names = default_supplies,
+	.vendor_quirk = panfrost_gpu_amlogic_quirk,
+};
+
 static const struct of_device_id dt_match[] = {
+	/* Set first to probe before the generic compatibles */
+	{ .compatible = "amlogic,meson-gxm-mali",
+	  .data = &amlogic_data, },
+	{ .compatible = "amlogic,meson-g12a-mali",
+	  .data = &amlogic_data, },
 	{ .compatible = "arm,mali-t604", .data = &default_data, },
 	{ .compatible = "arm,mali-t624", .data = &default_data, },
 	{ .compatible = "arm,mali-t628", .data = &default_data, },
-- 
2.25.1

