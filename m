Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCCC218C13
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 17:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730370AbgGHPlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 11:41:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729858AbgGHPlU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 11:41:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 445D320786;
        Wed,  8 Jul 2020 15:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594222880;
        bh=+LpYrR59OhPiCgCI0Bz36JSXB63Ug5Bm7RsE1ZYQFX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wwWTusAX+B59vR848JVEGG/G3GVKCXLKlLQXX8ksaEXR1undr+mwNOl1XwzJ9FSNv
         VE4mR6EtV41UtdVgXDeXyZAmS6Cy63U1zhJCmYPY9Wo/QN4khMVmLD63JRpKAHm+lH
         66cp17kyHZDdFnI0l8VpX1OesE+6V0THaMlethbI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krishna Manikandan <mkrishn@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.7 02/30] drm/msm/dpu: allow initialization of encoder locks during encoder init
Date:   Wed,  8 Jul 2020 11:40:48 -0400
Message-Id: <20200708154116.3199728-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708154116.3199728-1-sashal@kernel.org>
References: <20200708154116.3199728-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krishna Manikandan <mkrishn@codeaurora.org>

[ Upstream commit 2e7ec6b5297157efabb50e5f82adc628cf90296c ]

In the current implementation, mutex initialization
for encoder mutex locks are done during encoder
setup. This can lead to scenarios where the lock
is used before it is initialized. Move mutex_init
to dpu_encoder_init to avoid this.

Signed-off-by: Krishna Manikandan <mkrishn@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index a1b79ee2bd9d5..aa5409f06e3f9 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -2126,7 +2126,6 @@ int dpu_encoder_setup(struct drm_device *dev, struct drm_encoder *enc,
 
 	dpu_enc = to_dpu_encoder_virt(enc);
 
-	mutex_init(&dpu_enc->enc_lock);
 	ret = dpu_encoder_setup_display(dpu_enc, dpu_kms, disp_info);
 	if (ret)
 		goto fail;
@@ -2141,7 +2140,6 @@ int dpu_encoder_setup(struct drm_device *dev, struct drm_encoder *enc,
 				0);
 
 
-	mutex_init(&dpu_enc->rc_lock);
 	INIT_DELAYED_WORK(&dpu_enc->delayed_off_work,
 			dpu_encoder_off_work);
 	dpu_enc->idle_timeout = IDLE_TIMEOUT;
@@ -2186,6 +2184,8 @@ struct drm_encoder *dpu_encoder_init(struct drm_device *dev,
 
 	spin_lock_init(&dpu_enc->enc_spinlock);
 	dpu_enc->enabled = false;
+	mutex_init(&dpu_enc->enc_lock);
+	mutex_init(&dpu_enc->rc_lock);
 
 	return &dpu_enc->base;
 }
-- 
2.25.1

