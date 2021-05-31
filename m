Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8496B395FDD
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhEaOQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:16:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233661AbhEaOOr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:14:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA37261995;
        Mon, 31 May 2021 13:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468549;
        bh=6j6ZMMCKN0uBgMN7g5/8gcsFHGF6ZdFMAlH5D3cbRqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=plZSfSFJPQ3FFZIlJCos/ymTxA5ECzvr6ho6OHC6aXXx56DN4ankmOXhq9aPS84Y9
         oWopX2UNvVH5PPGrUrhGruycD9vKJkUReA7lKDXSCupPfi1FVotuvaTVxK/F8WO1a0
         KB8xW+3dBIhkQiWrG+9sspO01koh8rnPeTdhsKz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Zhu <James.Zhu@amd.com>,
        Leo Liu <leo.liu@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 032/177] drm/amdgpu/vcn2.0: add cancel_delayed_work_sync before power gate
Date:   Mon, 31 May 2021 15:13:09 +0200
Message-Id: <20210531130649.034675421@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
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
@@ -293,6 +293,8 @@ static int vcn_v2_0_hw_fini(void *handle
 	struct amdgpu_ring *ring = &adev->vcn.inst->ring_dec;
 	int i;
 
+	cancel_delayed_work_sync(&adev->vcn.idle_work);
+
 	if ((adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG) ||
 	    (adev->vcn.cur_state != AMD_PG_STATE_GATE &&
 	      RREG32_SOC15(VCN, 0, mmUVD_STATUS)))


