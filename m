Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39DD03AABD
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbfFIQqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:46:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730329AbfFIQqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:46:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 234582081C;
        Sun,  9 Jun 2019 16:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098776;
        bh=NE4vb/M5WrZIBwi5PZw5SJBFBN/5bfVsl77whhDLC/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HIJCa8ONJ82uW4mcz1O92bHFyWkLRhi/JHIsfRAHGM750IJmVgvu5+FhS7OmaQIZ1
         gEa1oLnRH41VUGXwNac/usnKHShtmVgZ7GxKaxmhTRXSamr27Jo8PHbaVytT2nXJTJ
         rULBo2d1Qm6qDDrjfJ/oFjKf98bFwh4xC8sNe3qU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.1 57/70] drm/amdgpu/psp: move psp version specific function pointers to early_init
Date:   Sun,  9 Jun 2019 18:42:08 +0200
Message-Id: <20190609164132.252410083@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 9d6fea5744d6798353f37ac42a8a653a2607ca69 upstream.

In case we need to use them for GPU reset prior initializing the
asic.  Fixes a crash if the driver attempts to reset the GPU at driver
load time.

Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -38,18 +38,10 @@ static void psp_set_funcs(struct amdgpu_
 static int psp_early_init(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	struct psp_context *psp = &adev->psp;
 
 	psp_set_funcs(adev);
 
-	return 0;
-}
-
-static int psp_sw_init(void *handle)
-{
-	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
-	struct psp_context *psp = &adev->psp;
-	int ret;
-
 	switch (adev->asic_type) {
 	case CHIP_VEGA10:
 	case CHIP_VEGA12:
@@ -67,6 +59,15 @@ static int psp_sw_init(void *handle)
 
 	psp->adev = adev;
 
+	return 0;
+}
+
+static int psp_sw_init(void *handle)
+{
+	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	struct psp_context *psp = &adev->psp;
+	int ret;
+
 	ret = psp_init_microcode(psp);
 	if (ret) {
 		DRM_ERROR("Failed to load psp firmware!\n");


