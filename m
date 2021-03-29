Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8AD34DABA
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbhC2WXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:23:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232174AbhC2WWk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:22:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2E0961989;
        Mon, 29 Mar 2021 22:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056559;
        bh=CLrg/mkHgEwMzrCgt4Zvz98xos31jfskRlbZx3TLzJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tFjhI/BwUpyP29HqR7PjDADmhzmxS3wOPLzyjYDOq14er1m2eAqh8JZ9yJrUji3zl
         Qs+98yrPeOQs7+dptSO/V3uop63M0gJHWU7L+YvUEh5RPYAVPc9d7LfN/pUBDIMPNz
         Aa9/FtpI/Gt6fe3khVdSCAuOH+ZXAVTKMt5Unp+zMgyQc7DgsepBGRdDWsAtS0MqTI
         N0mhrDTJCIPkoRFDoGtEa9vz+uxQrTPs9KTgwMA0RIM2an/sudPQ0V1+nIROs4gPE9
         YIyukNddVXped/NRcvaYweVSpB0v86kNFrhF3CY5NLFBIRw5dQp9PwMNQdIGmxPUlA
         6e1OJmgG7Im2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konrad Dybcio <konrad.dybcio@somainline.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 14/33] drm/msm/adreno: a5xx_power: Don't apply A540 lm_setup to other GPUs
Date:   Mon, 29 Mar 2021 18:22:02 -0400
Message-Id: <20210329222222.2382987-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222222.2382987-1-sashal@kernel.org>
References: <20210329222222.2382987-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit 4a9d36b0610aa7034340e976652e5b43320dd7c5 ]

While passing the A530-specific lm_setup func to A530 and A540
to !A530 was fine back when only these two were supported, it
certainly is not a good idea to send A540 specifics to smaller
GPUs like A508 and friends.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_power.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_power.c b/drivers/gpu/drm/msm/adreno/a5xx_power.c
index f176a6f3eff6..e58670a61df4 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_power.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_power.c
@@ -304,7 +304,7 @@ int a5xx_power_init(struct msm_gpu *gpu)
 	/* Set up the limits management */
 	if (adreno_is_a530(adreno_gpu))
 		a530_lm_setup(gpu);
-	else
+	else if (adreno_is_a540(adreno_gpu))
 		a540_lm_setup(gpu);
 
 	/* Set up SP/TP power collpase */
-- 
2.30.1

