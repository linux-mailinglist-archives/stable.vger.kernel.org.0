Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048E52B6145
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729993AbgKQNRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:17:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728534AbgKQNRa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:17:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF95721734;
        Tue, 17 Nov 2020 13:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619049;
        bh=xZPzoopCaItned10T96lNiFu375H5EO0HDd3vezoKEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mBFsHzYnNXvTdwoU2ihKRRV9bPY87+Pvg+t4fk2VLo8sCrNat8EXSXNHkD1Eiojbk
         7eW/4RXwh6Cmazi6n+1PWyvJiOzfHc2oNfPpkTAFPemibpKAL4asuyZukpcTt5/Ybb
         5LCmJypofo5jk9HKpRIuDkt61jIGzenjWiuy650M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, lining <lining2020x@163.com>,
        Ming Lei <ming.lei@redhat.com>,
        Josef Bacik <josef@toxicpanda.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 003/101] nbd: dont update block size after device is started
Date:   Tue, 17 Nov 2020 14:04:30 +0100
Message-Id: <20201117122113.283475129@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
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
index 52e1e71e81241..706115ecd9bee 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -276,7 +276,7 @@ static void nbd_size_clear(struct nbd_device *nbd)
 	}
 }
 
-static void nbd_size_update(struct nbd_device *nbd)
+static void nbd_size_update(struct nbd_device *nbd, bool start)
 {
 	struct nbd_config *config = nbd->config;
 	struct block_device *bdev = bdget_disk(nbd->disk, 0);
@@ -292,7 +292,8 @@ static void nbd_size_update(struct nbd_device *nbd)
 	if (bdev) {
 		if (bdev->bd_disk) {
 			bd_set_size(bdev, config->bytesize);
-			set_blocksize(bdev, config->blksize);
+			if (start)
+				set_blocksize(bdev, config->blksize);
 		} else
 			bdev->bd_invalidated = 1;
 		bdput(bdev);
@@ -307,7 +308,7 @@ static void nbd_size_set(struct nbd_device *nbd, loff_t blocksize,
 	config->blksize = blocksize;
 	config->bytesize = blocksize * nr_blocks;
 	if (nbd->task_recv != NULL)
-		nbd_size_update(nbd);
+		nbd_size_update(nbd, false);
 }
 
 static void nbd_complete_rq(struct request *req)
@@ -1244,7 +1245,7 @@ static int nbd_start_device(struct nbd_device *nbd)
 		args->index = i;
 		queue_work(nbd->recv_workq, &args->work);
 	}
-	nbd_size_update(nbd);
+	nbd_size_update(nbd, true);
 	return error;
 }
 
-- 
2.27.0



