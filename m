Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3455E7F8AB
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393590AbfHBNVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:21:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393556AbfHBNVU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:21:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 001D02173E;
        Fri,  2 Aug 2019 13:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752079;
        bh=Z3+DlEgPPOfyTqSMYWiDIsaMH7bYjj3YAxmRj4cC21E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PeGbkyne4hjVzsD8BRlnd8sgaQMQeSbUTtq4sGfIRKyWWTcXCcooWt2I9XIk01dL2
         UKNjoskG0KTJgQCIB+nJFYAQY9bX6j9TuZee5Bfpq7mOVXynToHkewL4BwT7xVhsRb
         9yJ1TleS0L7/E4HScu5cs+Sb6mcMWJP2+AxOnwJg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shubhashree Dhar <dhar@codeaurora.org>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 41/76] drm/msm/dpu: Correct dpu encoder spinlock initialization
Date:   Fri,  2 Aug 2019 09:19:15 -0400
Message-Id: <20190802131951.11600-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shubhashree Dhar <dhar@codeaurora.org>

[ Upstream commit 2e7b801eadbf327bf61041c943e5c44a5de4b0e5 ]

dpu encoder spinlock should be initialized during dpu encoder
init instead of dpu encoder setup which is part of modeset init.

Signed-off-by: Shubhashree Dhar <dhar@codeaurora.org>
[seanpaul resolved conflict in old init removal and revised the commit message]
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/1561357632-15361-1-git-send-email-dhar@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 0ea1501966594..c62f7abcf509c 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -2226,8 +2226,6 @@ int dpu_encoder_setup(struct drm_device *dev, struct drm_encoder *enc,
 	if (ret)
 		goto fail;
 
-	spin_lock_init(&dpu_enc->enc_spinlock);
-
 	atomic_set(&dpu_enc->frame_done_timeout_ms, 0);
 	timer_setup(&dpu_enc->frame_done_timer,
 			dpu_encoder_frame_done_timeout, 0);
@@ -2281,6 +2279,7 @@ struct drm_encoder *dpu_encoder_init(struct drm_device *dev,
 
 	drm_encoder_helper_add(&dpu_enc->base, &dpu_encoder_helper_funcs);
 
+	spin_lock_init(&dpu_enc->enc_spinlock);
 	dpu_enc->enabled = false;
 
 	return &dpu_enc->base;
-- 
2.20.1

