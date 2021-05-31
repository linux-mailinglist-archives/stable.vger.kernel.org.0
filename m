Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03521396168
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhEaOkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:40:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233933AbhEaOhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:37:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3407861C52;
        Mon, 31 May 2021 13:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469115;
        bh=Tg5e3P3m5H6s4Zj5G9dfzDFhHNm44SLJ5FAMgs/JNWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u58fQ9RVzaFBLQ4tc1H9Q6WsPvfQdqiVQ4AEDbTUutPpXDCfB7/qkrMKPeIVXBKl8
         Q0mSsbAB+1ov4iXvoa337ZPHhWVI0TLDOKjfKcwtONLnJZrkeNu8saW0RGYfjiZ3dP
         xPSEUQvANYnWzvmj+nEMmSzTF3XBbHVcVg/3mrVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Zhu <James.Zhu@amd.com>,
        Leo Liu <leo.liu@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.12 058/296] drm/amdgpu/vcn2.0: add cancel_delayed_work_sync before power gate
Date:   Mon, 31 May 2021 15:11:53 +0200
Message-Id: <20210531130705.778955862@linuxfoundation.org>
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

commit 0c6013377b4027e69d8f3e63b6bf556b6cb87802 upstream.

Add cancel_delayed_work_sync before set power gating state
to avoid race condition issue when power gating.

Signed-off-by: James Zhu <James.Zhu@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c
@@ -262,6 +262,8 @@ static int vcn_v2_0_hw_fini(void *handle
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
+	cancel_delayed_work_sync(&adev->vcn.idle_work);
+
 	if ((adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG) ||
 	    (adev->vcn.cur_state != AMD_PG_STATE_GATE &&
 	      RREG32_SOC15(VCN, 0, mmUVD_STATUS)))


