Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB842F329
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730485AbfE3E0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:26:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729091AbfE3DO0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:14:26 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27F792455E;
        Thu, 30 May 2019 03:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186066;
        bh=R7gNaj25tdMNC35+ZV7CjRrC2yT1q62O8mLOlnMZwfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GeoYXm70B+hMwYS2ZzxOsNjgHYXJo/5MP8ObwQCDSokdAQHY+hfHv/v/jqR4tvLZb
         oe3HcGiBJJQbwXAyRijqQaOYC62QtXq2NM35MYRqyjxg/5K76ae7fqIwDSj2lqsKqT
         AQgdhmtip5CTddW4WHpjncHTj4zO1s8trtQ7/9IE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fritz Koenig <frkoenig@google.com>,
        Sean Paul <seanpaul@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 159/346] drm/msm: dpu: Dont set frame_busy_mask for async updates
Date:   Wed, 29 May 2019 20:03:52 -0700
Message-Id: <20190530030549.230649152@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f98baa3109cea46083d2361ab14a0207d1b1bd16 ]

The frame_busy mask is used in frame_done event handling, which is not
invoked for async commits. So an async commit will leave the
frame_busy mask populated after it completes and future commits will start
with the busy mask incorrect.

This showed up on disable after cursor move. I was hitting the "this should
not happen" comment in the frame event worker since frame_busy was set,
we queued the event, but there were no frames pending (since async
also doesn't set that).

Reviewed-by: Fritz Koenig <frkoenig@google.com>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190130163220.138637-1-sean@poorly.run
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 57ac94d80bde1..1aea0fc894b26 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -1561,8 +1561,14 @@ static void _dpu_encoder_kickoff_phys(struct dpu_encoder_virt *dpu_enc,
 		if (!ctl)
 			continue;
 
-		if (phys->split_role != ENC_ROLE_SLAVE)
+		/*
+		 * This is cleared in frame_done worker, which isn't invoked
+		 * for async commits. So don't set this for async, since it'll
+		 * roll over to the next commit.
+		 */
+		if (!async && phys->split_role != ENC_ROLE_SLAVE)
 			set_bit(i, dpu_enc->frame_busy_mask);
+
 		if (!phys->ops.needs_single_flush ||
 				!phys->ops.needs_single_flush(phys))
 			_dpu_encoder_trigger_flush(&dpu_enc->base, phys, 0x0,
-- 
2.20.1



