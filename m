Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3AC1196CF
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbfLJV3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:29:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:59850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728075AbfLJVKO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:10:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F3BE246AF;
        Tue, 10 Dec 2019 21:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012214;
        bh=9DuhPQ8azOh7FR3hAsKZOg1/CZehSj6kpfTGsmmOFM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R6Q37TjxS/Rl96xQsYpisviQwEOpgRl0czFecIAUc0QTKu1CIj597btHb+NmdCGY8
         jjk6SFMsMlz6jahz1LLCI2iDcJqn1YLj+5QbGjJOP5l7ryctkATR6jdt/xbVB7812v
         kD4D92WyrURyeMnCnX7dHQp0LNK8Aa3hn5cGP9+M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 165/350] drm/tegra: sor: Use correct SOR index on Tegra210
Date:   Tue, 10 Dec 2019 16:04:30 -0500
Message-Id: <20191210210735.9077-126-sashal@kernel.org>
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
index e1669ada0a405..75e65d9536d54 100644
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

