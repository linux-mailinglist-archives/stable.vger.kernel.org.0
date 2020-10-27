Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13AB29BBBD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1809628AbgJ0Q1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:27:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802748AbgJ0PvL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:51:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BDAC204EF;
        Tue, 27 Oct 2020 15:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813871;
        bh=HBFMJq3Sjz6XcNnpX5MUhb16/7mEz0FRqglRSlBXsFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCHAjGS/o/atjdDV65RAYyxJH4ef2XRHp93oV9cBCT6Ojm46eSr6A2Hj10I8Nm1oP
         OMS9PEobwRG9z5ylqfUFDsSSQ+IF51XLEXv0DmWGctKL8Fo0k3yUoyBrlL6O5rtusM
         b6L9LRzaDJGZHSVINmEbVSC4omoMRXSTz/3tAdOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Steven Price <steven.price@arm.com>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 698/757] drm/panfrost: add Amlogic GPU integration quirks
Date:   Tue, 27 Oct 2020 14:55:48 +0100
Message-Id: <20201027135523.255777968@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ada51df9a7a32..f6d5d03201fad 100644
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



