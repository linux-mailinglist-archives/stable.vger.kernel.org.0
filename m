Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDEC33D5FFA
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236926AbhGZPUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:20:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236945AbhGZPT7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:19:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2270560F38;
        Mon, 26 Jul 2021 16:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315227;
        bh=j/aOLUbOdOq0sBPBbQBjstjkHGj58DL6E7srTYZaOac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hGIWa7j9F5WBdqWKMu5GwCYkbqT0/KnTM8lhDzU2AsAvc1b42A+icF63g9WBHJy0Z
         2bZAn8C22iWsm7lPZSlSNmETn9EFWJ93K0+VGzkf7TbCwQIEupKnzzk/Xvy1fLAg9d
         mJnzWvaAlIu/YYIL1BC+pucSOtLM+SeAfBESggHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/167] net: Introduce preferred busy-polling
Date:   Mon, 26 Jul 2021 17:37:27 +0200
Message-Id: <20210726153839.841834200@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

[ Upstream commit 7fd3253a7de6a317a0683f83739479fb880bffc8 ]

The existing busy-polling mode, enabled by the SO_BUSY_POLL socket
option or system-wide using the /proc/sys/net/core/busy_read knob, is
an opportunistic. That means that if the NAPI context is not
scheduled, it will poll it. If, after busy-polling, the budget is
exceeded the busy-polling logic will schedule the NAPI onto the
regular softirq handling.

One implication of the behavior above is that a busy/heavy loaded NAPI
context will never enter/allow for busy-polling. Some applications
prefer that most NAPI processing would be done by busy-polling.

