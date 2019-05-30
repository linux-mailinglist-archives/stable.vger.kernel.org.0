Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58F0C2F60C
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbfE3Ewa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:52:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728244AbfE3DKt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:49 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E7BE244C4;
        Thu, 30 May 2019 03:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185849;
        bh=586UX50h3Q4BsZQ0CM1cGiV0zVjXiFeWaTgd7/PqEQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1kabqHi/630s0UkgdAW0dTMn9f3eBpMTO5ognJKO874j/3Cwe5mYGqDUWiFRjHStb
         N7Jos5cyGbUZxJod3VNreZPHPAQBjUIgRMWZEoz4YCFo4s/9I/fVabndojOxDz/kvx
         QnvycZ50dD+O8dQnjcMVOhP1jjkzPlQ6D7WRzM54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeykumar Sankaran <jsanka@codeaurora.org>,
        Sean Paul <seanpaul@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 172/405] drm/msm/dpu: release resources on modeset failure
Date:   Wed, 29 May 2019 20:02:50 -0700
Message-Id: <20190530030549.825412015@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a7fcc3237f31a4e206953bb73cf41bd429442f09 ]

release resources allocated in mode_set if any of
the hw check fails. Most of these checks are not
necessary and they will be removed in the follow up
patches with state based resource allocations.

Signed-off-by: Jeykumar Sankaran <jsanka@codeaurora.org>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/1550107156-17625-4-git-send-email-jsanka@codeaurora.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 5aa3307f3f0c5..f59c00191a2a2 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -1023,13 +1023,13 @@ static void dpu_encoder_virt_mode_set(struct drm_encoder *drm_enc,
 			if (!dpu_enc->hw_pp[i]) {
 				DPU_ERROR_ENC(dpu_enc, "no pp block assigned"
 					     "at idx: %d\n", i);
-				return;
+				goto error;
 			}
 
 			if (!hw_ctl[i]) {
 				DPU_ERROR_ENC(dpu_enc, "no ctl block assigned"
 					     "at idx: %d\n", i);
-				return;
+				goto error;
 			}
 
 			phys->hw_pp = dpu_enc->hw_pp[i];
@@ -1042,6 +1042,9 @@ static void dpu_encoder_virt_mode_set(struct drm_encoder *drm_enc,
 	}
 
 	dpu_enc->mode_set_complete = true;
+
+error:
+	dpu_rm_release(&dpu_kms->rm, drm_enc);
 }
 
 static void _dpu_encoder_virt_enable_helper(struct drm_encoder *drm_enc)
-- 
2.20.1



