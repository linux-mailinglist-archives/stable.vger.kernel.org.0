Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D61CC8D922
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729548AbfHNRF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:05:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729527AbfHNRF4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:05:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64D7D214DA;
        Wed, 14 Aug 2019 17:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802355;
        bh=iOVV75qfNB+FO1DfAKwsWE0RLJR3ayMmQo+knBbA83Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WuaRVRxA5Q39yC3gwB0HyaJbO6Nlj7FPercxuLtAAVs3MwsD5UEfY84SCM4jvKpRo
         beFtaNwxwrdj7IFUVQT9487TlpTN6X6dRpy/vlI4PIGeecKR/uazAZWXbZT4PcsXyR
         aQQKQGMcF0mC8Dyf/jIbQggzBYIoOmzIFFIDRddc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shubhashree Dhar <dhar@codeaurora.org>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 086/144] drm/msm/dpu: Correct dpu encoder spinlock initialization
Date:   Wed, 14 Aug 2019 19:00:42 +0200
Message-Id: <20190814165803.474520635@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



