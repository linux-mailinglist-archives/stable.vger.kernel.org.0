Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 512C45CB99
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbfGBIGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727342AbfGBIGE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:06:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BA4B21841;
        Tue,  2 Jul 2019 08:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054763;
        bh=FE+f3XSKY1HJoAhc4roae3H3YR1STBtAYQXgL3bvoTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YKGao9t0vXN87ZSFk98aXX187Wm+aEhqe5bJ0/hUC2ftoPiMUszyyaL1QbNw43FOF
         vwDIt34d0FpO9EqDC0YHOrvYo3jK++PO1/TUfXrL0QfQq/8Ut+GpcAQOPNBzN1eO6F
         FuQOxvOt04JsW3oQuwOPolWXqgcmjLEoMRyhWgrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominique Martinet <dominique.martinet@cea.fr>,
        syzbot+2222c34dc40b515f30dc@syzkaller.appspotmail.com,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 19/72] 9p/trans_fd: abort p9_read_work if req status changed
Date:   Tue,  2 Jul 2019 10:01:20 +0200
Message-Id: <20190702080125.656500245@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e4ca13f7d075e551dc158df6af18fb412a1dba0a ]

p9_read_work would try to handle an errored req even if it got put to
error state by another thread between the lookup (that worked) and the
time it had been fully read.
The request itself is safe to use because we hold a ref to it from the
lookup (for m->rreq, so it was safe to read into the request data buffer
until this point), but the req_list has been deleted at the same time
status changed, and client_cb already has been called as well, so we
should not do either.

Link: http://lkml.kernel.org/r/1539057956-23741-1-git-send-email-asmadeus@codewreck.org
Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
Reported-by: syzbot+2222c34dc40b515f30dc@syzkaller.appspotmail.com
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_fd.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 12559c474dde..a0317d459cde 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -292,7 +292,6 @@ static void p9_read_work(struct work_struct *work)
 	__poll_t n;
 	int err;
 	struct p9_conn *m;
-	int status = REQ_STATUS_ERROR;
 
 	m = container_of(work, struct p9_conn, rq);
 
@@ -375,11 +374,17 @@ static void p9_read_work(struct work_struct *work)
 		p9_debug(P9_DEBUG_TRANS, "got new packet\n");
 		m->rreq->rc.size = m->rc.offset;
 		spin_lock(&m->client->lock);
-		if (m->rreq->status != REQ_STATUS_ERROR)
-			status = REQ_STATUS_RCVD;
-		list_del(&m->rreq->req_list);
-		/* update req->status while holding client->lock  */
-		p9_client_cb(m->client, m->rreq, status);
+		if (m->rreq->status == REQ_STATUS_SENT) {
+			list_del(&m->rreq->req_list);
+			p9_client_cb(m->client, m->rreq, REQ_STATUS_RCVD);
+		} else {
+			spin_unlock(&m->client->lock);
+			p9_debug(P9_DEBUG_ERROR,
+				 "Request tag %d errored out while we were reading the reply\n",
+				 m->rc.tag);
+			err = -EIO;
+			goto error;
+		}
 		spin_unlock(&m->client->lock);
 		m->rc.sdata = NULL;
 		m->rc.offset = 0;
-- 
2.20.1



