Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A94F2CD6BA
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731193AbfJFRlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731190AbfJFRlX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:41:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A55112053B;
        Sun,  6 Oct 2019 17:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383682;
        bh=0QVKQtbYTzc53uwo95bKg2rV7mwigxbBZrR2N+aprkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gqHXmR1YqIcH4IkgjO/vLxCFkEMataewDto+HquupwTW5zKgYmzw6Wp//YuTnMlMb
         z0YGDrLn35Li01zTrMiQqsKTX6ZO0oIARPf73jSm0ivNkBD3HlW28VSwuXHd8K6vIr
         zayHemS5r0EVf652uyYDxZHlyZtP+l5qN8P07E2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Wang <kevin1.wang@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 056/166] drm/amd/powerpaly: fix navi series custom peak level value error
Date:   Sun,  6 Oct 2019 19:20:22 +0200
Message-Id: <20191006171217.804235485@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Wang <kevin1.wang@amd.com>

[ Upstream commit 706feb26f890e1b8297b5d14975160de361edf4f ]

fix other navi asic set peak performance level error.
because the navi10_ppt.c will handle navi12 14 asic,
it will use navi10 peak value to set other asic, it is not correct.

after patch:
only navi10 use custom peak value, other asic will used default value.

Signed-off-by: Kevin Wang <kevin1.wang@amd.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/navi10_ppt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/powerplay/navi10_ppt.c b/drivers/gpu/drm/amd/powerplay/navi10_ppt.c
index b81c7e715dc94..9aaf2deff6e94 100644
--- a/drivers/gpu/drm/amd/powerplay/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/powerplay/navi10_ppt.c
@@ -1627,6 +1627,10 @@ static int navi10_set_peak_clock_by_device(struct smu_context *smu)
 static int navi10_set_performance_level(struct smu_context *smu, enum amd_dpm_forced_level level)
 {
 	int ret = 0;
+	struct amdgpu_device *adev = smu->adev;
+
+	if (adev->asic_type != CHIP_NAVI10)
+		return -EINVAL;
 
 	switch (level) {
 	case AMD_DPM_FORCED_LEVEL_PROFILE_PEAK:
-- 
2.20.1



