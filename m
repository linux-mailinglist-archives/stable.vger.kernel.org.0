Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA6149A91E
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322149AbiAYDVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:21:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49108 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359737AbiAXUIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:08:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FD43B810AF;
        Mon, 24 Jan 2022 20:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AAAC340E5;
        Mon, 24 Jan 2022 20:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054889;
        bh=bdl7aCB7q1AmohirLEAJ6MqG/P5xKxNKb1jA7R0d7mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZl9Xu02uyIPk9l2/znLVQkJsPUWQ6XDDT+W50wJoqZgp7z09iyS6ZcdrPqMC2cqY
         G7rEDzvRTJDxhPNfnLpgai1nMuduCzoYkWECDT17uFguxlLP0l7D40BbFB8DTras7R
         0kJpjTlbagF067sSF5/IQ+f7Y1IhnuKQRtvEd9Qs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Bin <yebin10@huawei.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 504/563] block: Fix fsync always failed if once failed
Date:   Mon, 24 Jan 2022 19:44:29 +0100
Message-Id: <20220124184041.901852878@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

commit 8a7518931baa8ea023700987f3db31cb0a80610b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-flush.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -236,8 +236,10 @@ static void flush_end_io(struct request
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


