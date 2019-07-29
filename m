Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 498A2795D7
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389797AbfG2Tq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389627AbfG2Tq3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:46:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8806B205F4;
        Mon, 29 Jul 2019 19:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429588;
        bh=Rs5o3o5qUNTTGMCmzR7zw5kPElIN8kAPuvZuC5E72B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFBzVg39JrZO5bgjFYmp/WNpUZ0qMC6L2U/bKkUnoBIubm272y+TwOf8pcRNyBaey
         Se9E/McwsBHRNKaf2VhQIOXwpeqr3FuK+3/14XXUX7ui2FLQrerAwDUjxNoceHQMls
         O4JOaNVcMQFENkctlX55zhJ21xnu2neSjDIf+cWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Griffin <peter.griffin@linaro.org>,
        Rob Herring <robh@kernel.org>, Daniel Vetter <daniel@ffwll.ch>,
        Qiang Yu <yuq825@gmail.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 004/215] drm/lima: handle shared irq case for lima_pp_bcast_irq_handler
Date:   Mon, 29 Jul 2019 21:20:00 +0200
Message-Id: <20190729190740.513034682@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



