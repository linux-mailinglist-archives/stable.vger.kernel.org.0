Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9D94CF5C0
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235071AbiCGJbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237647AbiCGJ2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:28:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEA26AA63;
        Mon,  7 Mar 2022 01:25:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B65E2B810B9;
        Mon,  7 Mar 2022 09:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF12C340F3;
        Mon,  7 Mar 2022 09:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645145;
        bh=l/hF19ts1pVffdE2/W6xqEpFVxjmTbWSdZr2grIVloI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uEmlSwFoQ7CtG7dSTmRXKxYuR6sn5h+vmspFCJZ1eEs118uUW8DdCkyfBH2KkmuvB
         QOn0XsvQ4UCFa5zvP4s1mv8mlgEOo8SHAD35D42WzIbtgQDLss2qtxnXyB3NDAp1mp
         jW36X1CPxi+a9KP4COXhhwqmX9U6yptQ3finjUSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Bin <yebin10@huawei.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.19 29/51] block: Fix fsync always failed if once failed
Date:   Mon,  7 Mar 2022 10:19:04 +0100
Message-Id: <20220307091637.820937128@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091636.988950823@linuxfoundation.org>
References: <20220307091636.988950823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-flush.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -239,8 +239,10 @@ static void flush_end_io(struct request
 			return;
 		}
 
-		if (fq->rq_status != BLK_STS_OK)
+		if (fq->rq_status != BLK_STS_OK) {
 			error = fq->rq_status;
+			fq->rq_status = BLK_STS_OK;
+		}
 
 		hctx = blk_mq_map_queue(q, flush_rq->mq_ctx->cpu);
 		if (!q->elevator) {


