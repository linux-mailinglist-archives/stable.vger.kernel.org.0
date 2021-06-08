Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9E33A0384
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237884AbhFHTSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:18:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236098AbhFHTQA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:16:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A08361964;
        Tue,  8 Jun 2021 18:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178255;
        bh=GtcUDaoux+cyQJqgTS8H+JezRHbXc+bM0XZNSnmBlnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KUZNO1KDH2iZ0n2k5FzdBCnlGNZt8y1meDw3T/t7pqv52Y+5K0sdl+Vvu743iBuJ/
         2tCA/K53SXOmosrlmlV+ZvtTeXfgvGwEACXMpMVo3QGs1GLexwdJ+mz3EvWmEANtsh
         hi/ERQtWJw18uzpM66STEOBZZ8tYF9Qx36NMFsGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.12 135/161] drm/amdgpu: Dont query CE and UE errors
Date:   Tue,  8 Jun 2021 20:27:45 +0200
Message-Id: <20210608175950.013630783@linuxfoundation.org>
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

From: Luben Tuikov <luben.tuikov@amd.com>

commit dce3d8e1d070900e0feeb06787a319ff9379212c upstream.

On QUERY2 IOCTL don't query counts of correctable
and uncorrectable errors, since when RAS is
enabled and supported on Vega20 server boards,
this takes insurmountably long time, in O(n^3),
which slows the system down to the point of it
being unusable when we have GUI up.

Fixes: ae363a212b14 ("drm/amdgpu: Add a new flag to AMDGPU_CTX_OP_QUERY_STATE2")
Cc: Alexander Deucher <Alexander.Deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Reviewed-by: Alexander Deucher <Alexander.Deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c |   16 ----------------
 1 file changed, 16 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
@@ -337,7 +337,6 @@ static int amdgpu_ctx_query2(struct amdg
 {
 	struct amdgpu_ctx *ctx;
 	struct amdgpu_ctx_mgr *mgr;
-	unsigned long ras_counter;
 
 	if (!fpriv)
 		return -EINVAL;
@@ -362,21 +361,6 @@ static int amdgpu_ctx_query2(struct amdg
 	if (atomic_read(&ctx->guilty))
 		out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_GUILTY;
 
-	/*query ue count*/
-	ras_counter = amdgpu_ras_query_error_count(adev, false);
-	/*ras counter is monotonic increasing*/
-	if (ras_counter != ctx->ras_counter_ue) {
-		out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_RAS_UE;
-		ctx->ras_counter_ue = ras_counter;
-	}
-
-	/*query ce count*/
-	ras_counter = amdgpu_ras_query_error_count(adev, true);
-	if (ras_counter != ctx->ras_counter_ce) {
-		out->state.flags |= AMDGPU_CTX_QUERY2_FLAGS_RAS_CE;
-		ctx->ras_counter_ce = ras_counter;
-	}
-
 	mutex_unlock(&mgr->lock);
 	return 0;
 }


