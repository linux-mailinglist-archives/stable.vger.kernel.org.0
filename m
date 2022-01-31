Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0FE84A42D2
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348444AbiAaLOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:14:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59978 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376267AbiAaLMX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:12:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC9C5B82A64;
        Mon, 31 Jan 2022 11:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B61FC36AFD;
        Mon, 31 Jan 2022 11:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627537;
        bh=qJjOC3jeyP1sScvdPR//Y7XWxhrb+2U9l24d6Z4ClvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xhKjuVYRBZOe3k2n1+S9UZVYyGGKWUoQ7hjAYxI9J8OF4sSPjiebTIaQPX0RxbrT8
         MMZ7bfiMsc8ivbzZrzlnYHDqoyWYoRoHQuDTER/4Hja36uRUey2167Y00Psb3jQ/2H
         ThRU0RiF7geQ74KQulc1duGsmMQyThKDVYuKW34Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/171] mptcp: keep track of local endpoint still available for each msk
Date:   Mon, 31 Jan 2022 11:56:21 +0100
Message-Id: <20220131105233.973519773@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 86e39e04482b0aadf3ee3ed5fcf2d63816559d36 ]

Include into the path manager status a bitmap tracking the list
of local endpoints still available - not yet used - for the
relevant mptcp socket.

Keep such map updated at endpoint creation/deletion time, so
that we can easily skip already used endpoint at local address
selection time.

The endpoint used by the initial subflow is lazyly accounted at
subflow creation time: the usage bitmap is be up2date before
endpoint selection and we avoid such unneeded task in some relevant
scenarios - e.g. busy servers accepting incoming subflows but
not creating any additional ones nor annuncing additional addresses.

Overall this allows for fair local endpoints usage in case of
subflow failure.

As a side effect, this patch also enforces that each endpoint
is used at most once for each mptcp connection.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm.c                                |   1 +
 net/mptcp/pm_netlink.c                        | 125 +++++++++++-------
 net/mptcp/protocol.c                          |   3 +-
 net/mptcp/protocol.h                          |  12 +-
 .../testing/selftests/net/mptcp/mptcp_join.sh |   5 +-
 5 files changed, 91 insertions(+), 55 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 6ab386ff32944..332ac6eda3ba4 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -370,6 +370,7 @@ void mptcp_pm_data_init(struct mptcp_sock *msk)
 	WRITE_ONCE(msk->pm.accept_subflow, false);
 	WRITE_ONCE(msk->pm.remote_deny_join_id0, false);
 	msk->pm.status = 0;
+	bitmap_fill(msk->pm.id_avail_bitmap, MPTCP_PM_MAX_ADDR_ID + 1);
 
 	spin_lock_init(&msk->pm.lock);
 	INIT_LIST_HEAD(&msk->pm.anno_list);
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 15c89d4fea4d2..bba166ddacc78 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -38,10 +38,6 @@ struct mptcp_pm_add_entry {
 	u8			retrans_times;
 };
 
