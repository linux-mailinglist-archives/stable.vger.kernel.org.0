Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8214EF360
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349442AbiDAO4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350678AbiDAOr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:47:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7952A4BDC;
        Fri,  1 Apr 2022 07:38:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D329660A64;
        Fri,  1 Apr 2022 14:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAE3C340F2;
        Fri,  1 Apr 2022 14:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823883;
        bh=wH3EBbmfckm1JiseCGo6ZDz772vA/Pa8u6+2IRVowgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WVo9+VISM5q+b52ofYzQyE6s5z72M2oEV6dpPkSPDASEUJA8Bua2m/hpBhkIS2fsm
         x24btFgkj96cGSVTmXvvp9YCT6JDeJvLivI8BCdMpu2MykST5xFbif2LOaXBZA1HZ5
         KXs7l6CIQalygM1X23uHTjnIqGW8zNy01fU4D9fQEvU6MhbHIKfvg/a62eBZSC+l91
         YMLzxqf1C80zCUrmw9KlVTr9uq7y0JhUPSQKtEB1bMkUN0ORu2G1G5EwKQOoSUHM22
         re0LIdw/NQs5hn/SzkeB4tNipoiSViixJatvfMgF8XadpufRvE0Wrl0/acII7Tln0R
         tJxGrIDEoebMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yongzhi Liu <lyz_cs@pku.edu.cn>,
        Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, sunpeng.li@amd.com,
        Rodrigo.Siqueira@amd.com, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Wayne.Lin@amd.com, mikita.lipski@amd.com, Jerry.Zuo@amd.com,
        Anson.Jacob@amd.com, tdwilliamsiv@gmail.com,
        aurabindo.pillai@amd.com, victorchengchi.lu@amd.com,
        patrik.r.jakobsson@gmail.com, seanpaul@chromium.org,
        greenfoo@u92.eu, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 05/98] drm/amd/display: Fix memory leak
Date:   Fri,  1 Apr 2022 10:36:09 -0400
Message-Id: <20220401143742.1952163-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
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
index e94ddd5e7b63..5c9f5214bc4e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -229,8 +229,10 @@ static ssize_t dp_link_settings_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -388,8 +390,10 @@ static ssize_t dp_phy_settings_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user((*(rd_buf + result)), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -1316,8 +1320,10 @@ static ssize_t dp_dsc_clock_en_read(struct file *f, char __user *buf,
 				break;
 	}
 
-	if (!pipe_ctx)
+	if (!pipe_ctx) {
+		kfree(rd_buf);
 		return -ENXIO;
+	}
 
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
@@ -1333,8 +1339,10 @@ static ssize_t dp_dsc_clock_en_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -1503,8 +1511,10 @@ static ssize_t dp_dsc_slice_width_read(struct file *f, char __user *buf,
 				break;
 	}
 
-	if (!pipe_ctx)
+	if (!pipe_ctx) {
+		kfree(rd_buf);
 		return -ENXIO;
+	}
 
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
@@ -1520,8 +1530,10 @@ static ssize_t dp_dsc_slice_width_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -1688,8 +1700,10 @@ static ssize_t dp_dsc_slice_height_read(struct file *f, char __user *buf,
 				break;
 	}
 
-	if (!pipe_ctx)
+	if (!pipe_ctx) {
+		kfree(rd_buf);
 		return -ENXIO;
+	}
 
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
@@ -1705,8 +1719,10 @@ static ssize_t dp_dsc_slice_height_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -1869,8 +1885,10 @@ static ssize_t dp_dsc_bits_per_pixel_read(struct file *f, char __user *buf,
 				break;
 	}
 
-	if (!pipe_ctx)
+	if (!pipe_ctx) {
+		kfree(rd_buf);
 		return -ENXIO;
+	}
 
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
@@ -1886,8 +1904,10 @@ static ssize_t dp_dsc_bits_per_pixel_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -2045,8 +2065,10 @@ static ssize_t dp_dsc_pic_width_read(struct file *f, char __user *buf,
 				break;
 	}
 
-	if (!pipe_ctx)
+	if (!pipe_ctx) {
+		kfree(rd_buf);
 		return -ENXIO;
+	}
 
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
@@ -2062,8 +2084,10 @@ static ssize_t dp_dsc_pic_width_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -2102,8 +2126,10 @@ static ssize_t dp_dsc_pic_height_read(struct file *f, char __user *buf,
 				break;
 	}
 
-	if (!pipe_ctx)
+	if (!pipe_ctx) {
+		kfree(rd_buf);
 		return -ENXIO;
+	}
 
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
@@ -2119,8 +2145,10 @@ static ssize_t dp_dsc_pic_height_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -2174,8 +2202,10 @@ static ssize_t dp_dsc_chunk_size_read(struct file *f, char __user *buf,
 				break;
 	}
 
-	if (!pipe_ctx)
+	if (!pipe_ctx) {
+		kfree(rd_buf);
 		return -ENXIO;
+	}
 
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
@@ -2191,8 +2221,10 @@ static ssize_t dp_dsc_chunk_size_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -2246,8 +2278,10 @@ static ssize_t dp_dsc_slice_bpg_offset_read(struct file *f, char __user *buf,
 				break;
 	}
 
-	if (!pipe_ctx)
+	if (!pipe_ctx) {
+		kfree(rd_buf);
 		return -ENXIO;
+	}
 
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
@@ -2263,8 +2297,10 @@ static ssize_t dp_dsc_slice_bpg_offset_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -3254,8 +3290,10 @@ static ssize_t dcc_en_bits_read(
 	dc->hwss.get_dcc_en_bits(dc, dcc_en_bits);
 
 	rd_buf = kcalloc(rd_buf_size, sizeof(char), GFP_KERNEL);
-	if (!rd_buf)
+	if (!rd_buf) {
+		kfree(dcc_en_bits);
 		return -ENOMEM;
+	}
 
 	for (i = 0; i < num_pipes; i++)
 		offset += snprintf(rd_buf + offset, rd_buf_size - offset,
@@ -3268,8 +3306,10 @@ static ssize_t dcc_en_bits_read(
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

