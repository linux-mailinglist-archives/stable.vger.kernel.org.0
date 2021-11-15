Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99A145277A
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344855AbhKPCZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:25:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:50938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236856AbhKORYg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:24:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68519614C8;
        Mon, 15 Nov 2021 17:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996680;
        bh=qp45ZSFt9Bb1J9yFtgyxRTmuRcK4kg/9VrHv3nQHTS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1DvzUciEw0cXN8ogSHO9o8zIv3lmUl3nO+sUnCgsIgkYXUwLF3JlNFbW+d6Qmfk1n
         jSoquItQFrDM12E19p+/wqo5XJ9GPJrew56ud1HHebWTZ8w75y8sl41DV8btL/9Xpm
         CGnE1Xe1CHMLplYhM0bC3ZexRXYL2pXBe53Hdfno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        linux-block@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 228/355] block: ataflop: fix breakage introduced at blk-mq refactoring
Date:   Mon, 15 Nov 2021 18:02:32 +0100
Message-Id: <20211115165321.131919639@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Schmitz <schmitzmic@gmail.com>

[ Upstream commit 86d46fdaa12ae5befc16b8d73fc85a3ca0399ea6 ]

Refactoring of the Atari floppy driver when converting to blk-mq
has broken the state machine in not-so-subtle ways:

finish_fdc() must be called when operations on the floppy device
have completed. This is crucial in order to relase the ST-DMA
lock, which protects against concurrent access to the ST-DMA
controller by other drivers (some DMA related, most just related
to device register access - broken beyond compare, I know).

When rewriting the driver's old do_request() function, the fact
that finish_fdc() was called only when all queued requests had
completed appears to have been overlooked. Instead, the new
request function calls finish_fdc() immediately after the last
request has been queued. finish_fdc() executes a dummy seek after
most requests, and this overwrites the state machine's interrupt
hander that was set up to wait for completion of the read/write
request just prior. To make matters worse, finish_fdc() is called
before device interrupts are re-enabled, making certain that the
read/write interupt is missed.

Shifting the finish_fdc() call into the read/write request
completion handler ensures the driver waits for the request to
actually complete. With a queue depth of 2, we won't see long
request sequences, so calling finish_fdc() unconditionally just
adds a little overhead for the dummy seeks, and keeps the code
simple.

While we're at it, kill ataflop_commit_rqs() which does nothing
but run finish_fdc() unconditionally, again likely wiping out an
in-flight request.

Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
Fixes: 6ec3938cff95 ("ataflop: convert to blk-mq")
CC: linux-block@vger.kernel.org
CC: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Link: https://lore.kernel.org/r/20211019061321.26425-1-schmitzmic@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ataflop.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index bd7d3bb8b890b..ad4cf10749100 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -653,9 +653,6 @@ static inline void copy_buffer(void *from, void *to)
 		*p2++ = *p1++;
 }
 
-  
-  
-
 /* General Interrupt Handling */
 
 static void (*FloppyIRQHandler)( int status ) = NULL;
@@ -1225,6 +1222,7 @@ static void fd_rwsec_done1(int status)
 	}
 	else {
 		/* all sectors finished */
+		finish_fdc();
 		fd_end_request_cur(BLK_STS_OK);
 	}
 	return;
@@ -1472,15 +1470,6 @@ static void setup_req_params( int drive )
 			ReqTrack, ReqSector, (unsigned long)ReqData ));
 }
 
-static void ataflop_commit_rqs(struct blk_mq_hw_ctx *hctx)
-{
-	spin_lock_irq(&ataflop_lock);
-	atari_disable_irq(IRQ_MFP_FDC);
-	finish_fdc();
-	atari_enable_irq(IRQ_MFP_FDC);
-	spin_unlock_irq(&ataflop_lock);
-}
-
 static blk_status_t ataflop_queue_rq(struct blk_mq_hw_ctx *hctx,
 				     const struct blk_mq_queue_data *bd)
 {
@@ -1488,6 +1477,8 @@ static blk_status_t ataflop_queue_rq(struct blk_mq_hw_ctx *hctx,
 	int drive = floppy - unit;
 	int type = floppy->type;
 
+	DPRINT(("Queue request: drive %d type %d last %d\n", drive, type, bd->last));
+
 	spin_lock_irq(&ataflop_lock);
 	if (fd_request) {
 		spin_unlock_irq(&ataflop_lock);
@@ -1547,8 +1538,6 @@ static blk_status_t ataflop_queue_rq(struct blk_mq_hw_ctx *hctx,
 	setup_req_params( drive );
 	do_fd_action( drive );
 
-	if (bd->last)
-		finish_fdc();
 	atari_enable_irq( IRQ_MFP_FDC );
 
 out:
@@ -1958,7 +1947,6 @@ static const struct block_device_operations floppy_fops = {
 
 static const struct blk_mq_ops ataflop_mq_ops = {
 	.queue_rq = ataflop_queue_rq,
-	.commit_rqs = ataflop_commit_rqs,
 };
 
 static struct kobject *floppy_find(dev_t dev, int *part, void *data)
-- 
2.33.0



