Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE660353F97
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239431AbhDEJNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:13:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239120AbhDEJNN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:13:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D3FB60FE4;
        Mon,  5 Apr 2021 09:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613986;
        bh=kfHQcJJAzvhygrZUceya6EX8qxx/HELAPKhcz7R0HEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S9xneK0f1LhxTDBNq9rUOcKxzxXyJsQ96OfAdB04EPvSqJuk/tkV/mK98nAhVt0PE
         gONBPicMPZkKFVtHJlCv2T9Zq0YWFvXA9BdG0UK8T/1gOYpvavI/kbuytO5HgpvewZ
         MOTvmWBuPdvOVZRTknczHj//ZeZegW7wOEgRs6Dg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 042/152] mptcp: fix poll after shutdown
Date:   Mon,  5 Apr 2021 10:53:11 +0200
Message-Id: <20210405085035.646980845@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit dd913410b0a442a53d41a9817ed2208850858e99 ]

The current mptcp_poll() implementation gives unexpected
results after shutdown(SEND_SHUTDOWN) and when the msk
status is TCP_CLOSE.

Set the correct mask.

Fixes: 8edf08649eed ("mptcp: rework poll+nospace handling")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index f588332eebb4..44b8868f0607 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3320,7 +3320,7 @@ static __poll_t mptcp_check_writeable(struct mptcp_sock *msk)
 	struct sock *sk = (struct sock *)msk;
 
 	if (unlikely(sk->sk_shutdown & SEND_SHUTDOWN))
-		return 0;
+		return EPOLLOUT | EPOLLWRNORM;
 
 	if (sk_stream_is_writeable(sk))
 		return EPOLLOUT | EPOLLWRNORM;
@@ -3353,6 +3353,8 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 		mask |= mptcp_check_readable(msk);
 		mask |= mptcp_check_writeable(msk);
 	}
+	if (sk->sk_shutdown == SHUTDOWN_MASK || state == TCP_CLOSE)
+		mask |= EPOLLHUP;
 	if (sk->sk_shutdown & RCV_SHUTDOWN)
 		mask |= EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
 
-- 
2.30.1



