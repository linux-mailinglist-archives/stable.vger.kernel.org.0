Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25951462717
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236328AbhK2XBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237078AbhK2XAm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:00:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BB4C12BCF9;
        Mon, 29 Nov 2021 10:35:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A92CB815C3;
        Mon, 29 Nov 2021 18:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DC6C53FAD;
        Mon, 29 Nov 2021 18:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210921;
        bh=2B19zSIfzjHALTcr/52fiFtemyt89QSziBn8z9iLU7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRec4Kq/+zEkehx90+UHThagJrlr16rYH2duL9aYJw4q/ZQm3R3sl7bS/jN1S55eK
         3R+8W+XmVMvtBTH6nKRAHV3uHncws1tTXycAqNA6v11WKRp0lBM45epAvQgeCkrOUo
         EIi/CUk0WLrh1Jeg3IBPxISC1f44pNGeZ8U+hEHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philip Yang <Philip.Yang@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 041/179] drm/amdgpu: IH process reset count when restart
Date:   Mon, 29 Nov 2021 19:17:15 +0100
Message-Id: <20211129181720.311249437@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philip Yang <Philip.Yang@amd.com>

commit 4d62555f624582e60be416fbc4772cd3fcd12b1a upstream.

Otherwise when IH process restart, count is zero, the loop will
not exit to wake_up_all after processing AMDGPU_IH_MAX_NUM_IVS
interrupts.

Cc: stable@vger.kernel.org
Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ih.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ih.c
@@ -223,7 +223,7 @@ int amdgpu_ih_wait_on_checkpoint_process
  */
 int amdgpu_ih_process(struct amdgpu_device *adev, struct amdgpu_ih_ring *ih)
 {
-	unsigned int count = AMDGPU_IH_MAX_NUM_IVS;
+	unsigned int count;
 	u32 wptr;
 
 	if (!ih->enabled || adev->shutdown)
@@ -232,6 +232,7 @@ int amdgpu_ih_process(struct amdgpu_devi
 	wptr = amdgpu_ih_get_wptr(adev, ih);
 
 restart_ih:
+	count  = AMDGPU_IH_MAX_NUM_IVS;
 	DRM_DEBUG("%s: rptr %d, wptr %d\n", __func__, ih->rptr, wptr);
 
 	/* Order reading of wptr vs. reading of IH ring data */


