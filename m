Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D376421FAED
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbgGNS46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:56:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731088AbgGNS4y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:56:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D7B122A99;
        Tue, 14 Jul 2020 18:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753014;
        bh=z05sE6uoEfahcLhFFLnVSGhAnM319kCnEXXb1BUsaiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lMk6t/I0ZSHcMz8HlbOZrNVz3euTP0P3FrfD8L+AwcxqsPbKPMYzwl9RIlFFG7yIc
         NbbYur6fbqoJCuvGU7aaNuOXRq7WMpaldoG61bS3vZuZ16e0E7R6eouqd5OsL/XM8a
         +gSfhvryPNlEQiCIhFIyVrxqO7IRWBNQD9xhbLlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Sitnicki <jakub@cloudflare.com>,
        kernel test robot <rong.a.chen@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 059/166] bpf, sockmap: RCU splat with redirect and strparser error or TLS
Date:   Tue, 14 Jul 2020 20:43:44 +0200
Message-Id: <20200714184118.697099943@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 93dd5f185916b05e931cffae636596f21f98546e ]

There are two paths to generate the below RCU splat the first and
most obvious is the result of the BPF verdict program issuing a
redirect on a TLS socket (This is the splat shown below). Unlike
the non-TLS case the caller of the *strp_read() hooks does not
wrap the call in a rcu_read_lock/unlock. Then if the BPF program
issues a redirect action we hit the RCU splat.

However, in the non-TLS socket case the splat appears to be
relatively rare, because the skmsg caller into the strp_data_ready()
is wrapped in a rcu_read_lock/unlock. Shown here,

 static void sk_psock_strp_data_ready(struct sock *sk)
 {
	struct sk_psock *psock;

	rcu_read_lock();
	psock = sk_psock(sk);
	if (likely(psock)) {
		if (tls_sw_has_ctx_rx(sk)) {
			psock->parser.saved_data_ready(sk);
		} else {
			write_lock_bh(&sk->sk_callback_lock);
			strp_data_ready(&psock->parser.strp);
			write_unlock_bh(&sk->sk_callback_lock);
		}
	}
	rcu_read_unlock();
 }

If the above was the only way to run the verdict program we
would be safe. But, there is a case where the strparser may throw an
ENOMEM error while parsing the skb. This is a result of a failed
skb_clone, or alloc_skb_for_msg while building a new merged skb when
the msg length needed spans multiple skbs. This will in turn put the
skb on the strp_wrk workqueue in the strparser code. The skb will
later be dequeued and verdict programs run, but now from a
different context without the rcu_read_lock()/unlock() critical
section in sk_psock_strp_data_ready() shown above. In practice
I have not seen this yet, because as far as I know most users of the
verdict programs are also only working on single skbs. In this case no
merge happens which could trigger the above ENOMEM errors. In addition
the system would need to be under memory pressure. For example, we
can't hit the above case in selftests because we missed having tests
to merge skbs. (Added in later patch)

To fix the below splat extend the rcu_read_lock/unnlock block to
include the call to sk_psock_tls_verdict_apply(). This will fix both
TLS redirect case and non-TLS redirect+error case. Also remove
psock from the sk_psock_tls_verdict_apply() function signature its
not used there.

[ 1095.937597] WARNING: suspicious RCU usage
[ 1095.940964] 5.7.0-rc7-02911-g463bac5f1ca79 #1 Tainted: G        W
[ 1095.944363] -----------------------------
[ 1095.947384] include/linux/skmsg.h:284 suspicious rcu_dereference_check() usage!
[ 1095.950866]
[ 1095.950866] other info that might help us debug this:
[ 1095.950866]
[ 1095.957146]
[ 1095.957146] rcu_scheduler_active = 2, debug_locks = 1
[ 1095.961482] 1 lock held by test_sockmap/15970:
[ 1095.964501]  #0: ffff9ea6b25de660 (sk_lock-AF_INET){+.+.}-{0:0}, at: tls_sw_recvmsg+0x13a/0x840 [tls]
[ 1095.968568]
[ 1095.968568] stack backtrace:
[ 1095.975001] CPU: 1 PID: 15970 Comm: test_sockmap Tainted: G        W         5.7.0-rc7-02911-g463bac5f1ca79 #1
[ 1095.977883] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
[ 1095.980519] Call Trace:
[ 1095.982191]  dump_stack+0x8f/0xd0
[ 1095.984040]  sk_psock_skb_redirect+0xa6/0xf0
[ 1095.986073]  sk_psock_tls_strp_read+0x1d8/0x250
[ 1095.988095]  tls_sw_recvmsg+0x714/0x840 [tls]

v2: Improve commit message to identify non-TLS redirect plus error case
    condition as well as more common TLS case. In the process I decided
    doing the rcu_read_unlock followed by the lock/unlock inside branches
    was unnecessarily complex. We can just extend the current rcu block
    and get the same effeective without the shuffling and branching.
    Thanks Martin!

Fixes: e91de6afa81c1 ("bpf: Fix running sk_skb program types with ktls")
Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/159312677907.18340.11064813152758406626.stgit@john-XPS-13-9370
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 351afbf6bfbac..c41ab6906b210 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -683,7 +683,7 @@ static struct sk_psock *sk_psock_from_strp(struct strparser *strp)
 	return container_of(parser, struct sk_psock, parser);
 }
 
-static void sk_psock_skb_redirect(struct sk_psock *psock, struct sk_buff *skb)
+static void sk_psock_skb_redirect(struct sk_buff *skb)
 {
 	struct sk_psock *psock_other;
 	struct sock *sk_other;
@@ -715,12 +715,11 @@ static void sk_psock_skb_redirect(struct sk_psock *psock, struct sk_buff *skb)
 	}
 }
 
-static void sk_psock_tls_verdict_apply(struct sk_psock *psock,
-				       struct sk_buff *skb, int verdict)
+static void sk_psock_tls_verdict_apply(struct sk_buff *skb, int verdict)
 {
 	switch (verdict) {
 	case __SK_REDIRECT:
-		sk_psock_skb_redirect(psock, skb);
+		sk_psock_skb_redirect(skb);
 		break;
 	case __SK_PASS:
 	case __SK_DROP:
@@ -741,8 +740,8 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
 		ret = sk_psock_bpf_run(psock, prog, skb);
 		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
 	}
+	sk_psock_tls_verdict_apply(skb, ret);
 	rcu_read_unlock();
-	sk_psock_tls_verdict_apply(psock, skb, ret);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(sk_psock_tls_strp_read);
@@ -770,7 +769,7 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 		}
 		goto out_free;
 	case __SK_REDIRECT:
-		sk_psock_skb_redirect(psock, skb);
+		sk_psock_skb_redirect(skb);
 		break;
 	case __SK_DROP:
 		/* fall-through */
@@ -794,8 +793,8 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 		ret = sk_psock_bpf_run(psock, prog, skb);
 		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
 	}
-	rcu_read_unlock();
 	sk_psock_verdict_apply(psock, skb, ret);
+	rcu_read_unlock();
 }
 
 static int sk_psock_strp_read_done(struct strparser *strp, int err)
-- 
2.25.1



