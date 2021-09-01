Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA7D3FDCA3
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245617AbhIAMv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:51:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346616AbhIAMud (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:50:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A8B0610CD;
        Wed,  1 Sep 2021 12:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500132;
        bh=/99hflsMViHmt/Qz/ngWQWmp3wpG7JSu0FaoU7fuGZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VVLeYtC8w+tD1RVZoOi5758X8oq0q+5lnQfBg7mC9lJgO8wru6512KCJ/yARy6j1r
         KRAVDcdT5AWWj6dcVq9B2Ecaha+ngIEaPmCMN+Uie49Jjx3itlOf6AkCC8vCB9scYk
         FL5JjE8kUax7xxgkvDy9icDdD0WIMW6Sx8ZETQ5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuang Li <shuali@redhat.com>,
        Xin Long <lucien.xin@gmail.com>, Jon Maloy <jmaloy@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 5.13 100/113] tipc: call tipc_wait_for_connect only when dlen is not 0
Date:   Wed,  1 Sep 2021 14:28:55 +0200
Message-Id: <20210901122305.281619582@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
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
@@ -1528,7 +1528,7 @@ static int __tipc_sendmsg(struct socket
 
 	if (unlikely(syn && !rc)) {
 		tipc_set_sk_state(sk, TIPC_CONNECTING);
-		if (timeout) {
+		if (dlen && timeout) {
 			timeout = msecs_to_jiffies(timeout);
 			tipc_wait_for_connect(sock, &timeout);
 		}


