Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C83C9105
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 20:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbfJBSmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 14:42:31 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46246 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbfJBSmb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 14:42:31 -0400
Received: by mail-qt1-f194.google.com with SMTP id u22so27674245qtq.13
        for <stable@vger.kernel.org>; Wed, 02 Oct 2019 11:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jDEfyJe/+Xzb1tTUypU7kCnECbzCT53z4V2HxbRyVPk=;
        b=tLk7LiDA/ohqrF/e5hFobD5L6Pi4wH7uK9u41P9b3L827Iyxur0G9KNCuwQfyEOBz0
         dcWGyQPkRipTTUneLQqQPCeIZMuz67F94jdNoyHXEctSp3XOlgrPrKsVXs3p6Ke+KUSp
         K1VOG8lyTOpF/3pwe5TI2Iq683TSXXuofK4HGNIFcp0TdIwc1bmjO4a53qQKIfkRDzc1
         1qo6vZfZcCk+vpEyvW7H7w8gGPA6OEhORCsPrVAuM34u/lbC8rofFF0UpqqbdAvghyCI
         pun5do8q7S63Q5Q5rxDvZ9fqi58oWnD2r87PebRtHX201E7c9eU14K5lwiwfanI8IgmD
         +BUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jDEfyJe/+Xzb1tTUypU7kCnECbzCT53z4V2HxbRyVPk=;
        b=Uo98ZPlT9NnWpxDyy8plHNnULEZmIld4Q8n/xlPTRCXETyYhMEYy97cq6ZzlbPZuO3
         Z2AynqGQ9RdaMRrVu38f/by2Sln5Sj+nK6iW3lVSuAq+fVIextKe8k/OgrHY8DEf9KCf
         jyK2esUoDmqpwebMSOZtWSj0YUhrpF0JcqZghI77VP4ZYUlFKtK3slWhSW7xkVM917bP
         L5Nc7c4NPIG3eHyq5zoyEh79K3Hb+KCUQ9q228H+XZi9IeT69+ugzVLKUwEGrpboE246
         QxMRY4tOv2/KoH5YUb8w/dKrYiln3n1fV/WyNoJDtyW15tmPSvUybCWOLbPnirzNjjUc
         1pkQ==
X-Gm-Message-State: APjAAAWqhzpavDjNfdtfW9t5ZRhmBXAFp4+QZAE6dBPrI53qypfUPJu3
        rk5cf1PmhvBQiDL7OdUgAlsvvALv
X-Google-Smtp-Source: APXvYqy4CvmcjUhpOEahi2I/R1ZcYWdrDhI2IWD7Rka27TSVPEvVmk7etbatDE4AJjT3Dgj0Pu1N8g==
X-Received: by 2002:ac8:3512:: with SMTP id y18mr5710797qtb.12.1570041750128;
        Wed, 02 Oct 2019 11:42:30 -0700 (PDT)
Received: from localhost.localdomain ([71.219.73.178])
        by smtp.gmail.com with ESMTPSA id n125sm1178qkn.129.2019.10.02.11.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 11:42:29 -0700 (PDT)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <harry.wentland@amd.com>
Subject: [PATCH 3/3] drm/amdgpu/display: fix 64 bit divide
Date:   Wed,  2 Oct 2019 13:42:19 -0500
Message-Id: <20191002184219.4011-4-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191002184219.4011-1-alexander.deucher@amd.com>
References: <20191002184219.4011-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use proper helper for 32 bit.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit dd9212a885ca4a95443905c7c3781122a4d664e8)
cc: stable@vger.kernel.org # 5.3.x
---
 .../gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c    | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c
index 36277bca0326..b1e657e137a9 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c
@@ -197,7 +197,9 @@ void dce11_pplib_apply_display_requirements(
 	 */
 	if (ASICREV_IS_VEGA20_P(dc->ctx->asic_id.hw_internal_rev) && (context->stream_count >= 2)) {
 		pp_display_cfg->min_memory_clock_khz = max(pp_display_cfg->min_memory_clock_khz,
-			(uint32_t) (dc->bw_vbios->high_yclk.value / memory_type_multiplier / 10000));
+							   (uint32_t) div64_s64(
+								   div64_s64(dc->bw_vbios->high_yclk.value,
+									     memory_type_multiplier), 10000));
 	} else {
 		pp_display_cfg->min_memory_clock_khz = context->bw_ctx.bw.dce.yclk_khz
 			/ memory_type_multiplier;
-- 
2.20.1

