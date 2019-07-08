Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A056239F
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390428AbfGHPdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:33:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732876AbfGHPdm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:33:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1626520665;
        Mon,  8 Jul 2019 15:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562600021;
        bh=ek20vikqeNTdh8UyIHg+luSl1BDDdZIm/V5dgx82/oE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YoJ3+Jg0UWPSBH5/33uR5EcJn6Kq0c8exzTpNkWrKF8gjmV7pFfRiM6EPw1HMSdMu
         qhiorZd4LynKXpvqoQah/kqCkRIKv58xGgec0xmZyElWiGdcDXzthIm7vWMMJKMQmS
         yBqPB4O1Slz+c8fzlKLmScrPD4rx+Dp9FDqMjVW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Qian Cai <cai@lca.pw>, Hugh Dickins <hughd@google.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.1 68/96] swap_readpage(): avoid blk_wake_io_task() if !synchronous
Date:   Mon,  8 Jul 2019 17:13:40 +0200
Message-Id: <20190708150530.140084973@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

commit 8751853091998cd31e9e5f1e8206280155af8921 upstream.

swap_readpage() sets waiter = bio->bi_private even if synchronous = F,
this means that the caller can get the spurious wakeup after return.

This can be fatal if blk_wake_io_task() does
set_current_state(TASK_RUNNING) after the caller does
set_special_state(), in the worst case the kernel can crash in
do_task_dead().

Link: http://lkml.kernel.org/r/20190704160301.GA5956@redhat.com
Fixes: 0619317ff8baa2d ("block: add polled wakeup task helper")
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Qian Cai <cai@lca.pw>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_io.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -137,8 +137,10 @@ out:
 	unlock_page(page);
 	WRITE_ONCE(bio->bi_private, NULL);
 	bio_put(bio);
-	blk_wake_io_task(waiter);
-	put_task_struct(waiter);
+	if (waiter) {
+		blk_wake_io_task(waiter);
+		put_task_struct(waiter);
+	}
 }
 
 int generic_swapfile_activate(struct swap_info_struct *sis,
@@ -395,11 +397,12 @@ int swap_readpage(struct page *page, boo
 	 * Keep this task valid during swap readpage because the oom killer may
 	 * attempt to access it in the page fault retry time check.
 	 */
-	get_task_struct(current);
-	bio->bi_private = current;
 	bio_set_op_attrs(bio, REQ_OP_READ, 0);
-	if (synchronous)
+	if (synchronous) {
 		bio->bi_opf |= REQ_HIPRI;
+		get_task_struct(current);
+		bio->bi_private = current;
+	}
 	count_vm_event(PSWPIN);
 	bio_get(bio);
 	qc = submit_bio(bio);


