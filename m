Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14F93BCF86
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbhGFLan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232364AbhGFL22 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:28:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8410261D6A;
        Tue,  6 Jul 2021 11:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570414;
        bh=dQZVRB0s0ZaI5JuJSNJrI0CmVThru6IXPILSsXFNzc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jDXx/lmD6ldq0uDfrxY7ObOem9cVH5NnQ9ia81j6PWW4KPl3uEPyO7gDyPhHehuRI
         IiUIrGEs6x7Qcl2an3ZAVdrV5igTllhVdXLrandmiqtTHEZx092nYKViX2+0a6A2rz
         KhnDdtvH1e1PQKK2mmros92zzmpJPAmpV7QFls9BoXkS0nzt7XuNd5nH5r/fqG2t2J
         f8PgOQbWY694smVrcUy0Uo+JxJpbbcLktoC4BMajl2CT9JX6RiTSLdBB5lswDJVP3h
         SvQgtX3lWZ7v+P15ViQBf3/j0UayqSIAjPf81ljTGBiwTsBOxRPMMGCEw7f/uaVHu2
         klhB6b8VgVoFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aric Cyr <aric.cyr@amd.com>,
        Krunoslav Kovac <Krunoslav.Kovac@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 080/160] drm/amd/display: Fix crash during MPO + ODM combine mode recalculation
Date:   Tue,  6 Jul 2021 07:17:06 -0400
Message-Id: <20210706111827.2060499-80-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aric Cyr <aric.cyr@amd.com>

[ Upstream commit 665f28507a2a3d8d72ed9afa9a2b9b17fd43add1 ]

[Why]
When calculating recout width for an MPO plane on a mode that's using
ODM combine, driver can calculate a negative value, resulting in a
crash.

[How]
For negative widths, use zero such that validation will prune the
configuration correctly and disallow MPO.

Signed-off-by: Aric Cyr <aric.cyr@amd.com>
Reviewed-by: Krunoslav Kovac <Krunoslav.Kovac@amd.com>
Acked-by: Stylon Wang <stylon.wang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 325e0d656d6a..749189eb20ba 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -733,6 +733,11 @@ static void calculate_recout(struct pipe_ctx *pipe_ctx)
 			if (split_idx == split_count) {
 				/* rightmost pipe is the remainder recout */
 				data->recout.width -= data->h_active * split_count - data->recout.x;
+
+				/* ODM combine cases with MPO we can get negative widths */
+				if (data->recout.width < 0)
+					data->recout.width = 0;
+
 				data->recout.x = 0;
 			} else
 				data->recout.width = data->h_active - data->recout.x;
-- 
2.30.2

