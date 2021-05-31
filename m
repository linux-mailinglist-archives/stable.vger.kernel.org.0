Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1BC9395E33
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbhEaNz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:55:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230381AbhEaNxT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:53:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CC9F61919;
        Mon, 31 May 2021 13:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467995;
        bh=TZ+BvSzQSQQ6Wj2maDP4Z+N3numtIi8t8pOOLudM5YA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m+a2z28hq8ZCfxU8VIo31WFplbZPBHESpwbk7axoqUU3H6zcLaMFaeMcmoAPLEoS8
         TkqRjJS+yM8AeD7B+SbSDeGx2r3jxGmxsJLK6tFK8vcSXkt4FsZ6Xz/n2ju8ljmOt2
         OqAGKARr7mZEwvprMa+ipt2qj/KzUvf3rRejRk3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Zhu <James.Zhu@amd.com>,
        Leo Liu <leo.liu@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 042/252] drm/amdgpu/vcn1: add cancel_delayed_work_sync before power gate
Date:   Mon, 31 May 2021 15:11:47 +0200
Message-Id: <20210531130659.421154909@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Zhu <James.Zhu@amd.com>

commit b95f045ea35673572ef46d6483ad8bd6d353d63c upstream.

Add cancel_delayed_work_sync before set power gating state
to avoid race condition issue when power gating.

Signed-off-by: James Zhu <James.Zhu@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
@@ -232,9 +232,13 @@ static int vcn_v1_0_hw_fini(void *handle
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
+	cancel_delayed_work_sync(&adev->vcn.idle_work);
+
 	if ((adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG) ||
-		RREG32_SOC15(VCN, 0, mmUVD_STATUS))
+		(adev->vcn.cur_state != AMD_PG_STATE_GATE &&
+		 RREG32_SOC15(VCN, 0, mmUVD_STATUS))) {
 		vcn_v1_0_set_powergating_state(adev, AMD_PG_STATE_GATE);
+	}
 
 	return 0;
 }


