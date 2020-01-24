Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 672A0148324
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404625AbgAXLdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:33:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404620AbgAXLdl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:33:41 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F35822075D;
        Fri, 24 Jan 2020 11:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865620;
        bh=MK+0H2m0NwaFC2Z2/WNt1A4Nh/a09D9UD1TDwoJi0r8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5TfdPVxbsB+FMNVNBclKXNMHZoVIW3oO2/zmbFOSmfKo/bv+Lxa+n7sh0JxdXVjk
         y8BL8oMrMdTWdDpzY2OnEfQ8mKDHWhqTLNVd1jm1+rqmm1WIXjQ2iMd2FF7vccnxzT
         FEdHQ6zAVz13oQEofjtY2laMzfTbfk5x8AcHytto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ying Xu <yinxu@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 595/639] sctp: add chunks to sk_backlog when the newsk sk_socket is not set
Date:   Fri, 24 Jan 2020 10:32:45 +0100
Message-Id: <20200124093203.915043986@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 819be8108fded0b9e710bbbf81193e52f7bab2f7 ]

This patch is to fix a NULL-ptr deref in selinux_socket_connect_helper:

  [...] kasan: GPF could be caused by NULL-ptr deref or user memory access
  [...] RIP: 0010:selinux_socket_connect_helper+0x94/0x460
  [...] Call Trace:
  [...]  selinux_sctp_bind_connect+0x16a/0x1d0
  [...]  security_sctp_bind_connect+0x58/0x90
  [...]  sctp_process_asconf+0xa52/0xfd0 [sctp]
  [...]  sctp_sf_do_asconf+0x785/0x980 [sctp]
  [...]  sctp_do_sm+0x175/0x5a0 [sctp]
  [...]  sctp_assoc_bh_rcv+0x285/0x5b0 [sctp]
  [...]  sctp_backlog_rcv+0x482/0x910 [sctp]
  [...]  __release_sock+0x11e/0x310
  [...]  release_sock+0x4f/0x180
  [...]  sctp_accept+0x3f9/0x5a0 [sctp]
  [...]  inet_accept+0xe7/0x720

It was caused by that the 'newsk' sk_socket was not set before going to
security sctp hook when processing asconf chunk with SCTP_PARAM_ADD_IP
or SCTP_PARAM_SET_PRIMARY:

  inet_accept()->
    sctp_accept():
      lock_sock():
          lock listening 'sk'
                                          do_softirq():
                                            sctp_rcv():  <-- [1]
                                                asconf chunk arrives and
                                                enqueued in 'sk' backlog
      sctp_sock_migrate():
          set asoc's sk to 'newsk'
      release_sock():
          sctp_backlog_rcv():
            lock 'newsk'
            sctp_process_asconf()  <-- [2]
            unlock 'newsk'
    sock_graft():
        set sk_socket  <-- [3]

As it shows, at [1] the asconf chunk would be put into the listening 'sk'
backlog, as accept() was holding its sock lock. Then at [2] asconf would
get processed with 'newsk' as asoc's sk had been set to 'newsk'. However,
'newsk' sk_socket is not set until [3], while selinux_sctp_bind_connect()
would deref it, then kernel crashed.

Here to fix it by adding the chunk to sk_backlog until newsk sk_socket is
set when .accept() is done.

Note that sk->sk_socket can be NULL when the sock is closed, so SOCK_DEAD
flag is also needed to check in sctp_newsk_ready().

Thanks to Ondrej for reviewing the code.

Fixes: d452930fd3b9 ("selinux: Add SCTP support")
Reported-by: Ying Xu <yinxu@redhat.com>
Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sctp/sctp.h |  5 +++++
 net/sctp/input.c        | 12 +++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 2abbc15824af9..2c6570e6fcfec 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -625,4 +625,9 @@ static inline __u32 sctp_min_frag_point(struct sctp_sock *sp, __u16 datasize)
 	return sctp_mtu_payload(sp, SCTP_DEFAULT_MINSEGMENT, datasize);
 }
 
+static inline bool sctp_newsk_ready(const struct sock *sk)
+{
+	return sock_flag(sk, SOCK_DEAD) || sk->sk_socket;
+}
+
 #endif /* __net_sctp_h__ */
diff --git a/net/sctp/input.c b/net/sctp/input.c
index bfe29158afccb..f64d882c86985 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -255,7 +255,7 @@ int sctp_rcv(struct sk_buff *skb)
 		bh_lock_sock(sk);
 	}
 
-	if (sock_owned_by_user(sk)) {
+	if (sock_owned_by_user(sk) || !sctp_newsk_ready(sk)) {
 		if (sctp_add_backlog(sk, skb)) {
 			bh_unlock_sock(sk);
 			sctp_chunk_free(chunk);
@@ -333,7 +333,7 @@ int sctp_backlog_rcv(struct sock *sk, struct sk_buff *skb)
 		local_bh_disable();
 		bh_lock_sock(sk);
 
-		if (sock_owned_by_user(sk)) {
+		if (sock_owned_by_user(sk) || !sctp_newsk_ready(sk)) {
 			if (sk_add_backlog(sk, skb, sk->sk_rcvbuf))
 				sctp_chunk_free(chunk);
 			else
@@ -348,7 +348,13 @@ int sctp_backlog_rcv(struct sock *sk, struct sk_buff *skb)
 		if (backloged)
 			return 0;
 	} else {
-		sctp_inq_push(inqueue, chunk);
+		if (!sctp_newsk_ready(sk)) {
+			if (!sk_add_backlog(sk, skb, sk->sk_rcvbuf))
+				return 0;
+			sctp_chunk_free(chunk);
+		} else {
+			sctp_inq_push(inqueue, chunk);
+		}
 	}
 
 done:
-- 
2.20.1



