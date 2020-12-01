Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA96D2C9B7E
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389364AbgLAJI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:08:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389355AbgLAJI5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:08:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1BDD22240;
        Tue,  1 Dec 2020 09:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813696;
        bh=p9E9dNyuQyJnJCXjhLmFzsg30ehB84WlzPKOQR3JwgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAOM3w+T7EWGjdqpATcgTxXRAHrG8ZfH4Hbu6918ZZp5AXM3KYIw+/6kTBDszui8p
         n303jyx1ywpmb1Bd+lm/ey6yoy9o3hP+LzxmuAPZxyZrC0xoA/Fyi+v7WYwpYKOuCa
         ME+QPs1RA3AhFO8d/xd9MsiOyi/OrVxF865CoVBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sonny Jiang <sonny.jiang@amd.com>,
        Leo Liu <leo.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.9 028/152] drm/amdgpu: fix SI UVD firmware validate resume fail
Date:   Tue,  1 Dec 2020 09:52:23 +0100
Message-Id: <20201201084715.567792556@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sonny Jiang <sonny.jiang@amd.com>

commit 4d6a95366117b241bb3298e1c318a36ebb7544d0 upstream.

The SI UVD firmware validate key is stored at the end of firmware,
which is changed during resume while playing video. So get the key
at sw_init and store it for fw validate using.

Signed-off-by: Sonny Jiang <sonny.jiang@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.h |    1 +
 drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c   |   20 +++++++++++---------
 2 files changed, 12 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.h
@@ -67,6 +67,7 @@ struct amdgpu_uvd {
 	unsigned		harvest_config;
 	/* store image width to adjust nb memory state */
 	unsigned		decode_image_width;
+	uint32_t                keyselect;
 };
 
 int amdgpu_uvd_sw_init(struct amdgpu_device *adev);
--- a/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c
@@ -277,15 +277,8 @@ static void uvd_v3_1_mc_resume(struct am
  */
 static int uvd_v3_1_fw_validate(struct amdgpu_device *adev)
 {
-	void *ptr;
-	uint32_t ucode_len, i;
-	uint32_t keysel;
-
-	ptr = adev->uvd.inst[0].cpu_addr;
-	ptr += 192 + 16;
-	memcpy(&ucode_len, ptr, 4);
-	ptr += ucode_len;
-	memcpy(&keysel, ptr, 4);
+	int i;
+	uint32_t keysel = adev->uvd.keyselect;
 
 	WREG32(mmUVD_FW_START, keysel);
 
@@ -550,6 +543,8 @@ static int uvd_v3_1_sw_init(void *handle
 	struct amdgpu_ring *ring;
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 	int r;
+	void *ptr;
+	uint32_t ucode_len;
 
 	/* UVD TRAP */
 	r = amdgpu_irq_add_id(adev, AMDGPU_IRQ_CLIENTID_LEGACY, 124, &adev->uvd.inst->irq);
@@ -560,6 +555,13 @@ static int uvd_v3_1_sw_init(void *handle
 	if (r)
 		return r;
 
+	/* Retrieval firmware validate key */
+	ptr = adev->uvd.inst[0].cpu_addr;
+	ptr += 192 + 16;
+	memcpy(&ucode_len, ptr, 4);
+	ptr += ucode_len;
+	memcpy(&adev->uvd.keyselect, ptr, 4);
+
 	ring = &adev->uvd.inst->ring;
 	sprintf(ring->name, "uvd");
 	r = amdgpu_ring_init(adev, ring, 512, &adev->uvd.inst->irq, 0,


