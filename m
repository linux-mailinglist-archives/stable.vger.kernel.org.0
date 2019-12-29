Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C99E112C49F
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729152AbfL2RbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:31:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:58566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729149AbfL2RbW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:31:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC62620409;
        Sun, 29 Dec 2019 17:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640682;
        bh=5nf/amcRKDa6WSguBm8SNU6OOzhveTXK6bcSQYEBDbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cf/n/O0gpNLf3FqmIqNbu4e8H8ybbZil/laAtMnVBZ1Jsb6/HgwM4bLfvWhoR+0Pj
         8kC0un8pFcafKBG+GjtC/lTLExnCHDDzqC1ZRFGz8k8wToVYm2RrWaiLpAqrKyMlVg
         6igKaObhM81S4L6FEznYUEbKBNNceikMaik3uxbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 096/219] drm/tegra: sor: Use correct SOR index on Tegra210
Date:   Sun, 29 Dec 2019 18:18:18 +0100
Message-Id: <20191229162522.303055360@linuxfoundation.org>
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
index d7fe9f15def1..89cb70da2bfe 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -2922,6 +2922,11 @@ static int tegra_sor_parse_dt(struct tegra_sor *sor)
 		 * earlier
 		 */
 		sor->pad = TEGRA_IO_PAD_HDMI_DP0 + sor->index;
+	} else {
+		if (sor->soc->supports_edp)
+			sor->index = 0;
+		else
+			sor->index = 1;
 	}
 
 	return 0;
-- 
2.20.1



