Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA5D1FB88C
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730859AbgFPP5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:57:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732659AbgFPPzY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:55:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B78521532;
        Tue, 16 Jun 2020 15:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322924;
        bh=HYWquZViGbGdIcbesak3htJvfn2PAB/KpqgGhH9wMTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3bPteUVlKdnCT9O9Rh59KldQYFsJbYfkbqc6HgQqKRMI7dik0qiYaWIe10Ahxk+V
         yrt1Trvtl4jThpOZUkkVhksTSr8nw3DsNHrIY4xlyi2xZL6Xf6tAcTF1AOlC6lCoBq
         w8I/2OBP1X5p3XPP59Mn24osT5oQcImYHq9c+Aos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Libor Pechacek <lpechacek@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.6 156/161] block/floppy: fix contended case in floppy_queue_rq()
Date:   Tue, 16 Jun 2020 17:35:46 +0200
Message-Id: <20200616153113.776518867@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

commit 263c61581a38d0a5ad1f5f4a9143b27d68caeffd upstream.

Since the switch of floppy driver to blk-mq, the contended (fdc_busy) case
in floppy_queue_rq() is not handled correctly.

In case we reach floppy_queue_rq() with fdc_busy set (i.e. with the floppy
locked due to another request still being in-flight), we put the request
on the list of requests and return BLK_STS_OK to the block core, without
actually scheduling delayed work / doing further processing of the
request. This means that processing of this request is postponed until
another request comes and passess uncontended.

Which in some cases might actually never happen and we keep waiting
indefinitely. The simple testcase is

	for i in `seq 1 2000`; do echo -en $i '\r'; blkid --info /dev/fd0 2> /dev/null; done

run in quemu. That reliably causes blkid eventually indefinitely hanging
in __floppy_read_block_0() waiting for completion, as the BIO callback
never happens, and no further IO is ever submitted on the (non-existent)
floppy device. This was observed reliably on qemu-emulated device.

Fix that by not queuing the request in the contended case, and return
BLK_STS_RESOURCE instead, so that blk core handles the request
rescheduling and let it pass properly non-contended later.

Fixes: a9f38e1dec107a ("floppy: convert to blk-mq")
Cc: stable@vger.kernel.org
Tested-by: Libor Pechacek <lpechacek@suse.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/floppy.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -2902,17 +2902,17 @@ static blk_status_t floppy_queue_rq(stru
 		 (unsigned long long) current_req->cmd_flags))
 		return BLK_STS_IOERR;
 
-	spin_lock_irq(&floppy_lock);
-	list_add_tail(&bd->rq->queuelist, &floppy_reqs);
-	spin_unlock_irq(&floppy_lock);
-
 	if (test_and_set_bit(0, &fdc_busy)) {
 		/* fdc busy, this new request will be treated when the
 		   current one is done */
 		is_alive(__func__, "old request running");
-		return BLK_STS_OK;
+		return BLK_STS_RESOURCE;
 	}
 
+	spin_lock_irq(&floppy_lock);
+	list_add_tail(&bd->rq->queuelist, &floppy_reqs);
+	spin_unlock_irq(&floppy_lock);
+
 	command_status = FD_COMMAND_NONE;
 	__reschedule_timeout(MAXTIMEOUT, "fd_request");
 	set_fdc(0);


