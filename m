Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 958E4147F34
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733212AbgAXLA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:00:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:59960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733185AbgAXLA2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:00:28 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CC822075D;
        Fri, 24 Jan 2020 11:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863628;
        bh=f65VTPO8u6bQ5GHMkJCZvDMOveFCx/y9+niTtYoiPO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OhNagVxlH+1PZF7ffhy/RLbGec5S+zWzlpIP/Um0+M6QtNwD4nVbHhRMto3uh+QYo
         3iGGm3k7kv9F/QM3MqjNTgIPSJ5rzmXKqKd40xGtCNL5Bmrgqx2AUFRCniNVfTLRgX
         dj05rGU/kR3OR3xLlVUVBdYcmI2ohZZtagjtyWyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Rob Clark <robdclark@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 044/639] drm/msm: fix unsigned comparison with less than zero
Date:   Fri, 24 Jan 2020 10:23:34 +0100
Message-Id: <20200124093052.956743211@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 06be7cf7ce505..79bafea663542 100644
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



