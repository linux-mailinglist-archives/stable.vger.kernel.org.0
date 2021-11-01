Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69F744182D
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbhKAJpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:45:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234015AbhKAJoA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:44:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F6DC6139F;
        Mon,  1 Nov 2021 09:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758940;
        bh=4Ln4VDjJlDohGDuX+2ASHjZo2PK2pOWTErkwhRE6sOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PnuGGljdnU7GRoHsmdI5bsmCZxuz25a4DALq32wK3Crk9ZcpD+B3G/RPnz8x1Czzs
         lh4Hw8dIu6Vs4go6zZyPsRIjhGDTNfPNZpEd6LryWXB2kRBSmrQJDJW0OzfR9B627g
         hCZWWJFC4whZFoZZS1oe4+3ipjXPMySKdGgazkUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrik Jakobsson <pjakobsson@suse.de>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 047/125] drm/amdgpu: Fix even more out of bound writes from debugfs
Date:   Mon,  1 Nov 2021 10:17:00 +0100
Message-Id: <20211101082542.084293596@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>

commit 3f4e54bd312d3dafb59daf2b97ffa08abebe60f5 upstream.

CVE-2021-42327 was fixed by:

commit f23750b5b3d98653b31d4469592935ef6364ad67
Author: Thelford Williams <tdwilliamsiv@gmail.com>
Date:   Wed Oct 13 16:04:13 2021 -0400

    drm/amdgpu: fix out of bounds write

but amdgpu_dm_debugfs.c contains more of the same issue so fix the
remaining ones.

v2:
	* Add missing fix in dp_max_bpc_write (Harry Wentland)

Fixes: 918698d5c2b5 ("drm/amd/display: Return the number of bytes parsed than allocated")
Signed-off-by: Patrik Jakobsson <pjakobsson@suse.de>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c |   18 +++++++-------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -487,7 +487,7 @@ static ssize_t dp_phy_settings_write(str
 	if (!wr_buf)
 		return -ENOSPC;
 
-	if (parse_write_buffer_into_params(wr_buf, size,
+	if (parse_write_buffer_into_params(wr_buf, wr_buf_size,
 					   (long *)param, buf,
 					   max_param_num,
 					   &param_nums)) {
@@ -639,7 +639,7 @@ static ssize_t dp_phy_test_pattern_debug
 	if (!wr_buf)
 		return -ENOSPC;
 
-	if (parse_write_buffer_into_params(wr_buf, size,
+	if (parse_write_buffer_into_params(wr_buf, wr_buf_size,
 					   (long *)param, buf,
 					   max_param_num,
 					   &param_nums)) {
@@ -914,7 +914,7 @@ static ssize_t dp_dsc_passthrough_set(st
 		return -ENOSPC;
 	}
 
-	if (parse_write_buffer_into_params(wr_buf, size,
+	if (parse_write_buffer_into_params(wr_buf, wr_buf_size,
 					   &param, buf,
 					   max_param_num,
 					   &param_nums)) {
@@ -1211,7 +1211,7 @@ static ssize_t trigger_hotplug(struct fi
 		return -ENOSPC;
 	}
 
-	if (parse_write_buffer_into_params(wr_buf, size,
+	if (parse_write_buffer_into_params(wr_buf, wr_buf_size,
 						(long *)param, buf,
 						max_param_num,
 						&param_nums)) {
@@ -1396,7 +1396,7 @@ static ssize_t dp_dsc_clock_en_write(str
 		return -ENOSPC;
 	}
 
-	if (parse_write_buffer_into_params(wr_buf, size,
+	if (parse_write_buffer_into_params(wr_buf, wr_buf_size,
 					    (long *)param, buf,
 					    max_param_num,
 					    &param_nums)) {
@@ -1581,7 +1581,7 @@ static ssize_t dp_dsc_slice_width_write(
 		return -ENOSPC;
 	}
 
-	if (parse_write_buffer_into_params(wr_buf, size,
+	if (parse_write_buffer_into_params(wr_buf, wr_buf_size,
 					    (long *)param, buf,
 					    max_param_num,
 					    &param_nums)) {
@@ -1766,7 +1766,7 @@ static ssize_t dp_dsc_slice_height_write
 		return -ENOSPC;
 	}
 
-	if (parse_write_buffer_into_params(wr_buf, size,
+	if (parse_write_buffer_into_params(wr_buf, wr_buf_size,
 					    (long *)param, buf,
 					    max_param_num,
 					    &param_nums)) {
@@ -1944,7 +1944,7 @@ static ssize_t dp_dsc_bits_per_pixel_wri
 		return -ENOSPC;
 	}
 
-	if (parse_write_buffer_into_params(wr_buf, size,
+	if (parse_write_buffer_into_params(wr_buf, wr_buf_size,
 					    (long *)param, buf,
 					    max_param_num,
 					    &param_nums)) {
@@ -2382,7 +2382,7 @@ static ssize_t dp_max_bpc_write(struct f
 		return -ENOSPC;
 	}
 
-	if (parse_write_buffer_into_params(wr_buf, size,
+	if (parse_write_buffer_into_params(wr_buf, wr_buf_size,
 					   (long *)param, buf,
 					   max_param_num,
 					   &param_nums)) {


