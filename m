Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EF145E513
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242430AbhKZCjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:39:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:48222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357995AbhKZChT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:37:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB51F611ED;
        Fri, 26 Nov 2021 02:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893971;
        bh=ViCM4pw7ivH3Q4x7TTU2A5lvG5xOLkS0I4EGkHXvdtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HhC1kwSQB78B0RblHtYYdrI+r/6Rx9LDFQC5+qXLHqiyqgliKzvfwsg17X0kH/3Cs
         F0we0JSgCVeCebOFU+75pdYRPM6vOSddVyH+eQpucpSXwTx6TwY+vSzsvXQIsYJcz4
         3Jk13VfqG8oJTQP5Mx0FjMPhxWAscz4drG1bZIIyrtrlgnUXQqC9CTrvLvgc2It+K/
         tgUgqhaEHU/+xQjtwD+2Ks4L2iMPXpvThh7KxcSFrp0NTnwJP0GhO7eilMCcXUMTe7
         h7q7MFAtQXIWu73BGmT20E5doKqsJ5Ph2xl/OEUCgN3yRZSEuv6FpfmM/+SEhDSrNf
         aC8bYuevC/xmg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     shaoyunl <shaoyun.liu@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 25/39] drm/amd/amdkfd: Fix kernel panic when reset failed and been triggered again
Date:   Thu, 25 Nov 2021 21:31:42 -0500
Message-Id: <20211126023156.441292-25-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023156.441292-1-sashal@kernel.org>
References: <20211126023156.441292-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: shaoyunl <shaoyun.liu@amd.com>

[ Upstream commit 2cf49e00d40d5132e3d067b5aa6d84791929ab15 ]

In SRIOV configuration, the reset may failed to bring asic back to normal but stop cpsch
already been called, the start_cpsch will not be called since there is no resume in this
case.  When reset been triggered again, driver should avoid to do uninitialization again.

Signed-off-by: shaoyunl <shaoyun.liu@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index f8fce9d05f50c..4f2e0cc8a51a8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1225,6 +1225,11 @@ static int stop_cpsch(struct device_queue_manager *dqm)
 	bool hanging;
 
 	dqm_lock(dqm);
+	if (!dqm->sched_running) {
+		dqm_unlock(dqm);
+		return 0;
+	}
+
 	if (!dqm->is_hws_hang)
 		unmap_queues_cpsch(dqm, KFD_UNMAP_QUEUES_FILTER_ALL_QUEUES, 0);
 	hanging = dqm->is_hws_hang || dqm->is_resetting;
-- 
2.33.0

