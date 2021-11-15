Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF6A45113D
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243713AbhKOTCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:02:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:59656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243373AbhKOS5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:57:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 049F06348A;
        Mon, 15 Nov 2021 18:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999966;
        bh=JkJmVm8ZoAWcAvwlNM2cb7p0UHZ0HUuqm7pbgcOVThA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w5loYFmI/LqBD5d7HpjpGXGF4XpzosuBy9g6MuwtPOXjNIBlMBj9tkMnq1JwZSG4y
         8xuwugyn64OI2zEWfql4E3XuYcd6m9eYFyOIxWzBa8COtv/O7EZ6PoviT2tp3UuJqh
         4DtA93Hcli8M6n2b2zpHegoMWclSQO8GSCNer72w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jessica Zhang <jesszhan@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 488/849] drm/msm: Fix potential NULL dereference in DPU SSPP
Date:   Mon, 15 Nov 2021 17:59:31 +0100
Message-Id: <20211115165436.793388782@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 69eed79324865..f9460672176aa 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_sspp.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_sspp.c
@@ -138,11 +138,13 @@ static int _sspp_subblk_offset(struct dpu_hw_pipe *ctx,
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
@@ -419,7 +421,7 @@ static void _dpu_hw_sspp_setup_scaler3(struct dpu_hw_pipe *ctx,
 
 	(void)pe;
 	if (_sspp_subblk_offset(ctx, DPU_SSPP_SCALER_QSEED3, &idx) || !sspp
-		|| !scaler3_cfg || !ctx || !ctx->cap || !ctx->cap->sblk)
+		|| !scaler3_cfg)
 		return;
 
 	dpu_hw_setup_scaler3(&ctx->hw, scaler3_cfg, idx,
-- 
2.33.0



