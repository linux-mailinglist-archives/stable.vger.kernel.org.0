Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB37E29B7EB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798542AbgJ0P2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:28:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798155AbgJ0P0L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:26:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CA8B20728;
        Tue, 27 Oct 2020 15:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812370;
        bh=QgWdJZNgePbsSEzN20yVh1V9PoMCz1+WSmJL9coPhpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ndX69hoEAb52C1vi5G1g54/llcKYCAXTo38M/BLSuL9/TX/W28RHjqf6xD1oTlBx9
         gmM3RUVPLqGrCC+fD3Gc1BIfE/zfXYTQjopUcCm+rn4oGesk/OliLPhU52wYZWE8at
         iv2cULMCyXE9ZAGrLzmScUQZP4XwR7U3UBJaqq88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Li <sunpeng.li@amd.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 186/757] drm/amd/display: Fix wrong return value in dm_update_plane_state()
Date:   Tue, 27 Oct 2020 14:47:16 +0100
Message-Id: <20201027135459.333545564@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index a717a4904268e..5474f7e4c75b1 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8217,8 +8217,7 @@ static int dm_update_plane_state(struct dc *dc,
 				dm_old_plane_state->dc_state,
 				dm_state->context)) {
 
-			ret = EINVAL;
-			return ret;
+			return -EINVAL;
 		}
 
 
-- 
2.25.1



