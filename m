Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A0426192E
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731894AbgIHSI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:08:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731316AbgIHQLt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:11:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFE7D24768;
        Tue,  8 Sep 2020 15:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579710;
        bh=bLHFQoqjMw1LqzuW5lIQUHGrICvm3uFWuzg3G89iCmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cD+vvQSpDpTcYlPHceoRNtsOfu7TKk/mH8wTZ4Kc70yne4dQjvAUQTeF0TjrxoPo3
         PQxGI4/KZ6qzIoDKk2qIQdUHzo2nDRegWgD5YWTs1vZxGS7zRS/PdKAhvf64uuTuP9
         l2nBPth6PYr5wz3wmfI8C2LOo88A1rAzGTabtiuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Norman Maurer <norman.maurer@googlemail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 176/186] io_uring: no read/write-retry on -EAGAIN error and O_NONBLOCK marked file
Date:   Tue,  8 Sep 2020 17:25:18 +0200
Message-Id: <20200908152250.202142288@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 355afaeb578abac907217c256a844cfafb0337b2 upstream.

Actually two things that need fixing up here:

- The io_rw_reissue() -EAGAIN retry is explicit to block devices and
  regular files, so don't ever attempt to do that on other types of
  files.

- If we hit -EAGAIN on a nonblock marked file, don't arm poll handler for
  it. It should just complete with -EAGAIN.

Cc: stable@vger.kernel.org
Reported-by: Norman Maurer <norman.maurer@googlemail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2697,8 +2697,15 @@ static int io_read(struct io_kiocb *req,
 		else
 			ret2 = -EINVAL;
 
+		/* no retry on NONBLOCK marked file */
+		if (ret2 == -EAGAIN && (req->file->f_flags & O_NONBLOCK)) {
+			ret = 0;
+			goto done;
+		}
+
 		/* Catch -EAGAIN return for forced non-blocking submission */
 		if (!force_nonblock || ret2 != -EAGAIN) {
+	done:
 			kiocb_done(kiocb, ret2);
 		} else {
 copy_iov:
@@ -2823,7 +2830,13 @@ static int io_write(struct io_kiocb *req
 		 */
 		if (ret2 == -EOPNOTSUPP && (kiocb->ki_flags & IOCB_NOWAIT))
 			ret2 = -EAGAIN;
+		/* no retry on NONBLOCK marked file */
+		if (ret2 == -EAGAIN && (req->file->f_flags & O_NONBLOCK)) {
+			ret = 0;
+			goto done;
+		}
 		if (!force_nonblock || ret2 != -EAGAIN) {
+done:
 			kiocb_done(kiocb, ret2);
 		} else {
 copy_iov:


