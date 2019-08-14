Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55BC08DBC4
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbfHNRC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:02:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728762AbfHNRC5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:02:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89D9C208C2;
        Wed, 14 Aug 2019 17:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802176;
        bh=v1ncVUEw5omDh/lN+fYExxW5ZP8v8Cu9WRF1leWKklk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H+eM4aJivF595pb/jSRzIJi2p7cE64nNHsiH/lR3Dagwbrm1zW0OqA2KaBm0jVc/I
         9Kg1y13kAK1db9njgnmJcn4bwJU8AGMOwpH//tz6/nC26M6p/OtGr15M7xTN7Jzdg4
         tGSkLTUxG7vyg+mKK3AMqQmByuIEo/7EwwKw+UcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.2 023/144] bdev: Fixup error handling in blkdev_get()
Date:   Wed, 14 Aug 2019 18:59:39 +0200
Message-Id: <20190814165800.813745526@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit e91455bad5cff40a8c232f2204a5104127e3fec2 upstream.

Commit 89e524c04fa9 ("loop: Fix mount(2) failure due to race with
LOOP_SET_FD") converted blkdev_get() to use the new helpers for
finishing claiming of a block device. However the conversion botched the
error handling in blkdev_get() and thus the bdev has been marked as held
even in case __blkdev_get() returned error. This led to occasional
warnings with block/001 test from blktests like:

kernel: WARNING: CPU: 5 PID: 907 at fs/block_dev.c:1899 __blkdev_put+0x396/0x3a0

Correct the error handling.

CC: stable@vger.kernel.org
Fixes: 89e524c04fa9 ("loop: Fix mount(2) failure due to race with LOOP_SET_FD")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/block_dev.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1723,7 +1723,10 @@ int blkdev_get(struct block_device *bdev
 
 		/* finish claiming */
 		mutex_lock(&bdev->bd_mutex);
-		bd_finish_claiming(bdev, whole, holder);
+		if (!res)
+			bd_finish_claiming(bdev, whole, holder);
+		else
+			bd_abort_claiming(bdev, whole, holder);
 		/*
 		 * Block event polling for write claims if requested.  Any
 		 * write holder makes the write_holder state stick until