This series adds a new socket option, SO_PREFER_BUSY_POLL, that works
in concert with the napi_defer_hard_irqs and gro_flush_timeout
knobs. The napi_defer_hard_irqs and gro_flush_timeout knobs were
introduced in commit 6f8b12d661d0 ("net: napi: add hard irqs deferral
feature"), and allows for a user to defer interrupts to be enabled and
instead schedule the NAPI context from a watchdog timer. When a user
enables the SO_PREFER_BUSY_POLL, again with the other knobs enabled,
and the NAPI context is being processed by a softirq, the softirq NAPI
processing will exit early to allow the busy-polling to be performed.

If the application stops performing busy-polling via a system call,
the watchdog timer defined by gro_flush_timeout will timeout, and
regular softirq handling will resume.

In summary; Heavy traffic applications that prefer busy-polling over
softirq processing should use this option.

Example usage:

  $ echo 2 | sudo tee /sys/class/net/ens785f1/napi_defer_hard_irqs
  $ echo 200000 | sudo tee /sys/class/net/ens785f1/gro_flush_timeout

Note that the timeout should be larger than the userspace processing
window, otherwise the watchdog will timeout and fall back to regular
softirq processing.

Enable the SO_BUSY_POLL/SO_PREFER_BUSY_POLL options on your socket.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/bpf/20201130185205.196029-2-bjorn.topel@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/include/uapi/asm/socket.h  |  2 +
 arch/mips/include/uapi/asm/socket.h   |  2 +
 arch/parisc/include/uapi/asm/socket.h |  2 +
 arch/sparc/include/uapi/asm/socket.h  |  2 +
 fs/eventpoll.c                        |  2 +-
 include/linux/netdevice.h             | 35 +++++++-----
 include/net/busy_poll.h               |  5 +-
 include/net/sock.h                    |  4 ++
 include/uapi/asm-generic/socket.h     |  2 +
 net/core/dev.c                        | 78 +++++++++++++++++++++------
 net/core/sock.c                       |  9 ++++
 11 files changed, 111 insertions(+), 32 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
index de6c4df61082..538359642554 100644
--- a/arch/alpha/include/uapi/asm/socket.h
+++ b/arch/alpha/include/uapi/asm/socket.h
@@ -124,6 +124,8 @@
 
 #define SO_DETACH_REUSEPORT_BPF 68
 
+#define SO_PREFER_BUSY_POLL	69
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
index d0a9ed2ca2d6..e406e73b5e6e 100644
--- a/arch/mips/include/uapi/asm/socket.h
+++ b/arch/mips/include/uapi/asm/socket.h
@@ -135,6 +135,8 @@
 
 #define SO_DETACH_REUSEPORT_BPF 68
 
+#define SO_PREFER_BUSY_POLL	69
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
index 10173c32195e..1bc46200889d 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -116,6 +116,8 @@
 
 #define SO_DETACH_REUSEPORT_BPF 0x4042
 
+#define SO_PREFER_BUSY_POLL	0x4043
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
index 8029b681fc7c..99688cf673a4 100644
--- a/arch/sparc/include/uapi/asm/socket.h
+++ b/arch/sparc/include/uapi/asm/socket.h
@@ -117,6 +117,8 @@
 
 #define SO_DETACH_REUSEPORT_BPF  0x0047
 
+#define SO_PREFER_BUSY_POLL	 0x0048
+
 #if !defined(__KERNEL__)
 
 
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 6094b2e9058b..9e5b05e818ad 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -397,7 +397,7 @@ static void ep_busy_loop(struct eventpoll *ep, int nonblock)
 	unsigned int napi_id = READ_ONCE(ep->napi_id);
 
 	if ((napi_id >= MIN_NAPI_ID) && net_busy_loop_on())
-		napi_busy_loop(napi_id, nonblock ? NULL : ep_busy_loop_end, ep);
+		napi_busy_loop(napi_id, nonblock ? NULL : ep_busy_loop_end, ep, false);
 }
 
 static inline void ep_reset_busy_poll_napi_id(struct eventpoll *ep)
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e37480b5f4c0..2488638a8749 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -350,23 +350,25 @@ struct napi_struct {
 };
 
 enum {
-	NAPI_STATE_SCHED,	/* Poll is scheduled */
-	NAPI_STATE_MISSED,	/* reschedule a napi */
-	NAPI_STATE_DISABLE,	/* Disable pending */
-	NAPI_STATE_NPSVC,	/* Netpoll - don't dequeue from poll_list */
-	NAPI_STATE_LISTED,	/* NAPI added to system lists */
-	NAPI_STATE_NO_BUSY_POLL,/* Do not add in napi_hash, no busy polling */
-	NAPI_STATE_IN_BUSY_POLL,/* sk_busy_loop() owns this NAPI */
+	NAPI_STATE_SCHED,		/* Poll is scheduled */
+	NAPI_STATE_MISSED,		/* reschedule a napi */
+	NAPI_STATE_DISABLE,		/* Disable pending */
+	NAPI_STATE_NPSVC,		/* Netpoll - don't dequeue from poll_list */
+	NAPI_STATE_LISTED,		/* NAPI added to system lists */
+	NAPI_STATE_NO_BUSY_POLL,	/* Do not add in napi_hash, no busy polling */
+	NAPI_STATE_IN_BUSY_POLL,	/* sk_busy_loop() owns this NAPI */
+	NAPI_STATE_PREFER_BUSY_POLL,	/* prefer busy-polling over softirq processing*/
 };
 
 enum {
-	NAPIF_STATE_SCHED	 = BIT(NAPI_STATE_SCHED),
-	NAPIF_STATE_MISSED	 = BIT(NAPI_STATE_MISSED),
-	NAPIF_STATE_DISABLE	 = BIT(NAPI_STATE_DISABLE),
-	NAPIF_STATE_NPSVC	 = BIT(NAPI_STATE_NPSVC),
-	NAPIF_STATE_LISTED	 = BIT(NAPI_STATE_LISTED),
-	NAPIF_STATE_NO_BUSY_POLL = BIT(NAPI_STATE_NO_BUSY_POLL),
-	NAPIF_STATE_IN_BUSY_POLL = BIT(NAPI_STATE_IN_BUSY_POLL),
+	NAPIF_STATE_SCHED		= BIT(NAPI_STATE_SCHED),
+	NAPIF_STATE_MISSED		= BIT(NAPI_STATE_MISSED),
+	NAPIF_STATE_DISABLE		= BIT(NAPI_STATE_DISABLE),
+	NAPIF_STATE_NPSVC		= BIT(NAPI_STATE_NPSVC),
+	NAPIF_STATE_LISTED		= BIT(NAPI_STATE_LISTED),
+	NAPIF_STATE_NO_BUSY_POLL	= BIT(NAPI_STATE_NO_BUSY_POLL),
+	NAPIF_STATE_IN_BUSY_POLL	= BIT(NAPI_STATE_IN_BUSY_POLL),
+	NAPIF_STATE_PREFER_BUSY_POLL	= BIT(NAPI_STATE_PREFER_BUSY_POLL),
 };
 
 enum gro_result {
@@ -437,6 +439,11 @@ static inline bool napi_disable_pending(struct napi_struct *n)
 	return test_bit(NAPI_STATE_DISABLE, &n->state);
 }
 
+static inline bool napi_prefer_busy_poll(struct napi_struct *n)
+{
+	return test_bit(NAPI_STATE_PREFER_BUSY_POLL, &n->state);
+}
+
 bool napi_schedule_prep(struct napi_struct *n);
 
 /**
diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index b001fa91c14e..0292b8353d7e 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -43,7 +43,7 @@ bool sk_busy_loop_end(void *p, unsigned long start_time);
 
 void napi_busy_loop(unsigned int napi_id,
 		    bool (*loop_end)(void *, unsigned long),
-		    void *loop_end_arg);
+		    void *loop_end_arg, bool prefer_busy_poll);
 
 #else /* CONFIG_NET_RX_BUSY_POLL */
 static inline unsigned long net_busy_loop_on(void)
