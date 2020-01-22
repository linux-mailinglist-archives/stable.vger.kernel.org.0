Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AADD91455B4
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgAVNYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:24:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:43486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730384AbgAVNY3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:24:29 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD1802468D;
        Wed, 22 Jan 2020 13:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699468;
        bh=saJJsPSEysuOgD7sWV/Y6BpPYK0rM97l5wS6VnAKg5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NvxRcyUfhYggu1n1GSbhE5uljbSQCVQy7zYmDpxmmcyE3gxXuft5998WXIlVyQoIW
         Ia30wTF1sz4vQUnEay/DsVRU9ImzJIHpS8IWd4uEXk3h1E0gLxlTylrJlUwkzkFv2B
         Fyzqg60dPEcmRYQ6oZmVKwCOA3BLW33PC3GLdAsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.4 109/222] bpf: Sockmap, ensure sock lock held during tear down
Date:   Wed, 22 Jan 2020 10:28:15 +0100
Message-Id: <20200122092841.539726799@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

commit 7e81a35302066c5a00b4c72d83e3ea4cad6eeb5b upstream.

The sock_map_free() and sock_hash_free() paths used to delete sockmap
and sockhash maps walk the maps and destroy psock and bpf state associated
with the socks in the map. When done the socks no longer have BPF programs
attached and will function normally. This can happen while the socks in
the map are still "live" meaning data may be sent/received during the walk.

Currently, though we don't take the sock_lock when the psock and bpf state
is removed through this path. Specifically, this means we can be writing
into the ops structure pointers such as sendmsg, sendpage, recvmsg, etc.
while they are also being called from the networking side. This is not
safe, we never used proper READ_ONCE/WRITE_ONCE semantics here if we
believed it was safe. Further its not clear to me its even a good idea
to try and do this on "live" sockets while networking side might also
be using the socket. Instead of trying to reason about using the socks
from both sides lets realize that every use case I'm aware of rarely
deletes maps, in fact kubernetes/Cilium case builds map at init and
never tears it down except on errors. So lets do the simple fix and
grab sock lock.

This patch wraps sock deletes from maps in sock lock and adds some
annotations so we catch any other cases easier.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Song Liu <songliubraving@fb.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20200111061206.8028-3-john.fastabend@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/skmsg.c    |    2 ++
 net/core/sock_map.c |    7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -594,6 +594,8 @@ EXPORT_SYMBOL_GPL(sk_psock_destroy);
 
 void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 {
+	sock_owned_by_me(sk);
+
 	sk_psock_cork_free(psock);
 	sk_psock_zap_ingress(psock);
 
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -241,8 +241,11 @@ static void sock_map_free(struct bpf_map
 		struct sock *sk;
 
 		sk = xchg(psk, NULL);
-		if (sk)
+		if (sk) {
+			lock_sock(sk);
 			sock_map_unref(sk, psk);
+			release_sock(sk);
+		}
 	}
 	raw_spin_unlock_bh(&stab->lock);
 	rcu_read_unlock();
@@ -862,7 +865,9 @@ static void sock_hash_free(struct bpf_ma
 		raw_spin_lock_bh(&bucket->lock);
 		hlist_for_each_entry_safe(elem, node, &bucket->head, node) {
 			hlist_del_rcu(&elem->node);
+			lock_sock(elem->sk);
 			sock_map_unref(elem->sk, elem);
+			release_sock(elem->sk);
 		}
 		raw_spin_unlock_bh(&bucket->lock);
 	}


