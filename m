Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53373A0385
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236460AbhFHTSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:18:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236161AbhFHTQD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:16:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDB0561965;
        Tue,  8 Jun 2021 18:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178258;
        bh=pqfPMXEdK6pB7+aNnGLJQshxp1gmNXlYrCRLSv3/iTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j03/WNPnurr64zdjjSECpF8YV/r6vrwQRFc125jM1N6Y6yjnmPiPbA63TTCrhvs8h
         +RniaI49kvHEa9yonCKmWy7SzQg73EpUOG67qP6nMpRvSq+uIyPrGpssL6q4dvyJuK
         1y+p18xw00UnwcsSxKNxAeFlWpuQl/JmYWoTCeFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nirmoy Das <nirmoy.das@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.12 136/161] drm/amdgpu: make sure we unpin the UVD BO
Date:   Tue,  8 Jun 2021 20:27:46 +0200
Message-Id: <20210608175950.043654417@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nirmoy Das <nirmoy.das@amd.com>

commit 07438603a07e52f1c6aa731842bd298d2725b7be upstream.

Releasing pinned BOs is illegal now. UVD 6 was missing from:
commit 2f40801dc553 ("drm/amdgpu: make sure we unpin the UVD BO")

Fixes: 2f40801dc553 ("drm/amdgpu: make sure we unpin the UVD BO")
Cc: stable@vger.kernel.org
Signed-off-by: Nirmoy Das <nirmoy.das@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c
@@ -357,6 +357,7 @@ static int uvd_v6_0_enc_ring_test_ib(str
 
 error:
 	dma_fence_put(fence);
+	amdgpu_bo_unpin(bo);
 	amdgpu_bo_unreserve(bo);
 	amdgpu_bo_unref(&bo);
 	return r;


