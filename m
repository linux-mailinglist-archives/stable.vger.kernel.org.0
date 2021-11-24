Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712C745C03A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347466AbhKXNFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:05:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348098AbhKXNDz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:03:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D967161A6D;
        Wed, 24 Nov 2021 12:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757415;
        bh=haTjemUGBbmDHxAEYNtFK+ZwVaeEI16tWXfR+8w+67A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vFSIW8MESov8ImYLgOFIgGjy5U8iRd29vBUCmx1fIi8T0Oby4BaNhgUoouF/LOdJC
         ruF48sZvrst4lbsVOnF6D/CA8MUkxFlvmnPdQvQr5VHKXbbwOajasn8XNbKYE9LNh5
         18ptgOBkKFZUm1ukc3QXYXwyzYbyXMWgBhsTmMGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jessica Zhang <jesszhan@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 161/323] drm/msm: Fix potential NULL dereference in DPU SSPP
Date:   Wed, 24 Nov 2021 12:55:51 +0100
Message-Id: <20211124115724.365031407@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jessica Zhang <jesszhan@codeaurora.org>

[ Upstream commit 8bf71a5719b6cc5b6ba358096081e5d50ea23ab6 ]

Move initialization of sblk in _sspp_subblk_offset() after NULL check to
avoid potential NULL pointer dereference.

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jessica Zhang <jesszhan@codeaurora.org>
Link: https://lore.kernel.org/r/20211020175733.3379-1-jesszhan@codeaurora.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_sspp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_sspp.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_sspp.c
index c25b52a6b2198..7db24e9df4b9b 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_sspp.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_sspp.c
@@ -146,11 +146,13 @@ static inline int _sspp_subblk_offset(struct dpu_hw_pipe *ctx,
 		u32 *idx)
 {
 	int rc = 0;
-	const struct dpu_sspp_sub_blks *sblk = ctx->cap->sblk;
+	const struct dpu_sspp_sub_blks *sblk;
 
-	if (!ctx)
+	if (!ctx || !ctx->cap || !ctx->cap->sblk)
 		return -EINVAL;
 
+	sblk = ctx->cap->sblk;
+
 	switch (s_id) {
 	case DPU_SSPP_SRC:
 		*idx = sblk->src_blk.base;
@@ -413,7 +415,7 @@ static void _dpu_hw_sspp_setup_scaler3(struct dpu_hw_pipe *ctx,
 
 	(void)pe;
 	if (_sspp_subblk_offset(ctx, DPU_SSPP_SCALER_QSEED3, &idx) || !sspp
-		|| !scaler3_cfg || !ctx || !ctx->cap || !ctx->cap->sblk)
+		|| !scaler3_cfg)
 		return;
 
 	dpu_hw_setup_scaler3(&ctx->hw, scaler3_cfg, idx,
-- 
2.33.0



