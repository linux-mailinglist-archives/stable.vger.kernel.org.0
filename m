Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E35E1199C6
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbfLJVIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:08:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:55572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727834AbfLJVIS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:08:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7213C20836;
        Tue, 10 Dec 2019 21:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012097;
        bh=6fwUb6MigjWRWv6QEWMWqEYkJGBehiZ+r1aewxVkB0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2N260DjkA1ZYPqHnoDUUR+Hj26Vw5NsSE1Dv4DY8ubBLz52tpLXN4cVBeeduJvQIb
         q4XYPdY/OXs7YKn3/2frDQFqVycMOt1SC4YE5iFpAZ8DSLf2BH5gWGEKHO4FkD2yRU
         9KnHrXV1PhewCXpL/xoX4fF/TalSjzyq9LqU5GU4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oak Zeng <Oak.Zeng@amd.com>, Jonathan Kim <Jonathan.Kim@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 073/350] drm/amdkfd: Fix MQD size calculation
Date:   Tue, 10 Dec 2019 16:02:58 -0500
Message-Id: <20191210210735.9077-34-sashal@kernel.org>
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

From: Oak Zeng <Oak.Zeng@amd.com>

[ Upstream commit 40a9592a26608e16f7545a068ea4165e1869f629 ]

On device initialization, a chunk of GTT memory is pre-allocated for
HIQ and all SDMA queues mqd. The size of this allocation was wrong.
The correct sdma engine number should be PCIe-optimized SDMA engine
number plus xgmi SDMA engine number.

Reported-by: Jonathan Kim <Jonathan.Kim@amd.com>
Signed-off-by: Jonathan Kim <Jonathan.Kim@amd.com>
Signed-off-by: Oak Zeng <Oak.Zeng@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index d985e31fcc1eb..f335f73919d15 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1676,7 +1676,8 @@ static int allocate_hiq_sdma_mqd(struct device_queue_manager *dqm)
 	struct kfd_dev *dev = dqm->dev;
 	struct kfd_mem_obj *mem_obj = &dqm->hiq_sdma_mqd;
 	uint32_t size = dqm->mqd_mgrs[KFD_MQD_TYPE_SDMA]->mqd_size *
-		dev->device_info->num_sdma_engines *
+		(dev->device_info->num_sdma_engines +
+		dev->device_info->num_xgmi_sdma_engines) *
 		dev->device_info->num_sdma_queues_per_engine +
 		dqm->mqd_mgrs[KFD_MQD_TYPE_HIQ]->mqd_size;
 
-- 
2.20.1

