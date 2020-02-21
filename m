Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07AFF16783B
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgBUHsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:48:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:44056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727903AbgBUHsE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:48:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 734C9207FD;
        Fri, 21 Feb 2020 07:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271283;
        bh=5wSt0wIPpairgOjqX2Ote1SXc2lETYQtdfc1fuGY1FM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GgWnqk/HdkO67T6hWPov9TAZEul4f5pzop8ACg2x1BtdCxJ24Al5NnCXtjp1Fc3ZN
         0WYgTGsZNWxikdPBMuBcq/tNgsjA1ujRCrOn4iJbcpW6C05T+JiEuRML+hTwdCabJ1
         LcqrbknFMl+f7sF6rrQXZ46XOYRtu7GJHCL2fmGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Harry Wentland <harry.wentland@amd.com>,
        Jean Delvare <jdelvare@suse.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 106/399] drm/amdgpu/dm: Do not throw an error for a display with no audio
Date:   Fri, 21 Feb 2020 08:37:11 +0100
Message-Id: <20200221072412.729892969@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit 852a91d627e9ce849d68df9d3f5336689003bdc7 ]

An old display with no audio may not have an EDID with a CEA block, or
it may simply be too old to support audio. This is not a driver error,
so don't flag it as such.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=112140
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Jean Delvare <jdelvare@suse.de>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
index 0b401dfbe98a9..34f483ac36ca4 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -97,8 +97,6 @@ enum dc_edid_status dm_helpers_parse_edid_caps(
 			(struct edid *) edid->raw_edid);
 
 	sad_count = drm_edid_to_sad((struct edid *) edid->raw_edid, &sads);
-	if (sad_count < 0)
-		DRM_ERROR("Couldn't read SADs: %d\n", sad_count);
 	if (sad_count <= 0)
 		return result;
 
-- 
2.20.1



