Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C54A014BAC1
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgA1OOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:14:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:36880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729912AbgA1OOi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:14:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A85E2468E;
        Tue, 28 Jan 2020 14:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220878;
        bh=9MdhLw8bCOJwhXjVcSWUEJ0OY99eCT6+70jrT5f0DKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=odBQUaO+FyJGyYBwYqUIkGScI0lI2S7emXqYvtrwT369+5WT7wq2C7ywLFm8ir504
         BUuxbeSFZUrdBwESI2vmn3N6aRKhUYKDMj7PzJXtZbqX1srTDSS7cOYLXYGF+N0vi1
         NsrhapshlO3ZfBHsynxMeY0OmaSRLQnuomP3xaGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>,
        syzbot+429c200ffc8772bfe070@syzkaller.appspotmail.com,
        syzbot+eec0c87f31a7c3b66f7b@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 182/183] net/x25: fix nonblocking connect
Date:   Tue, 28 Jan 2020 15:06:41 +0100
Message-Id: <20200128135847.894325353@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Schiller <ms@dev.tdt.de>

commit e21dba7a4df4d93da237da65a096084b4f2e87b4 upstream.

This patch fixes 2 issues in x25_connect():

1. It makes absolutely no sense to reset the neighbour and the
connection state after a (successful) nonblocking call of x25_connect.
This prevents any connection from being established, since the response
(call accept) cannot be processed.

2. Any further calls to x25_connect() while a call is pending should
simply return, instead of creating new Call Request (on different
logical channels).

This patch should also fix the "KASAN: null-ptr-deref Write in
x25_connect" and "BUG: unable to handle kernel NULL pointer dereference
in x25_connect" bugs reported by syzbot.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Reported-by: syzbot+429c200ffc8772bfe070@syzkaller.appspotmail.com
Reported-by: syzbot+eec0c87f31a7c3b66f7b@syzkaller.appspotmail.com
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/x25/af_x25.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -764,6 +764,10 @@ static int x25_connect(struct socket *so
 	if (sk->sk_state == TCP_ESTABLISHED)
 		goto out;
 
+	rc = -EALREADY;	/* Do nothing if call is already in progress */
+	if (sk->sk_state == TCP_SYN_SENT)
+		goto out;
+
 	sk->sk_state   = TCP_CLOSE;
 	sock->state = SS_UNCONNECTED;
 
@@ -810,7 +814,7 @@ static int x25_connect(struct socket *so
 	/* Now the loop */
 	rc = -EINPROGRESS;
 	if (sk->sk_state != TCP_ESTABLISHED && (flags & O_NONBLOCK))
-		goto out_put_neigh;
+		goto out;
 
 	rc = x25_wait_for_connection_establishment(sk);
 	if (rc)


