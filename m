Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A3A48003C
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239904AbhL0PoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:44:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39958 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238597AbhL0PmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:42:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09BDE61117;
        Mon, 27 Dec 2021 15:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E58C36AE7;
        Mon, 27 Dec 2021 15:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619719;
        bh=HpIB+Qqk7zYfhKImprC5Q3zJu5RW2bnDE03EC4+3BOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wsz+0p9zi/QwoQ43WzECvRaf1DqZUxM8P1wV0CLJJaaoDVccTyEu3u00+NwxeYkXb
         Wkxeuh38WuUKBXNc4RLwj0CKQrwWNHRaSBmllEAx5BGYAGeG4Re0b+VyztzbUreD5s
         E20AxyGHFJlPVDlasJU0+w99uXoyt5qQtL1GgyJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Samuel Williams <samuel.williams@oriontransfer.co.nz>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/128] io_uring: zero iocb->ki_pos for stream file types
Date:   Mon, 27 Dec 2021 16:30:19 +0100
Message-Id: <20211227151332.988615420@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 7b9762a5e8837b92a027d58d396a9d27f6440c36 ]

io_uring supports using offset == -1 for using the current file position,
and we read that in as part of read/write command setup. For the non-iter
read/write types we pass in NULL for the position pointer, but for the
iter types we should not be passing any anything but 0 for the position
for a stream.

Clear kiocb->ki_pos if the file is a stream, don't leave it as -1. If we
do, then the request will error with -ESPIPE.

Fixes: ba04291eb66e ("io_uring: allow use of offset == -1 to mean file position")
Link: https://github.com/axboe/liburing/discussions/501
Reported-by: Samuel Williams <samuel.williams@oriontransfer.co.nz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e9b06e339c4b0..0006fc7479ca3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2879,9 +2879,13 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		req->flags |= REQ_F_ISREG;
 
 	kiocb->ki_pos = READ_ONCE(sqe->off);
-	if (kiocb->ki_pos == -1 && !(file->f_mode & FMODE_STREAM)) {
-		req->flags |= REQ_F_CUR_POS;
-		kiocb->ki_pos = file->f_pos;
+	if (kiocb->ki_pos == -1) {
+		if (!(file->f_mode & FMODE_STREAM)) {
+			req->flags |= REQ_F_CUR_POS;
+			kiocb->ki_pos = file->f_pos;
+		} else {
+			kiocb->ki_pos = 0;
+		}
 	}
 	kiocb->ki_hint = ki_hint_validate(file_write_hint(kiocb->ki_filp));
 	kiocb->ki_flags = iocb_flags(kiocb->ki_filp);
-- 
2.34.1



