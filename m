Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34024171D25
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389342AbgB0OSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:18:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:58836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389848AbgB0OSQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:18:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 390B42468F;
        Thu, 27 Feb 2020 14:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582813095;
        bh=xesT2UlzCbBoPZ3jCcAKGHwDsacdBqRyufulwajcqKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+XKHBY+XcNSllwW7z9AzSeKt7uavNjJ5rattRqD1PCDKxnAOEyodEgMMFyG5LQx5
         hrLD1Yn2QvitVChcOON0jNm2TWGdh6qj+uUPmyUmZKg8mzVXDPPV07Mahe4oepee/P
         JMbUhwGIQ6jTX/4NGw9iC4kPyq0GREUSuN3qv3sA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.5 134/150] io_uring: prevent sq_thread from spinning when it should stop
Date:   Thu, 27 Feb 2020 14:37:51 +0100
Message-Id: <20200227132252.180011700@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

commit 7143b5ac5750f404ff3a594b34fdf3fc2f99f828 upstream.

This patch drops 'cur_mm' before calling cond_resched(), to prevent
the sq_thread from spinning even when the user process is finished.

Before this patch, if the user process ended without closing the
io_uring fd, the sq_thread continues to spin until the
'sq_thread_idle' timeout ends.

In the worst case where the 'sq_thread_idle' parameter is bigger than
INT_MAX, the sq_thread will spin forever.

Fixes: 6c271ce2f1d5 ("io_uring: add submission polling")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3909,6 +3909,18 @@ static int io_sq_thread(void *data)
 		 */
 		if (!to_submit || ret == -EBUSY) {
 			/*
+			 * Drop cur_mm before scheduling, we can't hold it for
+			 * long periods (or over schedule()). Do this before
+			 * adding ourselves to the waitqueue, as the unuse/drop
+			 * may sleep.
+			 */
+			if (cur_mm) {
+				unuse_mm(cur_mm);
+				mmput(cur_mm);
+				cur_mm = NULL;
+			}
+
+			/*
 			 * We're polling. If we're within the defined idle
 			 * period, then let us spin without work before going
 			 * to sleep. The exception is if we got EBUSY doing
@@ -3922,18 +3934,6 @@ static int io_sq_thread(void *data)
 				continue;
 			}
 
-			/*
-			 * Drop cur_mm before scheduling, we can't hold it for
-			 * long periods (or over schedule()). Do this before
-			 * adding ourselves to the waitqueue, as the unuse/drop
-			 * may sleep.
-			 */
-			if (cur_mm) {
-				unuse_mm(cur_mm);
-				mmput(cur_mm);
-				cur_mm = NULL;
-			}
-
 			prepare_to_wait(&ctx->sqo_wait, &wait,
 						TASK_INTERRUPTIBLE);
 


