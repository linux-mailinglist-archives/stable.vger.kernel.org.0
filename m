Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC5613F7DC
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732792AbgAPQzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:55:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:41000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733066AbgAPQzf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:55:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71BF22176D;
        Thu, 16 Jan 2020 16:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193735;
        bh=ivXiS/0NletdSdpGqEZ6JWiA8+PWPDz+IRO1QapDrGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1v6UBU29SX/oyp1Fn+SX21KPD4UG5aDrMwXExm8SUOAPMe8TVlHP/Am7W8CPw3fcm
         5r+7IxKRPeniSC7aNzNhiovOZAWlwtPV4ZabfkZcYXsS5eJwSF2Jp71Gvs1c3PUe03
         1Z31PiCrjCLCrv/nU1xlN+I961KHAWeT8oZ30zrE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Rob Clark <robdclark@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 027/671] drm/msm: fix unsigned comparison with less than zero
Date:   Thu, 16 Jan 2020 11:44:18 -0500
Message-Id: <20200116165502.8838-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit dfdb3be43ef1195c491e6c3760b922acb52e3575 ]

The return from the call to _mixer_stages can be a negative error
code however this is being assigned to an unsigned variable 'stages'
hence the check is always false. Fix this by making 'stages' an
int.

Detected by Coccinelle ("Unsigned expression compared with zero:
stages < 0")

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
index 06be7cf7ce50..79bafea66354 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
@@ -310,7 +310,7 @@ static void dpu_hw_ctl_setup_blendstage(struct dpu_hw_ctl *ctx,
 	u32 mixercfg = 0, mixercfg_ext = 0, mix, ext;
 	u32 mixercfg_ext2 = 0, mixercfg_ext3 = 0;
 	int i, j;
-	u8 stages;
+	int stages;
 	int pipes_per_stage;
 
 	stages = _mixer_stages(ctx->mixer_hw_caps, ctx->mixer_count, lm);
-- 
2.20.1

