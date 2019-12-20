Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24A0A127C8D
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfLTOaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:30:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:33264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727483AbfLTOaC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:30:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 791ED206CB;
        Fri, 20 Dec 2019 14:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852202;
        bh=/I6+Hsqr6v9xI0xByVoqUjWM2QPpF2hzrFHfe/Pa7ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zaNIOimS40/0b8fBRbFZibo7n0Lc+K5zrmRf6JieodJVpatnnb6QOkYBUmwl3se/l
         /zxtQmPcFArVEYFOUfD+cC2fDle1F3dLVAYKxV/JSn6Hl9et92H3OBg6nUH40M9MaF
         AGEqiC8ZP3syb4pz31RnFcvyULDvk/9vAFy7tFD0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>, Sasha Levin <sashal@kernel.org>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 05/52] drm/amdgpu: add header line for power profile on Arcturus
Date:   Fri, 20 Dec 2019 09:29:07 -0500
Message-Id: <20191220142954.9500-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220142954.9500-1-sashal@kernel.org>
References: <20191220142954.9500-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 14891c316ca7e15d81dba78f30fb630e3f9ee2c9 ]

So the output is consistent with other asics.

Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/arcturus_ppt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/powerplay/arcturus_ppt.c b/drivers/gpu/drm/amd/powerplay/arcturus_ppt.c
index d493a3f8c07a6..b68bf8dcfa783 100644
--- a/drivers/gpu/drm/amd/powerplay/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/powerplay/arcturus_ppt.c
@@ -1388,12 +1388,17 @@ static int arcturus_get_power_profile_mode(struct smu_context *smu,
 					"VR",
 					"COMPUTE",
 					"CUSTOM"};
+	static const char *title[] = {
+			"PROFILE_INDEX(NAME)"};
 	uint32_t i, size = 0;
 	int16_t workload_type = 0;
 
 	if (!smu->pm_enabled || !buf)
 		return -EINVAL;
 
+	size += sprintf(buf + size, "%16s\n",
+			title[0]);
+
 	for (i = 0; i <= PP_SMC_POWER_PROFILE_CUSTOM; i++) {
 		/*
 		 * Conv PP_SMC_POWER_PROFILE* to WORKLOAD_PPLIB_*_BIT
-- 
2.20.1

