Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E1734DB0E
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbhC2WZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:25:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232500AbhC2WXY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:23:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A12D5619B7;
        Mon, 29 Mar 2021 22:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056595;
        bh=pBBuvBTZtbmZfB/oWbI8EhWsEQnRW5Nji6Ab6fnd3oU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=We3K3//UK6jPDUXNGb21QYfnjUWXCrGikav3I4kagHiijLZP/UGbUfuT9jccYPf46
         pbsJbVWnXEuPs7lEyju4FM93W9NUEtA3mpFEF0zepWeTvlZYeXqky2GAobbEK7rHAS
         fEP+Sira31kHjRsiexlIF3elFtZd5R68B13q1aJiFwWEbIJD93kVJwrjSMOmpkOra8
         N3LtKV7cwgAegQHhmvHOOWFwy1D/YPRXUpNiPeRh4P/K7Z/rJo9WkMuyL8UpgVmNTB
         r5p5WHZihiAqZw6q2FzoG6i6yRD+GpCzow1B7Lch6BB5z300CBEXIwnF/6SFTkxSGn
         btop3e0pTy+Ew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konrad Dybcio <konrad.dybcio@somainline.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 10/19] drm/msm/adreno: a5xx_power: Don't apply A540 lm_setup to other GPUs
Date:   Mon, 29 Mar 2021 18:22:53 -0400
Message-Id: <20210329222303.2383319-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222303.2383319-1-sashal@kernel.org>
References: <20210329222303.2383319-1-sashal@kernel.org>
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
index a3a06db675ba..ee3ff32da004 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_power.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_power.c
@@ -300,7 +300,7 @@ int a5xx_power_init(struct msm_gpu *gpu)
 	/* Set up the limits management */
 	if (adreno_is_a530(adreno_gpu))
 		a530_lm_setup(gpu);
-	else
+	else if (adreno_is_a540(adreno_gpu))
 		a540_lm_setup(gpu);
 
 	/* Set up SP/TP power collpase */
-- 
2.30.1

