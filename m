Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03412264FD
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730450AbgGTPt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:49:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731059AbgGTPtz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:49:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DD782064B;
        Mon, 20 Jul 2020 15:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260195;
        bh=0RwVnEK/I2mLDzT50vz+pxDG2h2QzNEwWLNPicsGOis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKTmjomVg+fQhNtgp0nqahuXiOVYvFQtN2kSV7ZDyFnR3QG2xy+NawqIYYGnFhGPj
         206cy+eTzUIPXPcrqicpLbIepPZHL6Zx4W0J0zROW1baUVuS8XC/yJhlQZH5oIVvEm
         b7wfD/9OqMctkY6MtWzd2JfLFGUNiOkT0yRZgtwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 015/133] tcp: md5: allow changing MD5 keys in all socket states
Date:   Mon, 20 Jul 2020 17:36:02 +0200
Message-Id: <20200720152804.462045128@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1ca0fafd73c5268e8fc4b997094b8bb2bfe8deea ]

This essentially reverts commit 721230326891 ("tcp: md5: reject TCP_MD5SIG
or TCP_MD5SIG_EXT on established sockets")

Mathieu reported that many vendors BGP implementations can
actually switch TCP MD5 on established flows.

Quoting Mathieu :
   Here is a list of a few network vendors along with their behavior
   with respect to TCP MD5:

   - Cisco: Allows for password to be changed, but within the hold-down
     timer (~180 seconds).
   - Juniper: When password is initially set on active connection it will
     reset, but after that any subsequent password changes no network
     resets.
   - Nokia: No notes on if they flap the tcp connection or not.
   - Ericsson/RedBack: Allows for 2 password (old/new) to co-exist until
     both sides are ok with new passwords.
   - Meta-Switch: Expects the password to be set before a connection is
     attempted, but no further info on whether they reset the TCP
     connection on a change.
   - Avaya: Disable the neighbor, then set password, then re-enable.
   - Zebos: Would normally allow the change when socket connected.

We can revert my prior change because commit 9424e2e7ad93 ("tcp: md5: fix potential
overestimation of TCP option space") removed the leak of 4 kernel bytes to
the wire that was the main reason for my patch.

While doing my investigations, I found a bug when a MD5 key is changed, leading
to these commits that stable teams want to consider before backporting this revert :

 Commit 6a2febec338d ("tcp: md5: add missing memory barriers in tcp_md5_do_add()/tcp_md5_hash_key()")
 Commit e6ced831ef11 ("tcp: md5: refine tcp_md5_do_add()/tcp_md5_hash_key() barriers")

Fixes: 721230326891 "tcp: md5: reject TCP_MD5SIG or TCP_MD5SIG_EXT on established sockets"
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3015,10 +3015,7 @@ static int do_tcp_setsockopt(struct sock
 #ifdef CONFIG_TCP_MD5SIG
 	case TCP_MD5SIG:
 	case TCP_MD5SIG_EXT:
-		if ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN))
-			err = tp->af_specific->md5_parse(sk, optname, optval, optlen);
-		else
-			err = -EINVAL;
+		err = tp->af_specific->md5_parse(sk, optname, optval, optlen);
 		break;
 #endif
 	case TCP_USER_TIMEOUT:


