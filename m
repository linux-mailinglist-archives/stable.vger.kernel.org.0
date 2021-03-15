Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A0D33B6C1
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbhCON6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232244AbhCON6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1998A64EEE;
        Mon, 15 Mar 2021 13:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816670;
        bh=6ohsfSn4nqNla9ID/b6WxiXGfxNyTSthS+ATfirT2LU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MUAF7O1x75x4oZq8ajH35+mbcqFlnaO6f7QYuzJi/4rxWPVW1zrw/4wF0t6lmKllk
         Mk4qXUlW/lDMpnkCYrT+7mv9m6hc51BrGy3cyhz6VWoMXpD5DN+HNJ7hJPdlYrHIpd
         LxcqE10aomvyXzK0iupklC3pJUL9jLQd9+35DWz4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 037/168] net: qrtr: fix error return code of qrtr_sendmsg()
Date:   Mon, 15 Mar 2021 14:54:29 +0100
Message-Id: <20210315135551.560772278@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jia-Ju Bai <baijiaju1990@gmail.com>

commit 179d0ba0c454057a65929c46af0d6ad986754781 upstream.

When sock_alloc_send_skb() returns NULL to skb, no error return code of
qrtr_sendmsg() is assigned.
To fix this bug, rc is assigned with -ENOMEM in this case.

Fixes: 194ccc88297a ("net: qrtr: Support decoding incoming v2 packets")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/qrtr/qrtr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -791,8 +791,10 @@ static int qrtr_sendmsg(struct socket *s
 	plen = (len + 3) & ~3;
 	skb = sock_alloc_send_skb(sk, plen + QRTR_HDR_MAX_SIZE,
 				  msg->msg_flags & MSG_DONTWAIT, &rc);
-	if (!skb)
+	if (!skb) {
+		rc = -ENOMEM;
 		goto out_node;
+	}
 
 	skb_reserve(skb, QRTR_HDR_MAX_SIZE);
 


