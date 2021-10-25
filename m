Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF40043A1D6
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbhJYTms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:42:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237263AbhJYTkf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:40:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4EE661152;
        Mon, 25 Oct 2021 19:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190550;
        bh=6yEjGP1Nqf1/s7RSuCb0sm/LjXzf4RHTGXgdw1xmoR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rtOEMFckWPcr1C7AkQInap8fmwTNPYPp7GzCNw5uQSUC3IaWrOVSBs8Kuko4hjL9N
         Y0RMsLNvBV/gFV9Z+OQPs5Y6zqoGLdalbzvquzvvndONIhp0vOa1Yst5YME7ynzBcY
         HbA/IWBKKjNF7p6BtKrpZXjql4Qe1HxbFGXlWtJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.14 001/169] block/mq-deadline: Move dd_queued() to fix defined but not used warning
Date:   Mon, 25 Oct 2021 21:13:02 +0200
Message-Id: <20211025191017.966657144@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 55a51ea14094a1e7dd0d7f33237d246033dd39ab upstream.

If CONFIG_BLK_DEBUG_FS=n:

    block/mq-deadline.c:274:12: warning: ‘dd_queued’ defined but not used [-Wunused-function]
      274 | static u32 dd_queued(struct deadline_data *dd, enum dd_prio prio)
	  |            ^~~~~~~~~

Fix this by moving dd_queued() just before the sole function that calls
it.

Fixes: 7b05bf771084ff78 ("Revert "block/mq-deadline: Prioritize high-priority requests"")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Fixes: 38ba64d12d4c ("block/mq-deadline: Track I/O statistics")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20210830091128.1854266-1-geert@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/mq-deadline.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -270,12 +270,6 @@ deadline_move_request(struct deadline_da
 	deadline_remove_request(rq->q, per_prio, rq);
 }
 
-/* Number of requests queued for a given priority level. */
-static u32 dd_queued(struct deadline_data *dd, enum dd_prio prio)
-{
-	return dd_sum(dd, inserted, prio) - dd_sum(dd, completed, prio);
-}
-
 /*
  * deadline_check_fifo returns 0 if there are no expired requests on the fifo,
  * 1 otherwise. Requires !list_empty(&dd->fifo_list[data_dir])
@@ -953,6 +947,12 @@ static int dd_async_depth_show(void *dat
 	return 0;
 }
 
+/* Number of requests queued for a given priority level. */
+static u32 dd_queued(struct deadline_data *dd, enum dd_prio prio)
+{
+	return dd_sum(dd, inserted, prio) - dd_sum(dd, completed, prio);
+}
+
 static int dd_queued_show(void *data, struct seq_file *m)
 {
 	struct request_queue *q = data;


