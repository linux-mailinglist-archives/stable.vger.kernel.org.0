Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81756359AF8
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbhDIKHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:07:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233719AbhDIKDg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:03:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40DB16125F;
        Fri,  9 Apr 2021 10:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962435;
        bh=92AuBmyyIh32FCb7AW4Ia2WAaBJt828hN833PaULxe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1qgfcJyY9bYGowGv3P+k4Ren3qC06Wi4QRfyyNS8xCriYx/bnTgQQKUR1caeTaLQ0
         iTlQYc5fxf41HJuzjN/Kd4RGNdBZun19tcQF9894LV1tCm1MbvqvS3qvf6Bp+txbtJ
         imSdnvR1mC6ZM3fqx2wwjKqRG4P390eJgTz8SZSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 15/45] drm/msm/adreno: a5xx_power: Dont apply A540 lm_setup to other GPUs
Date:   Fri,  9 Apr 2021 11:53:41 +0200
Message-Id: <20210409095305.890730057@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095305.397149021@linuxfoundation.org>
References: <20210409095305.397149021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.30.2