@@ -105,7 +105,8 @@ static inline void sk_busy_loop(struct sock *sk, int nonblock)
 	unsigned int napi_id = READ_ONCE(sk->sk_napi_id);
 
 	if (napi_id >= MIN_NAPI_ID)
-		napi_busy_loop(napi_id, nonblock ? NULL : sk_busy_loop_end, sk);
+		napi_busy_loop(napi_id, nonblock ? NULL : sk_busy_loop_end, sk,
+			       READ_ONCE(sk->sk_prefer_busy_poll));
 #endif
 }
 
diff --git a/include/net/sock.h b/include/net/sock.h
index 3c7addf95150..95311369567f 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -301,6 +301,7 @@ struct bpf_local_storage;
   *	@sk_ack_backlog: current listen backlog
   *	@sk_max_ack_backlog: listen backlog set in listen()
   *	@sk_uid: user id of owner
+  *	@sk_prefer_busy_poll: prefer busypolling over softirq processing
   *	@sk_priority: %SO_PRIORITY setting
   *	@sk_type: socket type (%SOCK_STREAM, etc)
   *	@sk_protocol: which protocol this socket belongs in this network family
@@ -479,6 +480,9 @@ struct sock {
 	u32			sk_ack_backlog;
 	u32			sk_max_ack_backlog;
 	kuid_t			sk_uid;
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	u8			sk_prefer_busy_poll;
+#endif
 	struct pid		*sk_peer_pid;
 	const struct cred	*sk_peer_cred;
 	long			sk_rcvtimeo;
diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index 77f7c1638eb1..7dd02408b7ce 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -119,6 +119,8 @@
 
 #define SO_DETACH_REUSEPORT_BPF 68
 
+#define SO_PREFER_BUSY_POLL	69
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
diff --git a/net/core/dev.c b/net/core/dev.c
index 2fdf30eefc59..6b08de52bf0e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6496,7 +6496,8 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 
 		WARN_ON_ONCE(!(val & NAPIF_STATE_SCHED));
 
-		new = val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED);
+		new = val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED |
+			      NAPIF_STATE_PREFER_BUSY_POLL);
 
 		/* If STATE_MISSED was set, leave STATE_SCHED set,
 		 * because we will call napi->poll() one more time.
@@ -6535,8 +6536,29 @@ static struct napi_struct *napi_by_id(unsigned int napi_id)
 
 #define BUSY_POLL_BUDGET 8
 
-static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock)
+static void __busy_poll_stop(struct napi_struct *napi, bool skip_schedule)
 {
+	if (!skip_schedule) {
+		gro_normal_list(napi);
+		__napi_schedule(napi);
+		return;
+	}
+
+	if (napi->gro_bitmask) {
+		/* flush too old packets
+		 * If HZ < 1000, flush all packets.
+		 */
+		napi_gro_flush(napi, HZ >= 1000);
+	}
+
+	gro_normal_list(napi);
+	clear_bit(NAPI_STATE_SCHED, &napi->state);
+}
+
+static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock, bool prefer_busy_poll)
+{
+	bool skip_schedule = false;
+	unsigned long timeout;
 	int rc;
 
 	/* Busy polling means there is a high chance device driver hard irq
@@ -6553,6 +6575,15 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock)
 
 	local_bh_disable();
 
+	if (prefer_busy_poll) {
+		napi->defer_hard_irqs_count = READ_ONCE(napi->dev->napi_defer_hard_irqs);
+		timeout = READ_ONCE(napi->dev->gro_flush_timeout);
+		if (napi->defer_hard_irqs_count && timeout) {
+			hrtimer_start(&napi->timer, ns_to_ktime(timeout), HRTIMER_MODE_REL_PINNED);
+			skip_schedule = true;
+		}
+	}
+
 	/* All we really want here is to re-enable device interrupts.
 	 * Ideally, a new ndo_busy_poll_stop() could avoid another round.
 	 */
@@ -6563,19 +6594,14 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock)
 	 */
 	trace_napi_poll(napi, rc, BUSY_POLL_BUDGET);
 	netpoll_poll_unlock(have_poll_lock);
