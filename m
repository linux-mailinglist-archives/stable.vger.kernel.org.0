Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10961AC400
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441681AbgDPNwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:52:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441310AbgDPNwj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:52:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C4952063A;
        Thu, 16 Apr 2020 13:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045158;
        bh=oo8k5WceXRjdNhrIZURPloY5o+v2rdHZpBp5cNa6Cy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ekLt/tsH4WlFoKZg7NNdHEqSSCCNcVaA7Gmtxo39PAjjQBVzp30D6EcVKdg/8qBxt
         dD3LaMVup6eZuZmI5269aPsh5xUQC8AEJcFgLECdL4Nc2nm7esFb7hzra4zeCFWYqN
         J7tq91r+aHAGhoPR/4tyRinUVhgzgc0aYSVOCky8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Alexey Dobriyan (SK hynix)" <adobriyan@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 021/254] null_blk: fix spurious IO errors after failed past-wp access
Date:   Thu, 16 Apr 2020 15:21:50 +0200
Message-Id: <20200416131328.465682024@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit ff77042296d0a54535ddf74412c5ae92cb4ec76a ]

Steps to reproduce:

	BLKRESETZONE zone 0

	// force EIO
	pwrite(fd, buf, 4096, 4096);

	[issue more IO including zone ioctls]

It will start failing randomly including IO to unrelated zones because of
->error "reuse". Trigger can be partition detection as well if test is not
run immediately which is even more entertaining.

The fix is of course to clear ->error where necessary.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 2b8b4cb447cfb..d6a8d66e98036 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -605,6 +605,7 @@ static struct nullb_cmd *__alloc_cmd(struct nullb_queue *nq)
 	if (tag != -1U) {
 		cmd = &nq->cmds[tag];
 		cmd->tag = tag;
+		cmd->error = BLK_STS_OK;
 		cmd->nq = nq;
 		if (nq->dev->irqmode == NULL_IRQ_TIMER) {
 			hrtimer_init(&cmd->timer, CLOCK_MONOTONIC,
@@ -1385,6 +1386,7 @@ static blk_status_t null_queue_rq(struct blk_mq_hw_ctx *hctx,
 		cmd->timer.function = null_cmd_timer_expired;
 	}
 	cmd->rq = bd->rq;
+	cmd->error = BLK_STS_OK;
 	cmd->nq = nq;
 
 	blk_mq_start_request(bd->rq);
-- 
2.20.1



