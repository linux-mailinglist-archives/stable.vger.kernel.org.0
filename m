Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B085B35C07B
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239902AbhDLJNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:13:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240472AbhDLJKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E45461356;
        Mon, 12 Apr 2021 09:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218344;
        bh=JNvWAmtHSnkOxNZ4UtEVIm+druCrHLCnIH8U8MUn8zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/zEkzXVRatNIc70lPhbrZPSWnPAwAq0PTfhYOMNL3P9oZgJr7O/oFOTDpibXro42
         TP1I5CAkpXIPa5qhLyyt5zKshLRUkplt6vU8ZWB65ErAOYOKbOAW3NQ4b/3SzrNNPp
         5HkBDXVOh9qdint/IH4zUCO7nfG2LlGbdBPCe6po=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Kalyan Thota <kalyan_t@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 161/210] drm/msm/disp/dpu1: program 3d_merge only if block is attached
Date:   Mon, 12 Apr 2021 10:41:06 +0200
Message-Id: <20210412084021.389542114@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kalyan Thota <kalyan_t@codeaurora.org>

[ Upstream commit 12aca1ce9ee33af3751aec5e55a5900747cbdd4b ]

Update the 3d merge as active in the data path only if
the hw block is selected in the configuration.

Reported-by: Stephen Boyd <swboyd@chromium.org>
Fixes: 73bfb790ac78 ("msm:disp:dpu1: setup display datapath for SC7180 target")
Signed-off-by: Kalyan Thota <kalyan_t@codeaurora.org>
Message-Id: <1617364493-13518-1-git-send-email-kalyan_t@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
index 8981cfa9dbc3..92e6f1b94738 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
@@ -496,7 +496,9 @@ static void dpu_hw_ctl_intf_cfg_v1(struct dpu_hw_ctl *ctx,
 
 	DPU_REG_WRITE(c, CTL_TOP, mode_sel);
 	DPU_REG_WRITE(c, CTL_INTF_ACTIVE, intf_active);
-	DPU_REG_WRITE(c, CTL_MERGE_3D_ACTIVE, BIT(cfg->merge_3d - MERGE_3D_0));
+	if (cfg->merge_3d)
+		DPU_REG_WRITE(c, CTL_MERGE_3D_ACTIVE,
+			      BIT(cfg->merge_3d - MERGE_3D_0));
 }
 
 static void dpu_hw_ctl_intf_cfg(struct dpu_hw_ctl *ctx,
-- 
2.30.2



