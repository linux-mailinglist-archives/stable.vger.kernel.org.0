Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36460797CE
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390051AbfG2TqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:46:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390067AbfG2TqG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:46:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C28021773;
        Mon, 29 Jul 2019 19:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429565;
        bh=jL6soxADRzGMY10b5XUC2QT0RohrDKfEA6oRGfMtswo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vadi5+i824bC8P9w3w/xPw0SB0yo4D4Fji+zBxs7l1JlR2BuHm4LBtZcbzX+nE/YL
         wN0PQSS9kmxSNPnHjDGssFhI26pCC+jdOuCJ/Rc7wcQnGvu3Y+yC/cVkO0tnyGXfC3
         tLYf0TjzktbQBHEUSr9cp1KPR8AwAfQ5mazU0Vd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Li <Roman.Li@amd.com>,
        David Francis <David.Francis@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 024/215] drm/amd/display: Fill plane attrs only for valid pxl format
Date:   Mon, 29 Jul 2019 21:20:20 +0200
Message-Id: <20190729190744.105634175@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1894478ad1f8fd7366edc5cee49ee9caea0e3d52 ]

[Why]
In fill_plane_buffer_attributes() we calculate chroma/luma
assuming that the surface_pixel_format is always valid.
If it's not the case, there's a risk of divide by zero error.

[How]
Check if format valid before calculating pixel format attributes

Signed-off-by: Roman Li <Roman.Li@amd.com>
Reviewed-by: David Francis <David.Francis@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index fa268dd736f4..31530bfd002a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2592,7 +2592,7 @@ fill_plane_buffer_attributes(struct amdgpu_device *adev,
 		address->type = PLN_ADDR_TYPE_GRAPHICS;
 		address->grph.addr.low_part = lower_32_bits(afb->address);
 		address->grph.addr.high_part = upper_32_bits(afb->address);
-	} else {
+	} else if (format < SURFACE_PIXEL_FORMAT_INVALID) {
 		uint64_t chroma_addr = afb->address + fb->offsets[1];
 
 		plane_size->video.luma_size.x = 0;
-- 
2.20.1



