Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B405433B95C
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbhCOOGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233286AbhCOOBW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4831F64F69;
        Mon, 15 Mar 2021 14:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816859;
        bh=ksqVK6wcCdbE1lO+qgCPDlFPW+GJdXp7WZ6R2M3NcWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=af9cwx1mAHKJ3rW6r7tuwSGWkUxjfQb8bqMZpfF5JYU6phOo0OiVLxmwD+QxpRuQ0
         m3A+jqR1RLBpw6EZT07KYHyog329VRpJ6/eT9kb84tvJYz8Wo+nNWt/zE4Ie9MExY+
         YgvYTHrM3PjrhGYtVhWGr4vqPiYp2v9m+K9yTfBk=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        John Dias <joaodias@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 156/168] zram: fix return value on writeback_store
Date:   Mon, 15 Mar 2021 14:56:28 +0100
Message-Id: <20210315135555.473229970@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Minchan Kim <minchan@kernel.org>

commit 57e0076e6575a7b7cef620a0bd2ee2549ef77818 upstream.

writeback_store's return value is overwritten by submit_bio_wait's return
value.  Thus, writeback_store will return zero since there was no IO
error.  In the end, write syscall from userspace will see the zero as
return value, which could make the process stall to keep trying the write
until it will succeed.

Link: https://lkml.kernel.org/r/20210312173949.2197662-1-minchan@kernel.org
Fixes: 3b82a051c101("drivers/block/zram/zram_drv.c: fix error return codes not being returned in writeback_store")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: John Dias <joaodias@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -627,7 +627,7 @@ static ssize_t writeback_store(struct de
 	struct bio_vec bio_vec;
 	struct page *page;
 	ssize_t ret = len;
-	int mode;
+	int mode, err;
 	unsigned long blk_idx = 0;
 
 	if (sysfs_streq(buf, "idle"))
@@ -719,12 +719,17 @@ static ssize_t writeback_store(struct de
 		 * XXX: A single page IO would be inefficient for write
 		 * but it would be not bad as starter.
 		 */
-		ret = submit_bio_wait(&bio);
-		if (ret) {
+		err = submit_bio_wait(&bio);
+		if (err) {
 			zram_slot_lock(zram, index);
 			zram_clear_flag(zram, index, ZRAM_UNDER_WB);
 			zram_clear_flag(zram, index, ZRAM_IDLE);
 			zram_slot_unlock(zram, index);
+			/*
+			 * Return last IO error unless every IO were
+			 * not suceeded.
+			 */
+			ret = err;
 			continue;
 		}
 


