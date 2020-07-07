Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEEAA2170F5
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729911AbgGGPWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:22:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729047AbgGGPWs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:22:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BE502078A;
        Tue,  7 Jul 2020 15:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135367;
        bh=1bVL+RD9lYL+5n5EXLBlUfEMkbGwPAMAFNwzlZV6uf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zWE+qz3cdUcf+l+rElZJ35h3CWnibZvRG7m8XO0rNLpRjfgUSTz9mSVxmUqjhHmiz
         DKcCgF4QdYON5TCPsCCyOcq/FKLi/AXVQ2FL5MTMYliGexKbOY3hyZ4D79WKYWI2z+
         VCWqpWuz3Dm92xijM2mLoKEU3PJs6ZgjeTCMlfLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+75139a7d2605236b0b7f@syzkaller.appspotmail.com,
        Jon Maloy <jmaloy@redhat.com>,
        Tuong Lien <tuong.t.lien@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 013/112] tipc: fix kernel WARNING in tipc_msg_append()
Date:   Tue,  7 Jul 2020 17:16:18 +0200
Message-Id: <20200707145801.626805944@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>

[ Upstream commit c9aa81faf19115fc2e732e7f210b37bb316987ff ]

syzbot found the following issue:

WARNING: CPU: 0 PID: 6808 at include/linux/thread_info.h:150 check_copy_size include/linux/thread_info.h:150 [inline]
WARNING: CPU: 0 PID: 6808 at include/linux/thread_info.h:150 copy_from_iter include/linux/uio.h:144 [inline]
WARNING: CPU: 0 PID: 6808 at include/linux/thread_info.h:150 tipc_msg_append+0x49a/0x5e0 net/tipc/msg.c:242
Kernel panic - not syncing: panic_on_warn set ...

This happens after commit 5e9eeccc58f3 ("tipc: fix NULL pointer
dereference in streaming") that tried to build at least one buffer even
when the message data length is zero... However, it now exposes another
bug that the 'mss' can be zero and the 'cpy' will be negative, thus the
above kernel WARNING will appear!
The zero value of 'mss' is never expected because it means Nagle is not
enabled for the socket (actually the socket type was 'SOCK_SEQPACKET'),
so the function 'tipc_msg_append()' must not be called at all. But that
was in this particular case since the message data length was zero, and
the 'send <= maxnagle' check became true.

We resolve the issue by explicitly checking if Nagle is enabled for the
socket, i.e. 'maxnagle != 0' before calling the 'tipc_msg_append()'. We
also reinforce the function to against such a negative values if any.

Reported-by: syzbot+75139a7d2605236b0b7f@syzkaller.appspotmail.com
Fixes: c0bceb97db9e ("tipc: add smart nagle feature")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/msg.c    | 4 ++--
 net/tipc/socket.c | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index 93966321f8929..560d7a4c0ffff 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -239,14 +239,14 @@ int tipc_msg_append(struct tipc_msg *_hdr, struct msghdr *m, int dlen,
 		hdr = buf_msg(skb);
 		curr = msg_blocks(hdr);
 		mlen = msg_size(hdr);
-		cpy = min_t(int, rem, mss - mlen);
+		cpy = min_t(size_t, rem, mss - mlen);
 		if (cpy != copy_from_iter(skb->data + mlen, cpy, &m->msg_iter))
 			return -EFAULT;
 		msg_set_size(hdr, mlen + cpy);
 		skb_put(skb, cpy);
 		rem -= cpy;
 		total += msg_blocks(hdr) - curr;
-	} while (rem);
+	} while (rem > 0);
 	return total - accounted;
 }
 
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index d6b67d07d22ec..62fc871a8d673 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1574,7 +1574,8 @@ static int __tipc_sendstream(struct socket *sock, struct msghdr *m, size_t dlen)
 			break;
 		send = min_t(size_t, dlen - sent, TIPC_MAX_USER_MSG_SIZE);
 		blocks = tsk->snd_backlog;
-		if (tsk->oneway++ >= tsk->nagle_start && send <= maxnagle) {
+		if (tsk->oneway++ >= tsk->nagle_start && maxnagle &&
+		    send <= maxnagle) {
 			rc = tipc_msg_append(hdr, m, send, maxnagle, txq);
 			if (unlikely(rc < 0))
 				break;
-- 
2.25.1



