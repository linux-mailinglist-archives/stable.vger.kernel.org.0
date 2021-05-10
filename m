Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D9637885B
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239194AbhEJLVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237034AbhEJLLM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65B7361581;
        Mon, 10 May 2021 11:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644790;
        bh=x9QvwcMUriwz5L2DA6a+cYKWavVW1n8+/4S4UeHFsE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gqKT9R7V9ZiJrfA3MUK0Y4qWqR8fE1Qmg+k4BsXHcTuxzt8k6uFE8o1B7BpsK0Ups
         Z2aKHCStRB3/LGxOh7K5ZWm8hslzDndoaBZFBCLROYr422ylDMiAoFZw89UgYQUl+S
         TSQ7WMiKva3X5EaTHxJJnJE5jO+5Ff9ZMdkO7yS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Akhil P Oommen <akhilpo@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 224/384] drm/msm/a6xx: Fix perfcounter oob timeout
Date:   Mon, 10 May 2021 12:20:13 +0200
Message-Id: <20210510102022.286064522@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akhil P Oommen <akhilpo@codeaurora.org>

[ Upstream commit 2fc8a92e0a22c483e749232d4f13c77a92139aa7 ]

We were not programing the correct bit while clearing the perfcounter oob.
So, clear it correctly using the new 'clear' bit. This fixes the below
error:

[drm:a6xx_gmu_set_oob] *ERROR* Timeout waiting for GMU OOB set PERFCOUNTER: 0x80000000

Signed-off-by: Akhil P Oommen <akhilpo@codeaurora.org>
Link: https://lore.kernel.org/r/1617630433-36506-1-git-send-email-akhilpo@codeaurora.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index 91cf46f84025..3d55e153fa9c 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -246,7 +246,7 @@ static int a6xx_gmu_hfi_start(struct a6xx_gmu *gmu)
 }
 
 struct a6xx_gmu_oob_bits {
-	int set, ack, set_new, ack_new;
+	int set, ack, set_new, ack_new, clear, clear_new;
 	const char *name;
 };
 
@@ -260,6 +260,8 @@ static const struct a6xx_gmu_oob_bits a6xx_gmu_oob_bits[] = {
 		.ack = 24,
 		.set_new = 30,
 		.ack_new = 31,
+		.clear = 24,
+		.clear_new = 31,
 	},
 
 	[GMU_OOB_PERFCOUNTER_SET] = {
@@ -268,18 +270,22 @@ static const struct a6xx_gmu_oob_bits a6xx_gmu_oob_bits[] = {
 		.ack = 25,
 		.set_new = 28,
 		.ack_new = 30,
+		.clear = 25,
+		.clear_new = 29,
 	},
 
 	[GMU_OOB_BOOT_SLUMBER] = {
 		.name = "BOOT_SLUMBER",
 		.set = 22,
 		.ack = 30,
+		.clear = 30,
 	},
 
 	[GMU_OOB_DCVS_SET] = {
 		.name = "GPU_DCVS",
 		.set = 23,
 		.ack = 31,
+		.clear = 31,
 	},
 };
 
@@ -335,9 +341,9 @@ void a6xx_gmu_clear_oob(struct a6xx_gmu *gmu, enum a6xx_gmu_oob_state state)
 		return;
 
 	if (gmu->legacy)
-		bit = a6xx_gmu_oob_bits[state].ack;
+		bit = a6xx_gmu_oob_bits[state].clear;
 	else
-		bit = a6xx_gmu_oob_bits[state].ack_new;
+		bit = a6xx_gmu_oob_bits[state].clear_new;
 
 	gmu_write(gmu, REG_A6XX_GMU_HOST2GMU_INTR_SET, 1 << bit);
 }
-- 
2.30.2



