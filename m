Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A9C497DE4
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 12:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237491AbiAXLZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 06:25:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49468 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237484AbiAXLZD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 06:25:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C24B46066C
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 11:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E168C340E1;
        Mon, 24 Jan 2022 11:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643023502;
        bh=nXvnT5bALSP7JRJPp9VotUxkGKXXm8MFn+/5bCWCByw=;
        h=Subject:To:Cc:From:Date:From;
        b=EPFm6t2T8X2F9dDJf1mAlD4QRqw980+sXrgjZcuFeI1pLdJxQLsH561pGKc88lLu5
         nN/MMjF+c3JbMMzMXwX8o74JzIHxIUMMyjQvDZ3BdieHGRNrcelYEma6xHPXoWlF4K
         8F2rQY+hPYBJKg4Q3wmQ6G7qNBOmkEgRiqgOAODU=
Subject: FAILED: patch "[PATCH] block: Fix fsync always failed if once failed" failed to apply to 4.19-stable tree
To:     yebin10@huawei.com, axboe@kernel.dk, ming.lei@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 12:24:59 +0100
Message-ID: <164302349921124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8a7518931baa8ea023700987f3db31cb0a80610b Mon Sep 17 00:00:00 2001
From: Ye Bin <yebin10@huawei.com>
Date: Mon, 29 Nov 2021 09:26:59 +0800
Subject: [PATCH] block: Fix fsync always failed if once failed

We do test with inject error fault base on v4.19, after test some time we found
sync /dev/sda always failed.
[root@localhost] sync /dev/sda
sync: error syncing '/dev/sda': Input/output error

scsi log as follows:
[19069.812296] sd 0:0:0:0: [sda] tag#64 Send: scmd 0x00000000d03a0b6b
[19069.812302] sd 0:0:0:0: [sda] tag#64 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
[19069.812533] sd 0:0:0:0: [sda] tag#64 Done: SUCCESS Result: hostbyte=DID_OK driverbyte=DRIVER_OK
[19069.812536] sd 0:0:0:0: [sda] tag#64 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
[19069.812539] sd 0:0:0:0: [sda] tag#64 scsi host busy 1 failed 0
[19069.812542] sd 0:0:0:0: Notifying upper driver of completion (result 0)
[19069.812546] sd 0:0:0:0: [sda] tag#64 sd_done: completed 0 of 0 bytes
[19069.812549] sd 0:0:0:0: [sda] tag#64 0 sectors total, 0 bytes done.
[19069.812564] print_req_error: I/O error, dev sda, sector 0

ftrace log as follows:
 rep-306069 [007] .... 19654.923315: block_bio_queue: 8,0 FWS 0 + 0 [rep]
 rep-306069 [007] .... 19654.923333: block_getrq: 8,0 FWS 0 + 0 [rep]
 kworker/7:1H-250   [007] .... 19654.923352: block_rq_issue: 8,0 FF 0 () 0 + 0 [kworker/7:1H]
 <idle>-0     [007] ..s. 19654.923562: block_rq_complete: 8,0 FF () 18446744073709551615 + 0 [0]
 <idle>-0     [007] d.s. 19654.923576: block_rq_complete: 8,0 WS () 0 + 0 [-5]

As 8d6996630c03 introduce 'fq->rq_status', this data only update when 'flush_rq'
reference count isn't zero. If flush request once failed and record error code
in 'fq->rq_status'. If there is no chance to update 'fq->rq_status',then do fsync
will always failed.
To address this issue reset 'fq->rq_status' after return error code to upper layer.

Fixes: 8d6996630c03("block: fix null pointer dereference in blk_mq_rq_timed_out()")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20211129012659.1553733-1-yebin10@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/blk-flush.c b/block/blk-flush.c
index fd5187a0898d..f78bb39e589e 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -242,8 +242,10 @@ static void flush_end_io(struct request *flush_rq, blk_status_t error)
 	 * avoiding use-after-free.
 	 */
 	WRITE_ONCE(flush_rq->state, MQ_RQ_IDLE);
-	if (fq->rq_status != BLK_STS_OK)
+	if (fq->rq_status != BLK_STS_OK) {
 		error = fq->rq_status;
+		fq->rq_status = BLK_STS_OK;
+	}
 
 	if (!q->elevator) {
 		flush_rq->tag = BLK_MQ_NO_TAG;

