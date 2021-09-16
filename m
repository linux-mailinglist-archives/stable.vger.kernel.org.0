Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEBF40E68C
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346850AbhIPRWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:22:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351987AbhIPRUI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:20:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2697E61B98;
        Thu, 16 Sep 2021 16:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810518;
        bh=c323T6Wqo3q2L7ddcaBBJ9RIMgtHs3MhyoR6BFl6Kgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fxMamucK7TAu2dFpZiFyHYdo3KPkXdLz41PYiM7jIAl935AMyMZtHi53fOUkbSNrK
         xQZR4dbxvF+h3fiXyNr/RzRan8CFhbw3V7HgrEuyjcskSoht/aTAvXJzqVDYJJoAfN
         h4Rt71sssHF4AARbKGsQ6YsDTMF+k4brJj89CtyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 171/432] media: ti-vpe: cal: fix queuing of the initial buffer
Date:   Thu, 16 Sep 2021 17:58:40 +0200
Message-Id: <20210916155816.535673741@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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
index 15fb5360cf13..552619cb81a8 100644
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



