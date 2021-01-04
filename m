Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCEA2E99A1
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbhADQCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:02:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:39414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728748AbhADQCJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:02:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C466022519;
        Mon,  4 Jan 2021 16:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776089;
        bh=waRQhcYKE8DOL1wuAwegN+jbUsvrLSohcSjKxKE+tn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N5DYcnrklATj6xZbUBR3SGvaeaNaU+qt9NSW7BTEQCwhOOkTAzMuzPaZ5+4oivhmx
         kVRz6FpHp4MYb2cW6S9KYoIHE7Qels4k+AMaBm08S4uilw855lZYTc70tZqm7ZnV08
         w02vLJhqQbvLyPpBvB7Srxhyvv/26fYsM+CdDE+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 5.10 17/63] io_uring: dont assume mm is constant across submits
Date:   Mon,  4 Jan 2021 16:57:10 +0100
Message-Id: <20210104155709.650714386@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 77788775c7132a8d93c6930ab1bd84fc743c7cb7 upstream.

If we COW the identity, we assume that ->mm never changes. But this
isn't true of multiple processes end up sharing the ring. Hence treat
id->mm like like any other process compontent when it comes to the
identity mapping. This is pretty trivial, just moving the existing grab
into io_grab_identity(), and including a check for the match.

Cc: stable@vger.kernel.org # 5.10
Fixes: 1e6fa5216a0e ("io_uring: COW io_identity on mismatch")
Reported-by: Christian Brauner <christian.brauner@ubuntu.com>:
Tested-by: Christian Brauner <christian.brauner@ubuntu.com>:
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1369,6 +1369,13 @@ static bool io_grab_identity(struct io_k
 		spin_unlock_irq(&ctx->inflight_lock);
 		req->work.flags |= IO_WQ_WORK_FILES;
 	}
+	if (!(req->work.flags & IO_WQ_WORK_MM) &&
+	    (def->work_flags & IO_WQ_WORK_MM)) {
+		if (id->mm != current->mm)
+			return false;
+		mmgrab(id->mm);
+		req->work.flags |= IO_WQ_WORK_MM;
+	}
 
 	return true;
 }
@@ -1393,13 +1400,6 @@ static void io_prep_async_work(struct io
 			req->work.flags |= IO_WQ_WORK_UNBOUND;
 	}
 
-	/* ->mm can never change on us */
-	if (!(req->work.flags & IO_WQ_WORK_MM) &&
-	    (def->work_flags & IO_WQ_WORK_MM)) {
-		mmgrab(id->mm);
-		req->work.flags |= IO_WQ_WORK_MM;
-	}
-
 	/* if we fail grabbing identity, we must COW, regrab, and retry */
 	if (io_grab_identity(req))
 		return;