-/* max value of mptcp_addr_info.id */
-#define MAX_ADDR_ID		U8_MAX
-#define BITMAP_SZ DIV_ROUND_UP(MAX_ADDR_ID + 1, BITS_PER_LONG)
-
 struct pm_nl_pernet {
 	/* protects pernet updates */
 	spinlock_t		lock;
@@ -53,14 +49,14 @@ struct pm_nl_pernet {
 	unsigned int		local_addr_max;
 	unsigned int		subflows_max;
 	unsigned int		next_id;
-	unsigned long		id_bitmap[BITMAP_SZ];
+	DECLARE_BITMAP(id_bitmap, MPTCP_PM_MAX_ADDR_ID + 1);
 };
 
 #define MPTCP_PM_ADDR_MAX	8
 #define ADD_ADDR_RETRANS_MAX	3
 
 static bool addresses_equal(const struct mptcp_addr_info *a,
-			    struct mptcp_addr_info *b, bool use_port)
+			    const struct mptcp_addr_info *b, bool use_port)
 {
 	bool addr_equals = false;
 
@@ -174,6 +170,9 @@ select_local_address(const struct pm_nl_pernet *pernet,
 		if (!(entry->flags & MPTCP_PM_ADDR_FLAG_SUBFLOW))
 			continue;
 
+		if (!test_bit(entry->addr.id, msk->pm.id_avail_bitmap))
+			continue;
+
 		if (entry->addr.family != sk->sk_family) {
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 			if ((entry->addr.family == AF_INET &&
@@ -184,23 +183,17 @@ select_local_address(const struct pm_nl_pernet *pernet,
 				continue;
 		}
 
-		/* avoid any address already in use by subflows and
-		 * pending join
-		 */
-		if (!lookup_subflow_by_saddr(&msk->conn_list, &entry->addr)) {
-			ret = entry;
-			break;
-		}
+		ret = entry;
+		break;
 	}
 	rcu_read_unlock();
 	return ret;
 }
 
 static struct mptcp_pm_addr_entry *
-select_signal_address(struct pm_nl_pernet *pernet, unsigned int pos)
+select_signal_address(struct pm_nl_pernet *pernet, struct mptcp_sock *msk)
 {
 	struct mptcp_pm_addr_entry *entry, *ret = NULL;
-	int i = 0;
 
 	rcu_read_lock();
 	/* do not keep any additional per socket state, just signal
@@ -209,12 +202,14 @@ select_signal_address(struct pm_nl_pernet *pernet, unsigned int pos)
 	 * can lead to additional addresses not being announced.
 	 */
 	list_for_each_entry_rcu(entry, &pernet->local_addr_list, list) {
+		if (!test_bit(entry->addr.id, msk->pm.id_avail_bitmap))
+			continue;
+
 		if (!(entry->flags & MPTCP_PM_ADDR_FLAG_SIGNAL))
 			continue;
-		if (i++ == pos) {
-			ret = entry;
-			break;
-		}
+
+		ret = entry;
+		break;
 	}
 	rcu_read_unlock();
 	return ret;
@@ -258,9 +253,11 @@ EXPORT_SYMBOL_GPL(mptcp_pm_get_local_addr_max);
 
 static void check_work_pending(struct mptcp_sock *msk)
 {
-	if (msk->pm.add_addr_signaled == mptcp_pm_get_add_addr_signal_max(msk) &&
-	    (msk->pm.local_addr_used == mptcp_pm_get_local_addr_max(msk) ||
-	     msk->pm.subflows == mptcp_pm_get_subflows_max(msk)))
+	struct pm_nl_pernet *pernet = net_generic(sock_net((struct sock *)msk), pm_nl_pernet_id);
+
+	if (msk->pm.subflows == mptcp_pm_get_subflows_max(msk) ||
+	    (find_next_and_bit(pernet->id_bitmap, msk->pm.id_avail_bitmap,
+			       MPTCP_PM_MAX_ADDR_ID + 1, 0) == MPTCP_PM_MAX_ADDR_ID + 1))
 		WRITE_ONCE(msk->pm.work_pending, false);
 }
 
@@ -460,6 +457,35 @@ static unsigned int fill_remote_addresses_vec(struct mptcp_sock *msk, bool fullm
 	return i;
 }
 
+static struct mptcp_pm_addr_entry *
+__lookup_addr_by_id(struct pm_nl_pernet *pernet, unsigned int id)
+{
+	struct mptcp_pm_addr_entry *entry;
+
+	list_for_each_entry(entry, &pernet->local_addr_list, list) {
+		if (entry->addr.id == id)
+			return entry;
+	}
+	return NULL;
+}
+
+static int
+lookup_id_by_addr(struct pm_nl_pernet *pernet, const struct mptcp_addr_info *addr)
+{
+	struct mptcp_pm_addr_entry *entry;
+	int ret = -1;
+
+	rcu_read_lock();
+	list_for_each_entry(entry, &pernet->local_addr_list, list) {
+		if (addresses_equal(&entry->addr, addr, entry->addr.port)) {
+			ret = entry->addr.id;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
 static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 {
 	struct sock *sk = (struct sock *)msk;
@@ -475,6 +501,19 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 	local_addr_max = mptcp_pm_get_local_addr_max(msk);
 	subflows_max = mptcp_pm_get_subflows_max(msk);
 
+	/* do lazy endpoint usage accounting for the MPC subflows */
+	if (unlikely(!(msk->pm.status & BIT(MPTCP_PM_MPC_ENDPOINT_ACCOUNTED))) && msk->first) {
+		struct mptcp_addr_info local;
+		int mpc_id;
+
+		local_address((struct sock_common *)msk->first, &local);
+		mpc_id = lookup_id_by_addr(pernet, &local);
+		if (mpc_id < 0)
+			__clear_bit(mpc_id, msk->pm.id_avail_bitmap);
+
+		msk->pm.status |= BIT(MPTCP_PM_MPC_ENDPOINT_ACCOUNTED);
+	}
+
 	pr_debug("local %d:%d signal %d:%d subflows %d:%d\n",
 		 msk->pm.local_addr_used, local_addr_max,
 		 msk->pm.add_addr_signaled, add_addr_signal_max,
@@ -482,21 +521,16 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 
 	/* check first for announce */
 	if (msk->pm.add_addr_signaled < add_addr_signal_max) {
-		local = select_signal_address(pernet,
-					      msk->pm.add_addr_signaled);
+		local = select_signal_address(pernet, msk);
 
 		if (local) {
 			if (mptcp_pm_alloc_anno_list(msk, local)) {
+				__clear_bit(local->addr.id, msk->pm.id_avail_bitmap);
 				msk->pm.add_addr_signaled++;
 				mptcp_pm_announce_addr(msk, &local->addr, false);
 				mptcp_pm_nl_addr_send_ack(msk);
 			}
-		} else {
-			/* pick failed, avoid fourther attempts later */
-			msk->pm.local_addr_used = add_addr_signal_max;
 		}
-
-		check_work_pending(msk);
 	}
 
 	/* check if should create a new subflow */
@@ -510,19 +544,16 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 			int i, nr;
 
 			msk->pm.local_addr_used++;
-			check_work_pending(msk);
 			nr = fill_remote_addresses_vec(msk, fullmesh, addrs);
+			if (nr)
+				__clear_bit(local->addr.id, msk->pm.id_avail_bitmap);
 			spin_unlock_bh(&msk->pm.lock);
 			for (i = 0; i < nr; i++)
 				__mptcp_subflow_connect(sk, &local->addr, &addrs[i]);
 			spin_lock_bh(&msk->pm.lock);
-			return;
 		}
-
-		/* lookup failed, avoid fourther attempts later */
-		msk->pm.local_addr_used = local_addr_max;
-		check_work_pending(msk);
 	}
+	check_work_pending(msk);
 }
 
 static void mptcp_pm_nl_fully_established(struct mptcp_sock *msk)
@@ -736,6 +767,7 @@ static void mptcp_pm_nl_rm_addr_or_subflow(struct mptcp_sock *msk,
 			msk->pm.subflows--;
 			__MPTCP_INC_STATS(sock_net(sk), rm_type);
 		}
+		__set_bit(rm_list->ids[1], msk->pm.id_avail_bitmap);
 		if (!removed)
 			continue;
 
@@ -765,6 +797,9 @@ void mptcp_pm_nl_work(struct mptcp_sock *msk)
 
 	msk_owned_by_me(msk);
 
+	if (!(pm->status & MPTCP_PM_WORK_MASK))
+		return;
+
 	spin_lock_bh(&msk->pm.lock);
 
 	pr_debug("msk=%p status=%x", msk, pm->status);
@@ -810,7 +845,7 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 	/* to keep the code simple, don't do IDR-like allocation for address ID,
 	 * just bail when we exceed limits
 	 */
-	if (pernet->next_id == MAX_ADDR_ID)
+	if (pernet->next_id == MPTCP_PM_MAX_ADDR_ID)
 		pernet->next_id = 1;
 	if (pernet->addrs >= MPTCP_PM_ADDR_MAX)
 		goto out;
@@ -830,7 +865,7 @@ static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 	if (!entry->addr.id) {
 find_next:
 		entry->addr.id = find_next_zero_bit(pernet->id_bitmap,
-						    MAX_ADDR_ID + 1,
+						    MPTCP_PM_MAX_ADDR_ID + 1,
 						    pernet->next_id);
 		if (!entry->addr.id && pernet->next_id != 1) {
 			pernet->next_id = 1;
@@ -1197,18 +1232,6 @@ static int mptcp_nl_cmd_add_addr(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
-static struct mptcp_pm_addr_entry *
-__lookup_addr_by_id(struct pm_nl_pernet *pernet, unsigned int id)
-{
-	struct mptcp_pm_addr_entry *entry;
-
-	list_for_each_entry(entry, &pernet->local_addr_list, list) {
-		if (entry->addr.id == id)
-			return entry;
-	}
-	return NULL;
-}
-
 int mptcp_pm_get_flags_and_ifindex_by_id(struct net *net, unsigned int id,
 					 u8 *flags, int *ifindex)
 {
@@ -1467,7 +1490,7 @@ static int mptcp_nl_cmd_flush_addrs(struct sk_buff *skb, struct genl_info *info)
 	list_splice_init(&pernet->local_addr_list, &free_list);
 	__reset_counters(pernet);
 	pernet->next_id = 1;
-	bitmap_zero(pernet->id_bitmap, MAX_ADDR_ID + 1);
+	bitmap_zero(pernet->id_bitmap, MPTCP_PM_MAX_ADDR_ID + 1);
 	spin_unlock_bh(&pernet->lock);
 	mptcp_nl_remove_addrs_list(sock_net(skb->sk), &free_list);
 	synchronize_rcu();
@@ -1577,7 +1600,7 @@ static int mptcp_nl_cmd_dump_addrs(struct sk_buff *msg,
 	pernet = net_generic(net, pm_nl_pernet_id);
 
 	spin_lock_bh(&pernet->lock);
-	for (i = id; i < MAX_ADDR_ID + 1; i++) {
+	for (i = id; i < MPTCP_PM_MAX_ADDR_ID + 1; i++) {
 		if (test_bit(i, pernet->id_bitmap)) {
 			entry = __lookup_addr_by_id(pernet, i);
 			if (!entry)
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 4c889552cde77..354f169ca120a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2435,8 +2435,7 @@ static void mptcp_worker(struct work_struct *work)
 
 	mptcp_check_fastclose(msk);
 
-	if (msk->pm.status)
-		mptcp_pm_nl_work(msk);
+	mptcp_pm_nl_work(msk);
 
 	if (test_and_clear_bit(MPTCP_WORK_EOF, &msk->flags))
 		mptcp_check_for_eof(msk);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 82c5dc4d6b49d..9fc6f494075fa 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -174,16 +174,25 @@ enum mptcp_pm_status {
 	MPTCP_PM_ADD_ADDR_SEND_ACK,
 	MPTCP_PM_RM_ADDR_RECEIVED,
 	MPTCP_PM_ESTABLISHED,
-	MPTCP_PM_ALREADY_ESTABLISHED,	/* persistent status, set after ESTABLISHED event */
 	MPTCP_PM_SUBFLOW_ESTABLISHED,
+	MPTCP_PM_ALREADY_ESTABLISHED,	/* persistent status, set after ESTABLISHED event */
+	MPTCP_PM_MPC_ENDPOINT_ACCOUNTED /* persistent status, set after MPC local address is
+					 * accounted int id_avail_bitmap
+					 */
 };
 
+/* Status bits below MPTCP_PM_ALREADY_ESTABLISHED need pm worker actions */
+#define MPTCP_PM_WORK_MASK ((1 << MPTCP_PM_ALREADY_ESTABLISHED) - 1)
+
 enum mptcp_addr_signal_status {
 	MPTCP_ADD_ADDR_SIGNAL,
 	MPTCP_ADD_ADDR_ECHO,
 	MPTCP_RM_ADDR_SIGNAL,
 };
 
+/* max value of mptcp_addr_info.id */
+#define MPTCP_PM_MAX_ADDR_ID		U8_MAX
+
 struct mptcp_pm_data {
 	struct mptcp_addr_info local;
 	struct mptcp_addr_info remote;
@@ -202,6 +211,7 @@ struct mptcp_pm_data {
 	u8		local_addr_used;
 	u8		subflows;
 	u8		status;
+	DECLARE_BITMAP(id_avail_bitmap, MPTCP_PM_MAX_ADDR_ID + 1);
 	struct mptcp_rm_list rm_list_tx;
 	struct mptcp_rm_list rm_list_rx;
 };
diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 586af88194e56..0c12602fa22e8 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1068,7 +1068,10 @@ signal_address_tests()
 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags signal
 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags signal
 	run_tests $ns1 $ns2 10.0.1.1
-	chk_add_nr 4 4
+
+	# the server will not signal the address terminating
+	# the MPC subflow
+	chk_add_nr 3 3
 }
 
 link_failure_tests()
-- 
2.34.1



