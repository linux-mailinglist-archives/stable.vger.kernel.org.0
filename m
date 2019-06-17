Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C9C49269
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbfFQVT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:19:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728978AbfFQVT7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:19:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8771A208E4;
        Mon, 17 Jun 2019 21:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806398;
        bh=cEKgHV/LLYblwDFGLNJwQps4H5yoUuSaeVkJzJ5+/mM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XHe3PTZ0oHsdg+xkh8NpLckVsstBM4i6/hEKYXfjE+ZeQMPiqlWTEOb2GNkAhnbQC
         qYwaXHaoF/ALAq8wOejP9Cg0Y8pv/dhCGLYZtBF6ofDLp/YeII/4vgUGbi9dJadY7+
         suUMBtMA1e1NXmHA/L0XhwTYS833qPu++NxLuR/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Louis Li <Ching-shih.Li@amd.com>,
        Shirish S <shirish.s@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.1 037/115] drm/amdgpu/{uvd,vcn}: fetch rings read_ptr after alloc
Date:   Mon, 17 Jun 2019 23:08:57 +0200
Message-Id: <20190617210801.911010192@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shirish S <shirish.s@amd.com>

commit 517b91f4cde3043d77b2178548473e8545ef07cb upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c |    4 +++-
 drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c   |    5 ++++-
 drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c   |    5 ++++-
 3 files changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c
@@ -594,7 +594,7 @@ error:
 int amdgpu_vcn_enc_ring_test_ring(struct amdgpu_ring *ring)
 {
 	struct amdgpu_device *adev = ring->adev;
-	uint32_t rptr = amdgpu_ring_get_rptr(ring);
+	uint32_t rptr;
 	unsigned i;
 	int r;
 
@@ -602,6 +602,8 @@ int amdgpu_vcn_enc_ring_test_ring(struct
 	if (r)
 		return r;
 
+	rptr = amdgpu_ring_get_rptr(ring);
+
 	amdgpu_ring_write(ring, VCN_ENC_CMD_END);
 	amdgpu_ring_commit(ring);
 
--- a/drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c
@@ -170,13 +170,16 @@ static void uvd_v6_0_enc_ring_set_wptr(s
 static int uvd_v6_0_enc_ring_test_ring(struct amdgpu_ring *ring)
 {
 	struct amdgpu_device *adev = ring->adev;
-	uint32_t rptr = amdgpu_ring_get_rptr(ring);
+	uint32_t rptr;
 	unsigned i;
 	int r;
 
 	r = amdgpu_ring_alloc(ring, 16);
 	if (r)
 		return r;
+
+	rptr = amdgpu_ring_get_rptr(ring);
+
 	amdgpu_ring_write(ring, HEVC_ENC_CMD_END);
 	amdgpu_ring_commit(ring);
 
--- a/drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v7_0.c
@@ -175,7 +175,7 @@ static void uvd_v7_0_enc_ring_set_wptr(s
 static int uvd_v7_0_enc_ring_test_ring(struct amdgpu_ring *ring)
 {
 	struct amdgpu_device *adev = ring->adev;
-	uint32_t rptr = amdgpu_ring_get_rptr(ring);
+	uint32_t rptr;
 	unsigned i;
 	int r;
 
@@ -185,6 +185,9 @@ static int uvd_v7_0_enc_ring_test_ring(s
 	r = amdgpu_ring_alloc(ring, 16);
 	if (r)
 		return r;
+
+	rptr = amdgpu_ring_get_rptr(ring);
+
 	amdgpu_ring_write(ring, HEVC_ENC_CMD_END);
 	amdgpu_ring_commit(ring);
 


