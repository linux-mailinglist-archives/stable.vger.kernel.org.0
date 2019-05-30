Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F00B42EB37
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbfE3DKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727938AbfE3DKu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:50 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 767F22446F;
        Thu, 30 May 2019 03:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185850;
        bh=z47ewOIx6lh8ydSDTqvG371ItFGOUb8dnu3r35XEom8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ON8qt6oLL7iQ0RwQxUYjIYUUZQahSsSGj7jSMwa0BtvxVHGewrwl8cUuc0hLJ/vqr
         QyD/M92sXQbMSQZmGgOv1XepR07wGPkLJYn7OeM+d1PFivw6FEj4s4AwgDOMdnmL7I
         HcKEXZR6OkCJw+ZxkCf4xySP8xJkGN3ILJjLErbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fritz Koenig <frkoenig@google.com>,
        Sean Paul <seanpaul@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 174/405] drm/msm: dpu: Dont set frame_busy_mask for async updates
Date:   Wed, 29 May 2019 20:02:52 -0700
Message-Id: <20190530030549.924022850@linuxfoundation.org>
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
index f59c00191a2a2..dd2c4d11d0e1d 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -1550,8 +1550,14 @@ static void _dpu_encoder_kickoff_phys(struct dpu_encoder_virt *dpu_enc,
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



