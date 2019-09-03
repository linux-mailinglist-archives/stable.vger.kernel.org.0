Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 736CAA6F1B
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbfICQ2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:28:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730446AbfICQ2l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:28:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62603215EA;
        Tue,  3 Sep 2019 16:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528120;
        bh=LpJv25mrQFMkEnIS6c8cNfT3TaJ5OZwMwAlT3CcHnB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2c97q563+pQ9/HaZyqgipSYIajeVE8ogi986H2x1DAMQBbykhJikvvtgk3GozM+9u
         NQ1lIUlQVDMQm+lOc9TWFLKmbeTzaSy/m7ir0rTs9fwT6aSP4ZojuwtGyyjpzGRtt7
         ZFR+1HD+k3KKnQy24vLxCUCiKduBnRk9/MHFnq6Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shirish S <shirish.s@amd.com>, Louis Li <Ching-shih.Li@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 117/167] drm/amdgpu/{uvd,vcn}: fetch ring's read_ptr after alloc
Date:   Tue,  3 Sep 2019 12:24:29 -0400
Message-Id: <20190903162519.7136-117-sashal@kernel.org>
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

From: Shirish S <shirish.s@amd.com>

[ Upstream commit 517b91f4cde3043d77b2178548473e8545ef07cb ]

[What]
readptr read always returns zero, since most likely
these blocks are either power or clock gated.

[How]
fetch rptr after amdgpu_ring_alloc() which informs
the power management code that the block is about to be
used and hence the gating is turned off.

Signed-off-by: Louis Li <Ching-shih.Li@amd.com>
Signed-off-by: Shirish S <shirish.s@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c | 5 ++++-
 drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c   | 5 ++++-
 drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c   | 5 ++++-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
index 400fc74bbae27..205e683fb9206 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
@@ -431,7 +431,7 @@ int amdgpu_vcn_dec_ring_test_ib(struct amdgpu_ring *ring, long timeout)
 int amdgpu_vcn_enc_ring_test_ring(struct amdgpu_ring *ring)
 {
 	struct amdgpu_device *adev = ring->adev;
-	uint32_t rptr = amdgpu_ring_get_rptr(ring);
+	uint32_t rptr;
 	unsigned i;
 	int r;
 
@@ -441,6 +441,9 @@ int amdgpu_vcn_enc_ring_test_ring(struct amdgpu_ring *ring)
 			  ring->idx, r);
 		return r;
 	}
+
+	rptr = amdgpu_ring_get_rptr(ring);
+
 	amdgpu_ring_write(ring, VCN_ENC_CMD_END);
 	amdgpu_ring_commit(ring);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c b/drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c
index d4070839ac809..80613a74df420 100644
--- a/drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c
@@ -170,7 +170,7 @@ static void uvd_v6_0_enc_ring_set_wptr(struct amdgpu_ring *ring)
 static int uvd_v6_0_enc_ring_test_ring(struct amdgpu_ring *ring)
 {
 	struct amdgpu_device *adev = ring->adev;
-	uint32_t rptr = amdgpu_ring_get_rptr(ring);
+	uint32_t rptr;
 	unsigned i;
 	int r;
 
@@ -180,6 +180,9 @@ static int uvd_v6_0_enc_ring_test_ring(struct amdgpu_ring *ring)
 			  ring->idx, r);
 		return r;
 	}
+
+	rptr = amdgpu_ring_get_rptr(ring);
+
 	amdgpu_ring_write(ring, HEVC_ENC_CMD_END);
 	amdgpu_ring_commit(ring);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c b/drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c
index 057151b17b456..ce16b8329af04 100644
--- a/drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c
@@ -175,7 +175,7 @@ static void uvd_v7_0_enc_ring_set_wptr(struct amdgpu_ring *ring)
 static int uvd_v7_0_enc_ring_test_ring(struct amdgpu_ring *ring)
 {
 	struct amdgpu_device *adev = ring->adev;
-	uint32_t rptr = amdgpu_ring_get_rptr(ring);
+	uint32_t rptr;
 	unsigned i;
 	int r;
 
@@ -188,6 +188,9 @@ static int uvd_v7_0_enc_ring_test_ring(struct amdgpu_ring *ring)
 			  ring->me, ring->idx, r);
 		return r;
 	}
+
+	rptr = amdgpu_ring_get_rptr(ring);
+
 	amdgpu_ring_write(ring, HEVC_ENC_CMD_END);
 	amdgpu_ring_commit(ring);
 
-- 
2.20.1

