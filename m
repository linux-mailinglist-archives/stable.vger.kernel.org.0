Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7EFB1F51
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390174AbfIMNSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:18:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390166AbfIMNSM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:18:12 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09F46206BB;
        Fri, 13 Sep 2019 13:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380691;
        bh=rJpO7TU0sY6emSYPENsTn/mM8sHV7RmIWOtVJ/Zqg4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G4JpmCjDxTIRuYC2h4Thyu64sc8i+wTSveqit90rkGko3xhbsfBwmSuCqntVJeLvM
         p6VDrOaTTXqm8t/VMM9dm4MzXD2bcZBhZIjGIGLa4BDADHGxn2oejGjWWFGwiBUbId
         JFCvNFwOJKFb3TyF809Epm6sZh/yM6P7CuCZ/ThA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Louis Li <Ching-shih.Li@amd.com>,
        Shirish S <shirish.s@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 138/190] drm/amdgpu/{uvd,vcn}: fetch rings read_ptr after alloc
Date:   Fri, 13 Sep 2019 14:06:33 +0100
Message-Id: <20190913130611.029453027@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
@@ -431,7 +431,7 @@ error:
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



