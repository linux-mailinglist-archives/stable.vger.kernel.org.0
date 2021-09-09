Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D842404DF4
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346884AbhIIMHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:07:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346080AbhIIMDG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:03:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A00C260041;
        Thu,  9 Sep 2021 11:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188009;
        bh=QPnP8Y83eXrqB45XfSTnst6zMUhMxU7dGsBKRkwtUKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCFkZrPLjJvJYvwiJbbr9P80KfhB0yEgBVgzO39wBKRnVc/dP5OX2n7pmtCT2L/FV
         iXn3LxOYuQgCYh6rOcCjgXW5/K7T3VzpLUkFaXAIonauFTjMXufWiaZRYEyynoV4Zz
         m1/3rDebbXVy4fmGwlFJVM36aL2rfs8e8PVhmsD5bFLjKwd16+Jsp99/6+Vivpx05a
         cyfHEJNAWL+d+MC+VYFHWZBx59HflEMIAA7amuZgv6PUF3Jp3V6nHofYbpEfWWf4O9
         MQ/k81B1it6LSnvQc105bShhwKbSMI6ReRlVvE9koCWaxPaslSHKLNP7EOSVotAqZc
         9p3wjTmsJ0xJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 010/219] media: ti-vpe: cal: fix queuing of the initial buffer
Date:   Thu,  9 Sep 2021 07:43:06 -0400
Message-Id: <20210909114635.143983-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 892c37f8a3d673b945e951a8754695c119a2b1b0 ]

When starting streaming the driver currently programs the buffer
address to the CAL base-address register and assigns the buffer pointer
to ctx->dma.pending. This is not correct, as the buffer is not
"pending", but active, and causes the first buffer to be needlessly
written twice.

Fix this by assigning the buffer pointer to ctx->dma.active.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti-vpe/cal-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti-vpe/cal-video.c b/drivers/media/platform/ti-vpe/cal-video.c
index 7b7436a355ee..b9405f70af9f 100644
--- a/drivers/media/platform/ti-vpe/cal-video.c
+++ b/drivers/media/platform/ti-vpe/cal-video.c
@@ -694,7 +694,7 @@ static int cal_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	spin_lock_irq(&ctx->dma.lock);
 	buf = list_first_entry(&ctx->dma.queue, struct cal_buffer, list);
-	ctx->dma.pending = buf;
+	ctx->dma.active = buf;
 	list_del(&buf->list);
 	spin_unlock_irq(&ctx->dma.lock);
 
-- 
2.30.2

