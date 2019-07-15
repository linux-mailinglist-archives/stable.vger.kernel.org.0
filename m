Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCA606974F
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732760AbfGONz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:55:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732757AbfGONz5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:55:57 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4500F212F5;
        Mon, 15 Jul 2019 13:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198956;
        bh=/UwpRocLzH4/r8wShvwIlTO2lUR/CX5Blry8W7vYgz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Imq/BlmLzvGkxnC05JeyHHwpwkoVJyKKdo97GdG0QYW+jHb5kDEj85GBIeSt6cPec
         dwbssl8PMTdseTyhDjyqepIisoqBc+W8wFZDP062qMwpL0EKaSf4TskqhcXQXV/BO3
         6X4+ULsT7r8AAzhiCWicQZ8Am4ioCLqhh+XNvdfE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Felsch <m.felsch@pengutronix.de>,
        Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 152/249] media: coda: fix last buffer handling in V4L2_ENC_CMD_STOP
Date:   Mon, 15 Jul 2019 09:45:17 -0400
Message-Id: <20190715134655.4076-152-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

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
index 6238047273f2..68a585d3af91 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1024,6 +1024,8 @@ static int coda_encoder_cmd(struct file *file, void *fh,
 	/* Set the stream-end flag on this context */
 	ctx->bit_stream_param |= CODA_BIT_STREAM_END_FLAG;
 
+	flush_work(&ctx->pic_run_work);
+
 	/* If there is no buffer in flight, wake up */
 	if (!ctx->streamon_out || ctx->qsequence == ctx->osequence) {
 		dst_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
-- 
2.20.1

