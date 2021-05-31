Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD65396182
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbhEaOlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:41:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234163AbhEaOjf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:39:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D07561C61;
        Mon, 31 May 2021 13:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469169;
        bh=5LlACC9eb6jvWorU9pDA7NG43+2mm3M4Wkkm+rUdpr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u948Eu2R5SmR/pQhoIh2DsXwARsudSjQsbJAfr8300gDwW09032gzZ9aWeJI0a6t5
         V3odYLt66Q65NHL4VPt5+N/ZWlxO20GLPBpSShp8kEiF2a9H7nkpDqkfQ1/BpHsW6Y
         N2FAYigdDvApmem52eu9hYRCo7XCoWc4BeJVu3Yk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Zhu <James.Zhu@amd.com>,
        Leo Liu <leo.liu@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.12 060/296] drm/amdgpu/jpeg2.0: add cancel_delayed_work_sync before power gate
Date:   Mon, 31 May 2021 15:11:55 +0200
Message-Id: <20210531130705.852828791@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Zhu <James.Zhu@amd.com>

commit ff48f6dbf0ff896c98d167a67a5b975fb034356b upstream.

Add cancel_delayed_work_sync before set power gating state
to avoid race condition issue when power gating.

Signed-off-by: James Zhu <James.Zhu@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
@@ -172,6 +172,8 @@ static int jpeg_v2_0_hw_fini(void *handl
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
+	cancel_delayed_work_sync(&adev->vcn.idle_work);
+
 	if (adev->jpeg.cur_state != AMD_PG_STATE_GATE &&
 	      RREG32_SOC15(JPEG, 0, mmUVD_JRBC_STATUS))
 		jpeg_v2_0_set_powergating_state(adev, AMD_PG_STATE_GATE);


