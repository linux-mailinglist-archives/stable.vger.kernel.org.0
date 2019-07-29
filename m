Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E351879403
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbfG2T0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:26:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729831AbfG2T0w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:26:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1F2421655;
        Mon, 29 Jul 2019 19:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428411;
        bh=Th9uGvkZvs6hjOlKwzt2L5qfRyOhG8Rf+28gOkDNjkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3H1LbPvyScFHRzq2Fb5bo5bWA0dbPQsalaw2jh1EZ6Gf7MT6fq99VFpY0XXPyNBW
         58D1RTpUaerT1rNMY1czmtHLcLXzNWNRQHEz5/Yy1xaOUmIUeQtHTUE2TGW/JScebn
         j+3ORTWLQNJifLPEIdgU2/nk2Vd9KbODVs42S6Ak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>,
        Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 068/293] media: coda: fix last buffer handling in V4L2_ENC_CMD_STOP
Date:   Mon, 29 Jul 2019 21:19:19 +0200
Message-Id: <20190729190829.876691158@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f3775f89852d167990b0d718587774cf00d22ac2 ]

coda_encoder_cmd() is racy, as the last scheduled picture run worker can
still be in-flight while the ENC_CMD_STOP command is issued. Depending
on the exact timing the sequence numbers might already be changed, but
the last buffer might not have been put on the destination queue yet.

In this case the current implementation would prematurely wake the
destination queue with last_buffer_dequeued=true, causing userspace to
call streamoff before the last buffer is handled.

Close this race window by synchronizing with the pic_run_worker before
doing the sequence check.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
[l.stach@pengutronix.de: switch to flush_work, reword commit message]
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/coda/coda-common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 2e1472fadc2c..5b87c488ee11 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -932,6 +932,8 @@ static int coda_encoder_cmd(struct file *file, void *fh,
 	/* Set the stream-end flag on this context */
 	ctx->bit_stream_param |= CODA_BIT_STREAM_END_FLAG;
 
+	flush_work(&ctx->pic_run_work);
+
 	/* If there is no buffer in flight, wake up */
 	if (!ctx->streamon_out || ctx->qsequence == ctx->osequence) {
 		dst_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
-- 
2.20.1



