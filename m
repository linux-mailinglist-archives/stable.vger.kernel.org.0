Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDFC3D5F4A
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236669AbhGZPR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:17:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237492AbhGZPPw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42E7860F42;
        Mon, 26 Jul 2021 15:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314981;
        bh=WiCRf5DJ73hqLGq5e37eaQKkkD1kuiAjVY7yrmfLq+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r17esQGXB9F37OWH+QFFe+X+vfXQloAhBQtJnkFjsGGQW+nOaRFlB/5ahzMWinrLT
         Euk2qQsiw1rwV4afZFIfmJ8brm61WiAbtGGT7/eaeNO/DO+k41GGY+80+u45O+X31j
         BFrxwI1T6gNFahB/wkkTkeP/uDn0icoIvjT7h2Cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/108] net: fix uninit-value in caif_seqpkt_sendmsg
Date:   Mon, 26 Jul 2021 17:38:42 +0200
Message-Id: <20210726153833.009641473@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 991e634360f2622a683b48dfe44fe6d9cb765a09 ]

When nr_segs equal to zero in iovec_from_user, the object
msg->msg_iter.iov is uninit stack memory in caif_seqpkt_sendmsg
which is defined in ___sys_sendmsg. So we cann't just judge
msg->msg_iter.iov->base directlly. We can use nr_segs to judge
msg in caif_seqpkt_sendmsg whether has data buffers.

=====================================================
BUG: KMSAN: uninit-value in caif_seqpkt_sendmsg+0x693/0xf60 net/caif/caif_socket.c:542
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 caif_seqpkt_sendmsg+0x693/0xf60 net/caif/caif_socket.c:542
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2343
 ___sys_sendmsg net/socket.c:2397 [inline]
 __sys_sendmmsg+0x808/0xc90 net/socket.c:2480
 __compat_sys_sendmmsg net/compat.c:656 [inline]

Reported-by: syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=1ace85e8fc9b0d5a45c08c2656c3e91762daa9b8
Fixes: bece7b2398d0 ("caif: Rewritten socket implementation")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/caif/caif_socket.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index ef14da50a981..8fa98c62c4fc 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -539,7 +539,8 @@ static int caif_seqpkt_sendmsg(struct socket *sock, struct msghdr *msg,
 		goto err;
 
 	ret = -EINVAL;
-	if (unlikely(msg->msg_iter.iov->iov_base == NULL))
+	if (unlikely(msg->msg_iter.nr_segs == 0) ||
+	    unlikely(msg->msg_iter.iov->iov_base == NULL))
 		goto err;
 	noblock = msg->msg_flags & MSG_DONTWAIT;
 
-- 
2.30.2



