Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B66411AF3E
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731047AbfLKPMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:12:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:32964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731039AbfLKPMF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18F20208C3;
        Wed, 11 Dec 2019 15:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077124;
        bh=za5x0gKKJydKjxfapHivmpXqDyIB5gTeC2ysaPAS+RU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=koMbm9jlBsbDUD5X7KyhEW1r61E6Suj67FNuxIlsW/zREujZJyxNJtSP+K9obMpan
         1d+BPnsmd34S/WLo+TP1IRAC6JB8KnX9EjOzsKPoTIpFGUXiDS/BtwInJGVWNaGLhI
         70FDkgqs5L3hB41g6p0AnBy2bDD4EypqcxLUh2TU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        syzbot+3c01db6025f26530cf8d@syzkaller.appspotmail.com,
        =?UTF-8?q?Andreas=20Gr=C3=BCnbacher?= 
        <andreas.gruenbacher@gmail.com>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 013/134] splice: only read in as much information as there is pipe buffer space
Date:   Wed, 11 Dec 2019 10:09:49 -0500
Message-Id: <20191211151150.19073-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit 3253d9d093376d62b4a56e609f15d2ec5085ac73 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/splice.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 98412721f0562..e509239d7e06a 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -945,12 +945,13 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
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
@@ -1180,8 +1181,15 @@ static long do_splice(struct file *in, loff_t __user *off_in,
 
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
-- 
2.20.1

