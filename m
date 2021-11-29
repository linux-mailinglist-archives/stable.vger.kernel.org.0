Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FED46263E
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbhK2WtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:49:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235044AbhK2Ws3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:48:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE46C1E0FC4;
        Mon, 29 Nov 2021 10:41:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3883DCE16BF;
        Mon, 29 Nov 2021 18:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9865C53FC7;
        Mon, 29 Nov 2021 18:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211310;
        bh=LgKVI0DvkDGQLD+OwZ4GZEvDC8dc6JmCpd5gfzMRAIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ocp1JIc8ti7NQFr2JRkRAAH7d37GeBxxWxVGbTZzNRd+Vl7YPxKRoYS650ygL4sz4
         BHtdIQG8rLQK8OrRL/V7pUunjrRB1xSDhOpbw5Wi1Zv5OqqoiPr+jpBZBROjeDL5eR
         Z7oNRpLSb/PVvc43odPV8pLfTbsDT72abuIbQYcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, yangerkun <yangerkun@huawei.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 177/179] block: avoid to quiesce queue in elevator_init_mq
Date:   Mon, 29 Nov 2021 19:19:31 +0100
Message-Id: <20211129181724.761570426@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit 245a489e81e13dd55ae46d27becf6d5901eb7828 upstream.

elevator_init_mq() is only called before adding disk, when there isn't
any FS I/O, only passthrough requests can be queued, so freezing queue
plus canceling dispatch work is enough to drain any dispatch activities,
then we can avoid synchronize_srcu() in blk_mq_quiesce_queue().

Long boot latency issue can be fixed in case of lots of disks added
during booting.

Fixes: 737eb78e82d5 ("block: Delay default elevator initialization")
Reported-by: yangerkun <yangerkun@huawei.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20211117115502.1600950-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/elevator.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/block/elevator.c
+++ b/block/elevator.c
@@ -694,12 +694,18 @@ void elevator_init_mq(struct request_que
 	if (!e)
 		return;
 
+	/*
+	 * We are called before adding disk, when there isn't any FS I/O,
+	 * so freezing queue plus canceling dispatch work is enough to
+	 * drain any dispatch activities originated from passthrough
+	 * requests, then no need to quiesce queue which may add long boot
+	 * latency, especially when lots of disks are involved.
+	 */
 	blk_mq_freeze_queue(q);
-	blk_mq_quiesce_queue(q);
+	blk_mq_cancel_work_sync(q);
 
 	err = blk_mq_init_sched(q, e);
 
-	blk_mq_unquiesce_queue(q);
 	blk_mq_unfreeze_queue(q);
 
 	if (err) {


