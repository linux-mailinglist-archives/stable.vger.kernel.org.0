Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E6236AEB6
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbhDZHqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:46:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234053AbhDZHoo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:44:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1CFC613D4;
        Mon, 26 Apr 2021 07:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422872;
        bh=qDtypRcv1Fc1bOLt8ewwZf24VMfxi79LaWcx+kbuuk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vjoUzhz28B8o3jqQ/xdvdZ9fboKcW0G+L+xMJEErVy/iU0y4QnOgYjaMxiHbkTN3u
         C9n69Sl063MME7//rRG3i0bPCTqTm8vwjle6M3DoOgiP8Tw7JnilLo3se94muj53tu
         uOSdKv4pmytCyMUNCbWEcUMK2c19ZdMwy5V1l/jM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Ser <contact@emersion.fr>,
        Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <hwentlan@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Subject: [PATCH 5.11 04/41] amd/display: allow non-linear multi-planar formats
Date:   Mon, 26 Apr 2021 09:29:51 +0200
Message-Id: <20210426072819.834829187@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.666570770@linuxfoundation.org>
References: <20210426072819.666570770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Ser <contact@emersion.fr>

commit 9ebb6bc0125dfb1e65a53eea4aeecc63d4d6ec2d upstream.

Accept non-linear buffers which use a multi-planar format, as long
as they don't use DCC.

Tested on GFX9 with NV12.

Signed-off-by: Simon Ser <contact@emersion.fr>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Harry Wentland <hwentlan@amd.com>
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Cc: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Reviewed-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3963,13 +3963,6 @@ static bool dm_plane_format_mod_supporte
 		return true;
 
 	/*
-	 * The arbitrary tiling support for multiplane formats has not been hooked
-	 * up.
-	 */
-	if (info->num_planes > 1)
-		return false;
-
-	/*
 	 * For D swizzle the canonical modifier depends on the bpp, so check
 	 * it here.
 	 */
@@ -3987,6 +3980,10 @@ static bool dm_plane_format_mod_supporte
 		/* Per radeonsi comments 16/64 bpp are more complicated. */
 		if (info->cpp[0] != 4)
 			return false;
+		/* We support multi-planar formats, but not when combined with
+		 * additional DCC metadata planes. */
+		if (info->num_planes > 1)
+			return false;
 	}
 
 	return true;


