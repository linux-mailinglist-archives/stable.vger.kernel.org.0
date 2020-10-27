Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB5429C2D9
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760202AbgJ0Rki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:40:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2902392AbgJ0OdG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:33:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F045C22202;
        Tue, 27 Oct 2020 14:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809185;
        bh=5H0L6513JseOI8vUgBX2DFIwpZ4pecmuOakmrXTygSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=khnSJVzIL+tUwuaHemmplOb/qU6Dh6k/BjIvsueD/SNaPhaASDb3RhLH1iSTsSlXy
         mI7uc5tMyo3C/WasRcz/DG9RvzyWkzYi26Ix6ZR2vaELlpYkwmayuSuUJopIudi9HV
         JaqXCtEd6G3pSzJ5MJ4ZWUmp6U1mWR7B9HgKhGxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Li <sunpeng.li@amd.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 106/408] drm/amd/display: Fix wrong return value in dm_update_plane_state()
Date:   Tue, 27 Oct 2020 14:50:44 +0100
Message-Id: <20201027135500.020591749@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

[ Upstream commit c35376137e940c3389df2726a92649c01a9844b4 ]

On an error exit path, a negative error code should be returned
instead of a positive return value.

Fixes: 9e869063b0021 ("drm/amd/display: Move iteration out of dm_update_planes")
Cc: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 2384aa018993d..7c58085031732 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6984,8 +6984,7 @@ static int dm_update_plane_state(struct dc *dc,
 				dm_old_plane_state->dc_state,
 				dm_state->context)) {
 
-			ret = EINVAL;
-			return ret;
+			return -EINVAL;
 		}
 
 
-- 
2.25.1



