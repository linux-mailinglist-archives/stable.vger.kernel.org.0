Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78F83A6F3E
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730537AbfICQbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:31:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729113AbfICQ2f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:28:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CF67215EA;
        Tue,  3 Sep 2019 16:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528114;
        bh=ACuq4WuBRpCSB7xWkWBjA44XlYiLFHErnApYBjTmmtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ID2d7U4Y6rOhL0+LUOFqRSpqpqDr1lbGtgkM/FDga69pqsQkFJ9reWM3nuikfZqEi
         1lcdpqdyGyxPuko4TEmRNJCpPRoNKJZXtBHT1zNGQF0NmzGxUllTIA7A0agvBUF9//
         zCwDD4J8EEoBWos68yII1QNwIkC9W1f6/6+Aoy0g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Louis Li <Ching-shih.Li@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 116/167] drm/amdgpu: fix ring test failure issue during s3 in vce 3.0 (V2)
Date:   Tue,  3 Sep 2019 12:24:28 -0400
Message-Id: <20190903162519.7136-116-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Louis Li <Ching-shih.Li@amd.com>

[ Upstream commit ce0e22f5d886d1b56c7ab4347c45b9ac5fcc058d ]

[What]
vce ring test fails consistently during resume in s3 cycle, due to
mismatch read & write pointers.
On debug/analysis its found that rptr to be compared is not being
correctly updated/read, which leads to this failure.
Below is the failure signature:
	[drm:amdgpu_vce_ring_test_ring] *ERROR* amdgpu: ring 12 test failed
	[drm:amdgpu_device_ip_resume_phase2] *ERROR* resume of IP block <vce_v3_0> failed -110
	[drm:amdgpu_device_resume] *ERROR* amdgpu_device_ip_resume failed (-110).

[How]
fetch rptr appropriately, meaning move its read location further down
in the code flow.
With this patch applied the s3 failure is no more seen for >5k s3 cycles,
which otherwise is pretty consistent.

V2: remove reduntant fetch of rptr

Signed-off-by: Louis Li <Ching-shih.Li@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
index 5f3f540738187..17862b9ecccd7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
@@ -1070,7 +1070,7 @@ void amdgpu_vce_ring_emit_fence(struct amdgpu_ring *ring, u64 addr, u64 seq,
 int amdgpu_vce_ring_test_ring(struct amdgpu_ring *ring)
 {
 	struct amdgpu_device *adev = ring->adev;
-	uint32_t rptr = amdgpu_ring_get_rptr(ring);
+	uint32_t rptr;
 	unsigned i;
 	int r, timeout = adev->usec_timeout;
 
@@ -1084,6 +1084,9 @@ int amdgpu_vce_ring_test_ring(struct amdgpu_ring *ring)
 			  ring->idx, r);
 		return r;
 	}
+
+	rptr = amdgpu_ring_get_rptr(ring);
+
 	amdgpu_ring_write(ring, VCE_CMD_END);
 	amdgpu_ring_commit(ring);
 
-- 
2.20.1

