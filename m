Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E54C6D981
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 05:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfGSD4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbfGSD4q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:56:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F11E2082E;
        Fri, 19 Jul 2019 03:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508605;
        bh=/bYiLhQ2bS9pcCsRPAJ+8A98ijnEbnaNzmUqu1Yf4og=;
        h=From:To:Cc:Subject:Date:From;
        b=VFme/5UjzcJLqJ50dGR1eQjs/VgmYIWJaMwCXIWWnrXP0l2u5Nv0Gf+E05Ra16G3e
         U+w02CX97sEPGDx9mc4K03siLpij+Ml2xkUrspEm4npxxgFlPvF9uqkSyxCIgYbPVN
         BtGdZO8qBMEtVUZPDXjCaT/lZpRkEZbF835KvLb0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Griffin <peter.griffin@linaro.org>,
        Rob Herring <robh@kernel.org>, Daniel Vetter <daniel@ffwll.ch>,
        Qiang Yu <yuq825@gmail.com>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 001/171] drm/lima: handle shared irq case for lima_pp_bcast_irq_handler
Date:   Thu, 18 Jul 2019 23:53:52 -0400
Message-Id: <20190719035643.14300-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Griffin <peter.griffin@linaro.org>

[ Upstream commit 409c53f07a81f8db122c461f3255c6f43558c881 ]

On Hikey board all lima ip blocks are shared with one irq.
This patch avoids a NULL ptr deref crash on this platform
on startup. Tested with Weston and kmscube.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Qiang Yu <yuq825@gmail.com>
Signed-off-by: Qiang Yu <yuq825@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/1555662781-22570-7-git-send-email-peter.griffin@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/lima/lima_pp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/lima/lima_pp.c b/drivers/gpu/drm/lima/lima_pp.c
index d29721e177bf..8fef224b93c8 100644
--- a/drivers/gpu/drm/lima/lima_pp.c
+++ b/drivers/gpu/drm/lima/lima_pp.c
@@ -64,7 +64,13 @@ static irqreturn_t lima_pp_bcast_irq_handler(int irq, void *data)
 	struct lima_ip *pp_bcast = data;
 	struct lima_device *dev = pp_bcast->dev;
 	struct lima_sched_pipe *pipe = dev->pipe + lima_pipe_pp;
-	struct drm_lima_m450_pp_frame *frame = pipe->current_task->frame;
+	struct drm_lima_m450_pp_frame *frame;
+
+	/* for shared irq case */
+	if (!pipe->current_task)
+		return IRQ_NONE;
+
+	frame = pipe->current_task->frame;
 
 	for (i = 0; i < frame->num_pp; i++) {
 		struct lima_ip *ip = pipe->processor[i];
-- 
2.20.1

