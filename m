Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62E0D15EAF2
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391756AbgBNRRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:17:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:38000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390394AbgBNQLX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:11:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7586222C2;
        Fri, 14 Feb 2020 16:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696682;
        bh=Vu3XjvYbCgw86NCz8BhfJsyxkHdSDYwpHnwGfWUj6ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NMus8fKA7OXri256pL0C0n5/k2mZ2byhPBg5aDzsG0L/yVIlRTfwKQEgy//ozHttR
         Ixq97vttGX3BGFZRBBDfCVF7U9UUhOp865c7Ro8cujC5nZp6L32Rxc0QnQYlSYMI5Z
         4wv1isFuvBXgkb3sjIkhucF2oRAArts/2BC2K6kQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>, Sasha Levin <sashal@kernel.org>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 450/459] drm/amdgpu/smu10: fix smu10_get_clock_by_type_with_voltage
Date:   Fri, 14 Feb 2020 11:01:40 -0500
Message-Id: <20200214160149.11681-450-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 1064ad4aeef94f51ca230ac639a9e996fb7867a0 ]

Cull out 0 clocks to avoid a warning in DC.

Bug: https://gitlab.freedesktop.org/drm/amd/issues/963
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c b/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c
index 627a42e8fd318..fed3fc4bb57a9 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c
@@ -1080,9 +1080,11 @@ static int smu10_get_clock_by_type_with_voltage(struct pp_hwmgr *hwmgr,
 
 	clocks->num_levels = 0;
 	for (i = 0; i < pclk_vol_table->count; i++) {
-		clocks->data[i].clocks_in_khz = pclk_vol_table->entries[i].clk  * 10;
-		clocks->data[i].voltage_in_mv = pclk_vol_table->entries[i].vol;
-		clocks->num_levels++;
+		if (pclk_vol_table->entries[i].clk) {
+			clocks->data[clocks->num_levels].clocks_in_khz = pclk_vol_table->entries[i].clk  * 10;
+			clocks->data[clocks->num_levels].voltage_in_mv = pclk_vol_table->entries[i].vol;
+			clocks->num_levels++;
+		}
 	}
 
 	return 0;
-- 
2.20.1

