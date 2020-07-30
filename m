Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35D8232D24
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgG3IHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:07:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729419AbgG3IHQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:07:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4563D2070B;
        Thu, 30 Jul 2020 08:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096435;
        bh=UfJVeJUvEktLyrA62yuxdVRt6MOMKjCe1Jqc/4/ZzL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+zYWpIasIEbZNz+rPiMjLKTas5iAzzMruW4haNbGYvqSP8NsFcF9wNFnwqNFwtcu
         Zkj0Afe6zK1lVUiPl0KW1if2Y7Fvu+ojrUne9uXpRAYFub97YAjL6yZJ0PsxdC35Zf
         InGPOfA3YyHPMbidVbiPsDv00xTog8GvHyDV6OFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+6720d64f31c081c2f708@syzkaller.appspotmail.com
Subject: [PATCH 4.19 08/17] qrtr: orphan socket in qrtr_release()
Date:   Thu, 30 Jul 2020 10:04:34 +0200
Message-Id: <20200730074420.869921109@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.449233408@linuxfoundation.org>
References: <20200730074420.449233408@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit af9f691f0f5bdd1ade65a7b84927639882d7c3e5 ]

We have to detach sock from socket in qrtr_release(),
otherwise skb->sk may still reference to this socket
when the skb is released in tun->queue, particularly
sk->sk_wq still points to &sock->wq, which leads to
a UAF.

Reported-and-tested-by: syzbot+6720d64f31c081c2f708@syzkaller.appspotmail.com
Fixes: 28fb4e59a47d ("net: qrtr: Expose tunneling endpoint to user space")
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/qrtr/qrtr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -1013,6 +1013,7 @@ static int qrtr_release(struct socket *s
 		sk->sk_state_change(sk);
 
 	sock_set_flag(sk, SOCK_DEAD);
+	sock_orphan(sk);
 	sock->sk = NULL;
 
 	if (!sock_flag(sk, SOCK_ZAPPED))


