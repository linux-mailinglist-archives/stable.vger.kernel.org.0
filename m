Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B81961203
	for <lists+stable@lfdr.de>; Sat,  6 Jul 2019 17:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfGFPuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Jul 2019 11:50:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726794AbfGFPuq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Jul 2019 11:50:46 -0400
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 123AE20838;
        Sat,  6 Jul 2019 15:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562428245;
        bh=DoMosQyj+D2mjOogflP8YGGJ6A9R8/xlAkdk2iL0qLk=;
        h=Date:From:To:Cc:Subject:From;
        b=kbjtnzPQNMvZHlhZ/kx7zMACMZ7PPjTCyuSNTZ93unBmycxP/8i7lY0yA/VpfVq9r
         rgmzBLFZkfc6hpAGJs6Ys68JjkqahB6er5JvH7gooh+lVn78rR6XMmDq7hG27Dt9sk
         K+Bi4RvnPAtYT3HrHkd0CPHOzRBhi8R5nhs4ZihM=
Date:   Sat, 6 Jul 2019 17:50:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: [PATCH] blk-mq: fix up placement of debugfs directory of queue files
Message-ID: <20190706155032.GA3106@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the blk-mq debugfs file creation logic was "cleaned up" it was
cleaned up too much, causing the queue file to not be created in the
correct location.  Turns out the check for the directory being present
is needed as if that has not happened yet, the files should not be
created, and the function will be called later on in the initialization
code so that the files can be created in the correct location.

Fixes: 6cfc0081b046 ("blk-mq: no need to check return value of debugfs_create functions")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org
Cc: stable <stable@vger.kernel.org> # 5.2+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq-debugfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 2489ddbb21db..3afe327f816f 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -934,6 +934,13 @@ void blk_mq_debugfs_register_sched(struct request_queue *q)
 {
 	struct elevator_type *e = q->elevator->type;
 
+	/*
+	 * If the parent directory has not been created yet, return, we will be
+	 * called again later on and the directory/files will be created then.
+	 */
+	if (!q->debugfs_dir)
+		return;
+
 	if (!e->queue_debugfs_attrs)
 		return;
 
-- 
2.22.0

