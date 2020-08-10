Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A595E240FB9
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgHJTYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:24:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729559AbgHJTMc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:12:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D10EB22D04;
        Mon, 10 Aug 2020 19:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086751;
        bh=EqJNG29WJqlWYLnVx8Gj2dUj6+tg18LY1lQ+vHZZAdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6PyrzQbGY1UmX5/ZriKBd4SNh2GKjBcU6Geb+RHJKpebN/Z48QCs1l4P9RDtSLqP
         Czy+M9ouhxYA8eC9JrbBgFUCZL0livf8P8JLAXQNW6E2fDCPWjD1XN3ERd8oGofOFy
         MgINxkHzYVOZ3KNNCOF1zeHKfJpOuU4OzEoSPyPo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>, Sasha Levin <sashal@kernel.org>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 27/45] drm/amdgpu/display bail early in dm_pp_get_static_clocks
Date:   Mon, 10 Aug 2020 15:11:35 -0400
Message-Id: <20200810191153.3794446-27-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191153.3794446-1-sashal@kernel.org>
References: <20200810191153.3794446-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 376814f5fcf1aadda501d1413d56e8af85d19a97 ]

If there are no supported callbacks.  We'll fall back to the
nominal clocks.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1170
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c
index 785322cd4c6c9..7241d4c207789 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c
@@ -530,6 +530,8 @@ bool dm_pp_get_static_clocks(
 			&pp_clk_info);
 	else if (adev->smu.funcs)
 		ret = smu_get_current_clocks(&adev->smu, &pp_clk_info);
+	else
+		return false;
 	if (ret)
 		return false;
 
-- 
2.25.1

