Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5628F4EF0E7
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347471AbiDAOio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348000AbiDAOgu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:36:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B16E2E091;
        Fri,  1 Apr 2022 07:33:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDC48B824D5;
        Fri,  1 Apr 2022 14:33:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073C7C36AE2;
        Fri,  1 Apr 2022 14:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823601;
        bh=00QF0gLBaeOTUycH5R1/1RKFM83FIqwyf8vSFkRFLMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uu9GGU3WRZGqBcLhGgglabuFMdDwU66kG0OUH839tiCWde/aX1VgG7ENTG2rL+3G3
         exT0Dgf5ZgWuejDIE0jUj87P4k6sE2t/GIawgjlEXiII7wVCrqrUHf0wYCUc9Yw2R+
         p0dCKtsW3dQi/Oq1NDVhx9HzzY4UqMrTSX1qf/mhfYsipb8YpVjglgc5AMpvZt7P1W
         l7D/cTON+47xtD+0w6tpmZZjb9X7XPmaWrR/JplVSBJ+UDnEjs1HEF10tnkWw1wc+D
         nekjwNoq1rK1xQVvuUQBKWIurJs6fb06aqZn5iphXSab1xH56X2Z5Fb+hY6kZ0Dfik
         k1TxyKArecgDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yongzhi Liu <lyz_cs@pku.edu.cn>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, sunpeng.li@amd.com,
        Rodrigo.Siqueira@amd.com, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Wayne.Lin@amd.com, mikita.lipski@amd.com,
        Nicholas.Kazlauskas@amd.com, Jerry.Zuo@amd.com,
        Anson.Jacob@amd.com, tdwilliamsiv@gmail.com,
        aurabindo.pillai@amd.com, victorchengchi.lu@amd.com,
        patrik.r.jakobsson@gmail.com, seanpaul@chromium.org,
        greenfoo@u92.eu, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.16 008/109] drm/amd/display: Fix memory leak
Date:   Fri,  1 Apr 2022 10:31:15 -0400
Message-Id: <20220401143256.1950537-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yongzhi Liu <lyz_cs@pku.edu.cn>

[ Upstream commit 5d5c6dba2b43e28845d7d7ed32a36802329a5f52 ]

[why]
Resource release is needed on the error handling path
to prevent memory leak.

[how]
Fix this by adding kfree on the error handling path.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Yongzhi Liu <lyz_cs@pku.edu.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/amdgpu_dm/amdgpu_dm_debugfs.c | 80 ++++++++++++++-----
 1 file changed, 60 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
index f4e829ec8e10..ab58bcb11677 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -227,8 +227,10 @@ static ssize_t dp_link_settings_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -389,8 +391,10 @@ static ssize_t dp_phy_settings_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user((*(rd_buf + result)), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -1317,8 +1321,10 @@ static ssize_t dp_dsc_clock_en_read(struct file *f, char __user *buf,
 				break;
 	}
 
-	if (!pipe_ctx)
+	if (!pipe_ctx) {
+		kfree(rd_buf);
 		return -ENXIO;
+	}
 
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
@@ -1334,8 +1340,10 @@ static ssize_t dp_dsc_clock_en_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -1504,8 +1512,10 @@ static ssize_t dp_dsc_slice_width_read(struct file *f, char __user *buf,
 				break;
 	}
 
-	if (!pipe_ctx)
+	if (!pipe_ctx) {
+		kfree(rd_buf);
 		return -ENXIO;
+	}
 
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
@@ -1521,8 +1531,10 @@ static ssize_t dp_dsc_slice_width_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -1689,8 +1701,10 @@ static ssize_t dp_dsc_slice_height_read(struct file *f, char __user *buf,
 				break;
 	}
 
-	if (!pipe_ctx)
+	if (!pipe_ctx) {
+		kfree(rd_buf);
 		return -ENXIO;
+	}
 
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
@@ -1706,8 +1720,10 @@ static ssize_t dp_dsc_slice_height_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -1870,8 +1886,10 @@ static ssize_t dp_dsc_bits_per_pixel_read(struct file *f, char __user *buf,
 				break;
 	}
 
-	if (!pipe_ctx)
+	if (!pipe_ctx) {
+		kfree(rd_buf);
 		return -ENXIO;
+	}
 
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
@@ -1887,8 +1905,10 @@ static ssize_t dp_dsc_bits_per_pixel_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -2046,8 +2066,10 @@ static ssize_t dp_dsc_pic_width_read(struct file *f, char __user *buf,
 				break;
 	}
 
-	if (!pipe_ctx)
+	if (!pipe_ctx) {
+		kfree(rd_buf);
 		return -ENXIO;
+	}
 
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
@@ -2063,8 +2085,10 @@ static ssize_t dp_dsc_pic_width_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -2103,8 +2127,10 @@ static ssize_t dp_dsc_pic_height_read(struct file *f, char __user *buf,
 				break;
 	}
 
-	if (!pipe_ctx)
+	if (!pipe_ctx) {
+		kfree(rd_buf);
 		return -ENXIO;
+	}
 
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
@@ -2120,8 +2146,10 @@ static ssize_t dp_dsc_pic_height_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -2175,8 +2203,10 @@ static ssize_t dp_dsc_chunk_size_read(struct file *f, char __user *buf,
 				break;
 	}
 
-	if (!pipe_ctx)
+	if (!pipe_ctx) {
+		kfree(rd_buf);
 		return -ENXIO;
+	}
 
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
@@ -2192,8 +2222,10 @@ static ssize_t dp_dsc_chunk_size_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -2247,8 +2279,10 @@ static ssize_t dp_dsc_slice_bpg_offset_read(struct file *f, char __user *buf,
 				break;
 	}
 
-	if (!pipe_ctx)
+	if (!pipe_ctx) {
+		kfree(rd_buf);
 		return -ENXIO;
+	}
 
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
@@ -2264,8 +2298,10 @@ static ssize_t dp_dsc_slice_bpg_offset_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -3255,8 +3291,10 @@ static ssize_t dcc_en_bits_read(
 	dc->hwss.get_dcc_en_bits(dc, dcc_en_bits);
 
 	rd_buf = kcalloc(rd_buf_size, sizeof(char), GFP_KERNEL);
-	if (!rd_buf)
+	if (!rd_buf) {
+		kfree(dcc_en_bits);
 		return -ENOMEM;
+	}
 
 	for (i = 0; i < num_pipes; i++)
 		offset += snprintf(rd_buf + offset, rd_buf_size - offset,
@@ -3269,8 +3307,10 @@ static ssize_t dcc_en_bits_read(
 		if (*pos >= rd_buf_size)
 			break;
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 		buf += 1;
 		size -= 1;
 		*pos += 1;
-- 
2.34.1

