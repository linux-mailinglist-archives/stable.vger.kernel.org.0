Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F283F240A5C
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgHJPX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:23:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728309AbgHJPXZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:23:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F4B9214F1;
        Mon, 10 Aug 2020 15:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073005;
        bh=1fgeCoTwmpji+1gz0ECi45OvDJ5prtYx5oK3gPIZZ2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N43ckUzR9RtZXISUfPXfP8SEbpo2dd5BrrEB+L8M27zheL/nlCSKF8O7gecO7A258
         P6PQ/0ierQNGL+Q6cu55t96F64sjV8ugg1HqdhbX8yytuFbBF5CQtUkcUy4eKIg2T7
         3a23p3wqXdJpzBRb3hg3t0Qxfa5m1PfLZv1EMxWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e6f77e16ff68b2434a2c@syzkaller.appspotmail.com,
        Christoph Hellwig <hch@lst.de>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 32/79] net/9p: validate fds in p9_fd_open
Date:   Mon, 10 Aug 2020 17:20:51 +0200
Message-Id: <20200810151813.876491816@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit a39c46067c845a8a2d7144836e9468b7f072343e ]

p9_fd_open just fgets file descriptors passed in from userspace, but
doesn't verify that they are valid for read or writing.  This gets
cought down in the VFS when actually attempting a read or write, but
a new warning added in linux-next upsets syzcaller.

Fix this by just verifying the fds early on.

Link: http://lkml.kernel.org/r/20200710085722.435850-1-hch@lst.de
Reported-by: syzbot+e6f77e16ff68b2434a2c@syzkaller.appspotmail.com
Signed-off-by: Christoph Hellwig <hch@lst.de>
[Dominique: amend goto as per Doug Nazar's review]
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_fd.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 3f67803123be2..12ecacf0c55fb 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -816,20 +816,28 @@ static int p9_fd_open(struct p9_client *client, int rfd, int wfd)
 		return -ENOMEM;
 
 	ts->rd = fget(rfd);
+	if (!ts->rd)
+		goto out_free_ts;
+	if (!(ts->rd->f_mode & FMODE_READ))
+		goto out_put_rd;
 	ts->wr = fget(wfd);
-	if (!ts->rd || !ts->wr) {
-		if (ts->rd)
-			fput(ts->rd);
-		if (ts->wr)
-			fput(ts->wr);
-		kfree(ts);
-		return -EIO;
-	}
+	if (!ts->wr)
+		goto out_put_rd;
+	if (!(ts->wr->f_mode & FMODE_WRITE))
+		goto out_put_wr;
 
 	client->trans = ts;
 	client->status = Connected;
 
 	return 0;
+
+out_put_wr:
+	fput(ts->wr);
+out_put_rd:
+	fput(ts->rd);
+out_free_ts:
+	kfree(ts);
+	return -EIO;
 }
 
 static int p9_socket_open(struct p9_client *client, struct socket *csocket)
-- 
2.25.1