-	if (rc == BUSY_POLL_BUDGET) {
-		/* As the whole budget was spent, we still own the napi so can
-		 * safely handle the rx_list.
-		 */
-		gro_normal_list(napi);
-		__napi_schedule(napi);
-	}
+	if (rc == BUSY_POLL_BUDGET)
+		__busy_poll_stop(napi, skip_schedule);
 	local_bh_enable();
 }
 
 void napi_busy_loop(unsigned int napi_id,
 		    bool (*loop_end)(void *, unsigned long),
-		    void *loop_end_arg)
+		    void *loop_end_arg, bool prefer_busy_poll)
 {
 	unsigned long start_time = loop_end ? busy_loop_current_time() : 0;
 	int (*napi_poll)(struct napi_struct *napi, int budget);
@@ -6603,12 +6629,18 @@ restart:
 			 * we avoid dirtying napi->state as much as we can.
 			 */
 			if (val & (NAPIF_STATE_DISABLE | NAPIF_STATE_SCHED |
-				   NAPIF_STATE_IN_BUSY_POLL))
+				   NAPIF_STATE_IN_BUSY_POLL)) {
+				if (prefer_busy_poll)
+					set_bit(NAPI_STATE_PREFER_BUSY_POLL, &napi->state);
 				goto count;
+			}
 			if (cmpxchg(&napi->state, val,
 				    val | NAPIF_STATE_IN_BUSY_POLL |
-					  NAPIF_STATE_SCHED) != val)
+					  NAPIF_STATE_SCHED) != val) {
+				if (prefer_busy_poll)
+					set_bit(NAPI_STATE_PREFER_BUSY_POLL, &napi->state);
 				goto count;
+			}
 			have_poll_lock = netpoll_poll_lock(napi);
 			napi_poll = napi->poll;
 		}
@@ -6626,7 +6658,7 @@ count:
 
 		if (unlikely(need_resched())) {
 			if (napi_poll)
-				busy_poll_stop(napi, have_poll_lock);
+				busy_poll_stop(napi, have_poll_lock, prefer_busy_poll);
 			preempt_enable();
 			rcu_read_unlock();
 			cond_resched();
@@ -6637,7 +6669,7 @@ count:
 		cpu_relax();
 	}
 	if (napi_poll)
-		busy_poll_stop(napi, have_poll_lock);
+		busy_poll_stop(napi, have_poll_lock, prefer_busy_poll);
 	preempt_enable();
 out:
 	rcu_read_unlock();
@@ -6688,8 +6720,10 @@ static enum hrtimer_restart napi_watchdog(struct hrtimer *timer)
 	 * NAPI_STATE_MISSED, since we do not react to a device IRQ.
 	 */
 	if (!napi_disable_pending(napi) &&
-	    !test_and_set_bit(NAPI_STATE_SCHED, &napi->state))
+	    !test_and_set_bit(NAPI_STATE_SCHED, &napi->state)) {
+		clear_bit(NAPI_STATE_PREFER_BUSY_POLL, &napi->state);
 		__napi_schedule_irqoff(napi);
+	}
 
 	return HRTIMER_NORESTART;
 }
@@ -6747,6 +6781,7 @@ void napi_disable(struct napi_struct *n)
 
 	hrtimer_cancel(&n->timer);
 
+	clear_bit(NAPI_STATE_PREFER_BUSY_POLL, &n->state);
 	clear_bit(NAPI_STATE_DISABLE, &n->state);
 }
 EXPORT_SYMBOL(napi_disable);
@@ -6819,6 +6854,19 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 		goto out_unlock;
 	}
 
+	/* The NAPI context has more processing work, but busy-polling
+	 * is preferred. Exit early.
+	 */
+	if (napi_prefer_busy_poll(n)) {
+		if (napi_complete_done(n, work)) {
+			/* If timeout is not set, we need to make sure
+			 * that the NAPI is re-scheduled.
+			 */
+			napi_schedule(n);
+		}
+		goto out_unlock;
+	}
+
 	if (n->gro_bitmask) {
 		/* flush too old packets
 		 * If HZ < 1000, flush all packets.
diff --git a/net/core/sock.c b/net/core/sock.c
index 7de51ea15cdf..cf0e5fc3a8ba 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1167,6 +1167,12 @@ set_sndbuf:
 				sk->sk_ll_usec = val;
 		}
 		break;
+	case SO_PREFER_BUSY_POLL:
+		if (valbool && !capable(CAP_NET_ADMIN))
+			ret = -EPERM;
+		else
+			WRITE_ONCE(sk->sk_prefer_busy_poll, valbool);
+		break;
 #endif
 
 	case SO_MAX_PACING_RATE:
@@ -1531,6 +1537,9 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 	case SO_BUSY_POLL:
 		v.val = sk->sk_ll_usec;
 		break;
+	case SO_PREFER_BUSY_POLL:
+		v.val = READ_ONCE(sk->sk_prefer_busy_poll);
+		break;
 #endif
 
 	case SO_MAX_PACING_RATE:
-- 
2.30.2



