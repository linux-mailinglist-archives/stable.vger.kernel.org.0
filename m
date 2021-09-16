Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8CC340E324
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243481AbhIPQpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:45:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343662AbhIPQnb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:43:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E0B061A51;
        Thu, 16 Sep 2021 16:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809507;
        bh=QPnP8Y83eXrqB45XfSTnst6zMUhMxU7dGsBKRkwtUKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RXNGtmsrHB+DlPWMYDMojhiQV7sLEhDFXzw7qoFVLznH60tVoMgM4c+vSoQMAqwRl
         FhnmbddxUuLIrtYq9kQTeT13z4eYsWJkEvMQ8SbGmfTpDQ+q4f7pIkIXyKbATfuWL1
         /twUTSEAJe3izlXdb7SUIE5O/TgCyYD0T9YD68xM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 148/380] media: ti-vpe: cal: fix queuing of the initial buffer
Date:   Thu, 16 Sep 2021 17:58:25 +0200
Message-Id: <20210916155809.096006550@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



