Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 682C73FDB75
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245742AbhIAMlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:41:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344821AbhIAMkI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49D6A60041;
        Wed,  1 Sep 2021 12:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499758;
        bh=M7QszsJE42cbAyy9TIx8m5nHBt7j1XoZrdLWCrBVbaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aabhbjSeueopWPFxgMmff5O5Z0hbo9SOgr17zHMszDs+rMi3l/jdPNLuwKT0IUjC1
         wf03GrA5mny4aTSBeKYtW1FkBg0jMGrUhOjoDzxD0tjxmtCCEkMY9yiXZXt7U13li+
         FRQnjh/ziZzWdQCzdVNETgNnJmDNY9enjPZpTR/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuang Li <shuali@redhat.com>,
        Xin Long <lucien.xin@gmail.com>, Jon Maloy <jmaloy@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 5.10 075/103] tipc: call tipc_wait_for_connect only when dlen is not 0
Date:   Wed,  1 Sep 2021 14:28:25 +0200
Message-Id: <20210901122303.082040847@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit 7387a72c5f84f0dfb57618f9e4770672c0d2e4c9 upstream.

__tipc_sendmsg() is called to send SYN packet by either tipc_sendmsg()
or tipc_connect(). The difference is in tipc_connect(), it will call
tipc_wait_for_connect() after __tipc_sendmsg() to wait until connecting
is done. So there's no need to wait in __tipc_sendmsg() for this case.

This patch is to fix it by calling tipc_wait_for_connect() only when dlen
is not 0 in __tipc_sendmsg(), which means it's called by tipc_connect().

Note this also fixes the failure in tipcutils/test/ptts/:

  # ./tipcTS &
  # ./tipcTC 9
  (hang)

Fixes: 36239dab6da7 ("tipc: fix implicit-connect for SYN+")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1511,7 +1511,7 @@ static int __tipc_sendmsg(struct socket
 
 	if (unlikely(syn && !rc)) {
 		tipc_set_sk_state(sk, TIPC_CONNECTING);
-		if (timeout) {
+		if (dlen && timeout) {
 			timeout = msecs_to_jiffies(timeout);
 			tipc_wait_for_connect(sock, &timeout);
 		}


