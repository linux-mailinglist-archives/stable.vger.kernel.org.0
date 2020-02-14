Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9D315DEB2
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389598AbgBNQEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:04:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390004AbgBNQEq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:04:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 582EA2468C;
        Fri, 14 Feb 2020 16:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696286;
        bh=qnNKeNETau8gHGTsokCrvFuo+87OEkjQVC6rGRGTBTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2faVO4YvigAqzOyA0XWCdUTuUlCyU745LU8Qu61sgPTvByDPG/anrgiCFDvn+4EzX
         jNJksayV2Os6QMz0Nu+TdYGyxIR+eraScTcdkQOKH7QtoyE+qdGsQIzEtmKBtbtWUV
         X7oWdNkMnrPOYFDtY5mymhPyU44izkclwl78VJ/E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhengbin <zhengbin13@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 134/459] drm/gma500: remove set but not used variable 'channel_eq'
Date:   Fri, 14 Feb 2020 10:56:24 -0500
Message-Id: <20200214160149.11681-134-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>

[ Upstream commit a7adabeece570b8a566dd592219410456676796e ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/gpu/drm/gma500/cdv_intel_dp.c: In function cdv_intel_dp_complete_link_train:
drivers/gpu/drm/gma500/cdv_intel_dp.c:1596:7: warning: variable channel_eq set but not used [-Wunused-but-set-variable]

It is never used, so remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/1573902268-117518-1-git-send-email-zhengbin13@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/gma500/cdv_intel_dp.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/gma500/cdv_intel_dp.c b/drivers/gpu/drm/gma500/cdv_intel_dp.c
index 570b59520fd13..5772b2dce0d66 100644
--- a/drivers/gpu/drm/gma500/cdv_intel_dp.c
+++ b/drivers/gpu/drm/gma500/cdv_intel_dp.c
@@ -1594,7 +1594,6 @@ cdv_intel_dp_complete_link_train(struct gma_encoder *encoder)
 {
 	struct drm_device *dev = encoder->base.dev;
 	struct cdv_intel_dp *intel_dp = encoder->dev_priv;
-	bool channel_eq = false;
 	int tries, cr_tries;
 	u32 reg;
 	uint32_t DP = intel_dp->DP;
@@ -1602,7 +1601,6 @@ cdv_intel_dp_complete_link_train(struct gma_encoder *encoder)
 	/* channel equalization */
 	tries = 0;
 	cr_tries = 0;
-	channel_eq = false;
 
 	DRM_DEBUG_KMS("\n");
 		reg = DP | DP_LINK_TRAIN_PAT_2;
@@ -1648,7 +1646,6 @@ cdv_intel_dp_complete_link_train(struct gma_encoder *encoder)
 
 		if (cdv_intel_channel_eq_ok(encoder)) {
 			DRM_DEBUG_KMS("PT2 train is done\n");
-			channel_eq = true;
 			break;
 		}
 
-- 
2.20.1

