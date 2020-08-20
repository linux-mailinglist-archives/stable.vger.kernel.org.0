Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AED124B9F7
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbgHTL5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:57:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730481AbgHTKAm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:00:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C14D5208E4;
        Thu, 20 Aug 2020 10:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917642;
        bh=McGCwYC+BC0s+KKmOlE6YpRkcTGvJ3EU52u2hcJ7Ew4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JWoPvkLU7eSoZSGOAPBgETWVR+dflYSjbxcBYWhG9W3Zl8u6USSFA6jXH6HiveJ1H
         7KgtZeO+zzt9fYEvdcgr1Dcq7rjjGX+4EaTwBrV36UGVA5Ub6vGuiunulNNlJxjNpv
         4r6dGKe971BiV1B6d4OLa9ZeNo06Jl09PMUaFTC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e6f77e16ff68b2434a2c@syzkaller.appspotmail.com,
        Christoph Hellwig <hch@lst.de>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 064/212] net/9p: validate fds in p9_fd_open
Date:   Thu, 20 Aug 2020 11:20:37 +0200
Message-Id: <20200820091605.601050071@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
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
index b0f47563f0bf3..bad27b0ec65d6 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -815,20 +815,28 @@ static int p9_fd_open(struct p9_client *client, int rfd, int wfd)
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



