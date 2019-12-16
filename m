Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7466121667
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbfLPS3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:29:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731196AbfLPSOR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:14:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC811206B7;
        Mon, 16 Dec 2019 18:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520057;
        bh=tV2z1ja2zHlj5jhifV+uZdn0BPjYitXdpaQ4jLkp6L0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=upT5SsYhpSTRFqeFn/WFEZz8AP2s9aTNNzfpEK/3hoxz4IU86Vh8RMmnhEkuTjD6J
         CVeMCpqd9OSXVMP85fO00OWpSL8OP3POFPQeSLQn24hjQjUm20zmoOd5qmJSX1Kbb2
         uOfxv9m9YmSrvygUZ514JC3PoSPI8fMtKr7ZGUJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+3c01db6025f26530cf8d@syzkaller.appspotmail.com,
        =?UTF-8?q?Andreas=20Gr=C3=BCnbacher?= 
        <andreas.gruenbacher@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 5.3 179/180] splice: only read in as much information as there is pipe buffer space
Date:   Mon, 16 Dec 2019 18:50:19 +0100
Message-Id: <20191216174848.539258702@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

commit 3253d9d093376d62b4a56e609f15d2ec5085ac73 upstream.

Andreas Grünbacher reports that on the two filesystems that support
iomap directio, it's possible for splice() to return -EAGAIN (instead of
a short splice) if the pipe being written to has less space available in
its pipe buffers than the length supplied by the calling process.

Months ago we fixed splice_direct_to_actor to clamp the length of the
read request to the size of the splice pipe.  Do the same to do_splice.

Fixes: 17614445576b6 ("splice: don't read more than available pipe space")
Reported-by: syzbot+3c01db6025f26530cf8d@syzkaller.appspotmail.com
Reported-by: Andreas Grünbacher <andreas.gruenbacher@gmail.com>
Reviewed-by: Andreas Grünbacher <andreas.gruenbacher@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/splice.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/fs/splice.c
+++ b/fs/splice.c
@@ -945,12 +945,13 @@ ssize_t splice_direct_to_actor(struct fi
 	WARN_ON_ONCE(pipe->nrbufs != 0);
 
 	while (len) {
+		unsigned int pipe_pages;
 		size_t read_len;
 		loff_t pos = sd->pos, prev_pos = pos;
 
 		/* Don't try to read more the pipe has space for. */
-		read_len = min_t(size_t, len,
-				 (pipe->buffers - pipe->nrbufs) << PAGE_SHIFT);
+		pipe_pages = pipe->buffers - pipe->nrbufs;
+		read_len = min(len, (size_t)pipe_pages << PAGE_SHIFT);
 		ret = do_splice_to(in, &pos, pipe, read_len, flags);
 		if (unlikely(ret <= 0))
 			goto out_release;
@@ -1180,8 +1181,15 @@ static long do_splice(struct file *in, l
 
 		pipe_lock(opipe);
 		ret = wait_for_space(opipe, flags);
-		if (!ret)
+		if (!ret) {
+			unsigned int pipe_pages;
+
+			/* Don't try to read more the pipe has space for. */
+			pipe_pages = opipe->buffers - opipe->nrbufs;
+			len = min(len, (size_t)pipe_pages << PAGE_SHIFT);
+
 			ret = do_splice_to(in, &offset, opipe, len, flags);
+		}
 		pipe_unlock(opipe);
 		if (ret > 0)
 			wakeup_pipe_readers(opipe);


