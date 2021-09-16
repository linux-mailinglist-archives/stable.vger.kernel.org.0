Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5F340E4DE
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347845AbhIPRF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:05:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348405AbhIPRCq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:02:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F005F613A2;
        Thu, 16 Sep 2021 16:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810033;
        bh=xD+ZUE/6CDE3NtHwOSBQdZXxNVacX1TLN5AtiFZ+MTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tFTpy8obbHHSjg4/g9ux8J7BohN3f6C0P65cAI6s6/u09jo9DbSit9KzCJyH/ePPL
         DOd0PJPHJjAjM1HrJu1qXV9ssKfUiWOvQYMNaG/9MReINDrMykW6cGsMQE9CI1Ee/S
         esAAu3OePuZZureZEw5qClPgrs/TPHL3Rluxg6PM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, xinhui pan <xinhui.pan@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.13 373/380] drm/amdgpu: Fix a deadlock if previous GEM object allocation fails
Date:   Thu, 16 Sep 2021 18:02:10 +0200
Message-Id: <20210916155816.738240396@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: xinhui pan <xinhui.pan@amd.com>

commit 703677d9345d87d7288ed8a2483ca424af7d4b3b upstream.

Fall through to handle the error instead of return.

Fixes: f8aab60422c37 ("drm/amdgpu: Initialise drm_gem_object_funcs for imported BOs")
Cc: stable@vger.kernel.org
Signed-off-by: xinhui pan <xinhui.pan@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -277,21 +277,18 @@ retry:
 	r = amdgpu_gem_object_create(adev, size, args->in.alignment,
 				     initial_domain,
 				     flags, ttm_bo_type_device, resv, &gobj);
-	if (r) {
-		if (r != -ERESTARTSYS) {
-			if (flags & AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED) {
-				flags &= ~AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED;
-				goto retry;
-			}
+	if (r && r != -ERESTARTSYS) {
+		if (flags & AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED) {
+			flags &= ~AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED;
+			goto retry;
+		}
 
-			if (initial_domain == AMDGPU_GEM_DOMAIN_VRAM) {
-				initial_domain |= AMDGPU_GEM_DOMAIN_GTT;
-				goto retry;
-			}
-			DRM_DEBUG("Failed to allocate GEM object (%llu, %d, %llu, %d)\n",
-				  size, initial_domain, args->in.alignment, r);
+		if (initial_domain == AMDGPU_GEM_DOMAIN_VRAM) {
+			initial_domain |= AMDGPU_GEM_DOMAIN_GTT;
+			goto retry;
 		}
-		return r;
+		DRM_DEBUG("Failed to allocate GEM object (%llu, %d, %llu, %d)\n",
+				size, initial_domain, args->in.alignment, r);
 	}
 
 	if (flags & AMDGPU_GEM_CREATE_VM_ALWAYS_VALID) {


