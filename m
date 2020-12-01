Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D902C9D0B
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389581AbgLAJJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:09:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:46786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389409AbgLAJJT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:09:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4900D206C1;
        Tue,  1 Dec 2020 09:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813719;
        bh=cVHhLDooFf70FHNrrM/nJEOSdIgAVGvD/EuzImuT/2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6QgUXqodajmg7MwSHPLdusH1l3BmCF87u5p0ngaJNmFh2d6x8uk5/wKuLt8fN69H
         HtKsphSl5E5R0VTtnGMJypz0M+lbFX7/KmuiJMmqLCm4HRFOx7+arhi43GP7HlLH8q
         E/LqaZTjzvkhKLpzIjzDwpphxM7kgVN0rlkJt5cM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sonny Jiang <sonny.jiang@amd.com>,
        Leo Liu <leo.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.9 035/152] drm/amdgpu: fix a page fault
Date:   Tue,  1 Dec 2020 09:52:30 +0100
Message-Id: <20201201084716.457544855@linuxfoundation.org>
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

commit dbbf2728d50343b7947001a81f4c8cc98e4b44e5 upstream.

The UVD firmware is copied to cpu addr in uvd_resume, so it
should be used after that. This is to fix a bug introduced by
patch drm/amdgpu: fix SI UVD firmware validate resume fail.

Signed-off-by: Sonny Jiang <sonny.jiang@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
CC: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c
@@ -555,13 +555,6 @@ static int uvd_v3_1_sw_init(void *handle
 	if (r)
 		return r;
 
-	/* Retrieval firmware validate key */
-	ptr = adev->uvd.inst[0].cpu_addr;
-	ptr += 192 + 16;
-	memcpy(&ucode_len, ptr, 4);
-	ptr += ucode_len;
-	memcpy(&adev->uvd.keyselect, ptr, 4);
-
 	ring = &adev->uvd.inst->ring;
 	sprintf(ring->name, "uvd");
 	r = amdgpu_ring_init(adev, ring, 512, &adev->uvd.inst->irq, 0,
@@ -573,6 +566,13 @@ static int uvd_v3_1_sw_init(void *handle
 	if (r)
 		return r;
 
+	/* Retrieval firmware validate key */
+	ptr = adev->uvd.inst[0].cpu_addr;
+	ptr += 192 + 16;
+	memcpy(&ucode_len, ptr, 4);
+	ptr += ucode_len;
+	memcpy(&adev->uvd.keyselect, ptr, 4);
+
 	r = amdgpu_uvd_entity_init(adev);
 
 	return r;


