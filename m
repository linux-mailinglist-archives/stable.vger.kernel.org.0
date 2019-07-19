Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4EFB6E02A
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfGSD5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:57:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727356AbfGSD5r (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:57:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80D6821871;
        Fri, 19 Jul 2019 03:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508666;
        bh=UJ8o40MnRa0TvyAlLFj1vsaGUepF8iH+DWh2dyqDQKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cQ3c8J9s19m9wijso+Gw3/ST3BLGkfqGzcRJdHIy4iChpRJBT01m/3eyVh8JcAUk6
         9o4T6fT0e4v4zvO7pm0BkHL6I5bAoi7S0YP9qhvVRDJygjLKpZrVGNuPjZnhBpdfqV
         ZHV899Ppj1fd6Q7BmhtCU6jDAkwhUhgwIK9SHpK4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Li <Roman.Li@amd.com>, David Francis <David.Francis@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 022/171] drm/amd/display: Fill plane attrs only for valid pxl format
Date:   Thu, 18 Jul 2019 23:54:13 -0400
Message-Id: <20190719035643.14300-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Li <Roman.Li@amd.com>

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

