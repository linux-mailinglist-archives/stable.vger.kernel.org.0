Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14CEC111EF6
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbfLCWtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:49:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:40152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729559AbfLCWtN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:49:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55A8220684;
        Tue,  3 Dec 2019 22:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413352;
        bh=MqCGkEaFKEvYpnpR5yjcDLhn3RcaqfJeMd3Ts7sMgNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HxF9BIy//Iq/yRrjqSJg9rilW0keTxlqt28wVaC9z7g69Bfl9LD1gAgqZCz0DjjTb
         Wd/GKkPpVxTZ9n6SG1nBy1NkosE9QB/6rdoO9cIUtJ1ZjRCDXW6PWAXCElTHLqV0rO
         KvSIgEDLjJDIUnNw6Z1pTV6zQF/CZv3EMYF0lufA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shenghui Wang <shhuiw@foxmail.com>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 096/321] bcache: do not mark writeback_running too early
Date:   Tue,  3 Dec 2019 23:32:42 +0100
Message-Id: <20191203223432.153600792@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shenghui Wang <shhuiw@foxmail.com>

[ Upstream commit 79b791466e525c98f6aeee9acf5726e7b27f4231 ]

A fresh backing device is not attached to any cache_set, and
has no writeback kthread created until first attached to some
cache_set.

But bch_cached_dev_writeback_init run
"
	dc->writeback_running		= true;
	WARN_ON(test_and_clear_bit(BCACHE_DEV_WB_RUNNING,
			&dc->disk.flags));
"
for any newly formatted backing devices.

For a fresh standalone backing device, we can get something like
following even if no writeback kthread created:
------------------------
/sys/block/bcache0/bcache# cat writeback_running
1
/sys/block/bcache0/bcache# cat writeback_rate_debug
rate:		512.0k/sec
dirty:		0.0k
target:		0.0k
proportional:	0.0k
integral:	0.0k
change:		0.0k/sec
next io:	-15427384ms

The none ZERO fields are misleading as no alive writeback kthread yet.

Set dc->writeback_running false as no writeback thread created in
bch_cached_dev_writeback_init().

We have writeback thread created and woken up in bch_cached_dev_writeback
_start(). Set dc->writeback_running true before bch_writeback_queue()
called, as a writeback thread will check if dc->writeback_running is true
before writing back dirty data, and hung if false detected.

After the change, we can get the following output for a fresh standalone
backing device:
-----------------------
/sys/block/bcache0/bcache$ cat writeback_running
0
/sys/block/bcache0/bcache# cat writeback_rate_debug
rate:		0.0k/sec
dirty:		0.0k
target:		0.0k
proportional:	0.0k
integral:	0.0k
change:		0.0k/sec
next io:	0ms

v1 -> v2:
  Set dc->writeback_running before bch_writeback_queue() called,

Signed-off-by: Shenghui Wang <shhuiw@foxmail.com>
Signed-off-by: Coly Li <colyli@suse.de>

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/writeback.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index ba5395fd386d5..b5fc3c6c7178e 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -781,7 +781,7 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 	bch_keybuf_init(&dc->writeback_keys);
 
 	dc->writeback_metadata		= true;
-	dc->writeback_running		= true;
+	dc->writeback_running		= false;
 	dc->writeback_percent		= 10;
 	dc->writeback_delay		= 30;
 	atomic_long_set(&dc->writeback_rate.rate, 1024);
@@ -810,6 +810,7 @@ int bch_cached_dev_writeback_start(struct cached_dev *dc)
 		destroy_workqueue(dc->writeback_write_wq);
 		return PTR_ERR(dc->writeback_thread);
 	}
+	dc->writeback_running = true;
 
 	WARN_ON(test_and_set_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags));
 	schedule_delayed_work(&dc->writeback_rate_update,
-- 
2.20.1



