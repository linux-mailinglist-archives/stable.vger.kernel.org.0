Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31568266694
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725869AbgIKR2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:28:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726110AbgIKM6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:58:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF27B22226;
        Fri, 11 Sep 2020 12:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828946;
        bh=Z5TbhurZqMuwJnIkK3DCZTFB2mu6W+4eZ+IQQQFIlGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VyPqpuzyYKxE7K+5f9lUoDf3/BAHydTfDIJEz53I5pjk1Msxz7Uh00cdUWnuq8NF1
         CLBIhzCku+DsNTMSMnZhnpj/y3BTn9KdGquVNFoZ1tQ79bkKMsnzzfUy8RfXoxOqi4
         AwgXrJsXlM/82F3+DvkqXzeqFeO1v8ySOhljWUgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ying Xu <yinxu@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 61/62] sctp: not disable bh in the whole sctp_get_port_local()
Date:   Fri, 11 Sep 2020 14:46:44 +0200
Message-Id: <20200911122505.429694330@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122502.395450276@linuxfoundation.org>
References: <20200911122502.395450276@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 3106ecb43a05dc3e009779764b9da245a5d082de ]

With disabling bh in the whole sctp_get_port_local(), when
snum == 0 and too many ports have been used, the do-while
loop will take the cpu for a long time and cause cpu stuck:

  [ ] watchdog: BUG: soft lockup - CPU#11 stuck for 22s!
  [ ] RIP: 0010:native_queued_spin_lock_slowpath+0x4de/0x940
  [ ] Call Trace:
  [ ]  _raw_spin_lock+0xc1/0xd0
  [ ]  sctp_get_port_local+0x527/0x650 [sctp]
  [ ]  sctp_do_bind+0x208/0x5e0 [sctp]
  [ ]  sctp_autobind+0x165/0x1e0 [sctp]
  [ ]  sctp_connect_new_asoc+0x355/0x480 [sctp]
  [ ]  __sctp_connect+0x360/0xb10 [sctp]

There's no need to disable bh in the whole function of
sctp_get_port_local. So fix this cpu stuck by removing
local_bh_disable() called at the beginning, and using
spin_lock_bh() instead.

The same thing was actually done for inet_csk_get_port() in
Commit ea8add2b1903 ("tcp/dccp: better use of ephemeral
ports in bind()").

Thanks to Marcelo for pointing the buggy code out.

v1->v2:
  - use cond_resched() to yield cpu to other tasks if needed,
    as Eric noticed.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Ying Xu <yinxu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/socket.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -6206,8 +6206,6 @@ static long sctp_get_port_local(struct s
 
 	pr_debug("%s: begins, snum:%d\n", __func__, snum);
 
-	local_bh_disable();
-
 	if (snum == 0) {
 		/* Search for an available port. */
 		int low, high, remaining, index;
@@ -6226,20 +6224,21 @@ static long sctp_get_port_local(struct s
 				continue;
 			index = sctp_phashfn(sock_net(sk), rover);
 			head = &sctp_port_hashtable[index];
-			spin_lock(&head->lock);
+			spin_lock_bh(&head->lock);
 			sctp_for_each_hentry(pp, &head->chain)
 				if ((pp->port == rover) &&
 				    net_eq(sock_net(sk), pp->net))
 					goto next;
 			break;
 		next:
-			spin_unlock(&head->lock);
+			spin_unlock_bh(&head->lock);
+			cond_resched();
 		} while (--remaining > 0);
 
 		/* Exhausted local port range during search? */
 		ret = 1;
 		if (remaining <= 0)
-			goto fail;
+			return ret;
 
 		/* OK, here is the one we will use.  HEAD (the port
 		 * hash table list entry) is non-NULL and we hold it's
@@ -6254,7 +6253,7 @@ static long sctp_get_port_local(struct s
 		 * port iterator, pp being NULL.
 		 */
 		head = &sctp_port_hashtable[sctp_phashfn(sock_net(sk), snum)];
-		spin_lock(&head->lock);
+		spin_lock_bh(&head->lock);
 		sctp_for_each_hentry(pp, &head->chain) {
 			if ((pp->port == snum) && net_eq(pp->net, sock_net(sk)))
 				goto pp_found;
@@ -6338,10 +6337,7 @@ success:
 	ret = 0;
 
 fail_unlock:
-	spin_unlock(&head->lock);
-
-fail:
-	local_bh_enable();
+	spin_unlock_bh(&head->lock);
 	return ret;
 }
 


