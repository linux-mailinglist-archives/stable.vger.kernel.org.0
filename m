Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C082B658E
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731755AbgKQN40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:56:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:56880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730684AbgKQNWh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:22:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3818E24654;
        Tue, 17 Nov 2020 13:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619355;
        bh=OE6TXPUCQ1k1btAVrSTPMn085/IQmXSbfPHDe+Htxa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=deroA62modJvnORXnLR4YdDYHGM6PaC2t+jovFNYmI4y+BOb6l1LO4MrG3bTym3fC
         4HRf9Yna1ueEplDg3vZAyzuRJW1aoZ2tQHrvjFUaZKxmYsoh++eekZ+9VQiM1NjckG
         dQl1C6MBIIFxg5kstvvJdkJmwo9nfgUXT/zu719Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, lining <lining2020x@163.com>,
        Ming Lei <ming.lei@redhat.com>,
        Josef Bacik <josef@toxicpanda.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 003/151] nbd: dont update block size after device is started
Date:   Tue, 17 Nov 2020 14:03:53 +0100
Message-Id: <20201117122121.556211131@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit b40813ddcd6bf9f01d020804e4cb8febc480b9e4 ]

Mounted NBD device can be resized, one use case is rbd-nbd.

Fix the issue by setting up default block size, then not touch it
in nbd_size_update() any more. This kind of usage is aligned with loop
which has same use case too.

Cc: stable@vger.kernel.org
Fixes: c8a83a6b54d0 ("nbd: Use set_blocksize() to set device blocksize")
Reported-by: lining <lining2020x@163.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Jan Kara <jack@suse.cz>
Tested-by: lining <lining2020x@163.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 742f8160b6e28..62a873718b5bb 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -296,7 +296,7 @@ static void nbd_size_clear(struct nbd_device *nbd)
 	}
 }
 
-static void nbd_size_update(struct nbd_device *nbd)
+static void nbd_size_update(struct nbd_device *nbd, bool start)
 {
 	struct nbd_config *config = nbd->config;
 	struct block_device *bdev = bdget_disk(nbd->disk, 0);
@@ -312,7 +312,8 @@ static void nbd_size_update(struct nbd_device *nbd)
 	if (bdev) {
 		if (bdev->bd_disk) {
 			bd_set_size(bdev, config->bytesize);
-			set_blocksize(bdev, config->blksize);
+			if (start)
+				set_blocksize(bdev, config->blksize);
 		} else
 			bdev->bd_invalidated = 1;
 		bdput(bdev);
@@ -327,7 +328,7 @@ static void nbd_size_set(struct nbd_device *nbd, loff_t blocksize,
 	config->blksize = blocksize;
 	config->bytesize = blocksize * nr_blocks;
 	if (nbd->task_recv != NULL)
-		nbd_size_update(nbd);
+		nbd_size_update(nbd, false);
 }
 
 static void nbd_complete_rq(struct request *req)
@@ -1293,7 +1294,7 @@ static int nbd_start_device(struct nbd_device *nbd)
 		args->index = i;
 		queue_work(nbd->recv_workq, &args->work);
 	}
-	nbd_size_update(nbd);
+	nbd_size_update(nbd, true);
 	return error;
 }
 
-- 
2.27.0



