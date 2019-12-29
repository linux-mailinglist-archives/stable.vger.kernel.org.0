Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF1D212C816
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731966AbfL2Rux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:50:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:35556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731957AbfL2Ruu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:50:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6617207FF;
        Sun, 29 Dec 2019 17:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641850;
        bh=4CpNO/7cggL/xqwJR8i2ebo7XhnCuvTKWIfjGzI9dj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M921NThMelQbzFJIFeT2Yoydgo3vXr2TACua/eXPlgvwK6sCPy4tSmQfbbqQP1Dqr
         sB3ZehaZr0ADtJzSZXM1fM4b0QggP6Gnkfua1tlylMmIlQvMmaAaPqNSvwoXmdD4Z2
         nw45TQw4sk8q0kZlZHlhbOTaGnYrmM1L8nnd+ZlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 194/434] drm/tegra: sor: Use correct SOR index on Tegra210
Date:   Sun, 29 Dec 2019 18:24:07 +0100
Message-Id: <20191229172714.712741915@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 24e64f86da40e68c5f58af08796110f147b12193 ]

The device tree bindings for the Tegra210 SOR don't require the
controller instance to be defined, since the instance can be derived
from the compatible string. The index is never used on Tegra210, so we
got away with it not getting set. However, subsequent patches will
change that, so make sure the proper index is used.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/sor.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index e1669ada0a40..75e65d9536d5 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -3200,6 +3200,11 @@ static int tegra_sor_parse_dt(struct tegra_sor *sor)
 		 * earlier
 		 */
 		sor->pad = TEGRA_IO_PAD_HDMI_DP0 + sor->index;
+	} else {
+		if (sor->soc->supports_edp)
+			sor->index = 0;
+		else
+			sor->index = 1;
 	}
 
 	err = of_property_read_u32_array(np, "nvidia,xbar-cfg", xbar_cfg, 5);
-- 
2.20.1



