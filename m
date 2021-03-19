Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A443E341C81
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhCSMVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:21:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231126AbhCSMUt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:20:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 521E96146D;
        Fri, 19 Mar 2021 12:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156448;
        bh=Xl0GnYlS++rdo/imaGNZlPFHSGqgcPjokDVxiOQmvwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eKADrYeK+Za+39OOGL8bMkHXYazAtPApvdM32agI4A0f/XOHktI59k4TZKxxB/0gC
         6coMAkc5nqM+x76wrIN0J9CicO4yF6a9ZWpRTq/7/fMt3x+VGr5q2IM+2xS3FF8aYG
         czAl7rMfZbKI/fs+JkGUB/Y0pkgpu276XS7BCpBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 05/31] mptcp: pm: add lockdep assertions
Date:   Fri, 19 Mar 2021 13:18:59 +0100
Message-Id: <20210319121747.386027429@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121747.203523570@linuxfoundation.org>
References: <20210319121747.203523570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 3abc05d9ef6fe989706b679e1e6371d6360d3db4 ]

Add a few assertions to make sure functions are called with the needed
locks held.
Two functions gain might_sleep annotations because they contain
conditional calls to functions that sleep.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm.c         |  2 ++
 net/mptcp/pm_netlink.c | 13 +++++++++++++
 net/mptcp/protocol.c   |  4 ++++
 net/mptcp/protocol.h   |  5 +++++
 4 files changed, 24 insertions(+)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 5463d7c8c931..1c01c3bcbf5a 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -20,6 +20,8 @@ int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 
 	pr_debug("msk=%p, local_id=%d", msk, addr->id);
 
+	lockdep_assert_held(&msk->pm.lock);
+
 	if (add_addr) {
 		pr_warn("addr_signal error, add_addr=%d", add_addr);
 		return -EINVAL;
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index b81ce0ea1f8b..71c41b948861 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -134,6 +134,8 @@ select_local_address(const struct pm_nl_pernet *pernet,
 {
 	struct mptcp_pm_addr_entry *entry, *ret = NULL;
 
+	msk_owned_by_me(msk);
+
 	rcu_read_lock();
 	__mptcp_flush_join_list(msk);
 	list_for_each_entry_rcu(entry, &pernet->local_addr_list, list) {
@@ -191,6 +193,8 @@ lookup_anno_list_by_saddr(struct mptcp_sock *msk,
 {
 	struct mptcp_pm_add_entry *entry;
 
+	lockdep_assert_held(&msk->pm.lock);
+
 	list_for_each_entry(entry, &msk->pm.anno_list, list) {
 		if (addresses_equal(&entry->addr, addr, false))
 			return entry;
@@ -266,6 +270,8 @@ static bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
 	struct sock *sk = (struct sock *)msk;
 	struct net *net = sock_net(sk);
 
+	lockdep_assert_held(&msk->pm.lock);
+
 	if (lookup_anno_list_by_saddr(msk, &entry->addr))
 		return false;
 
@@ -408,6 +414,9 @@ void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow;
 
+	msk_owned_by_me(msk);
+	lockdep_assert_held(&msk->pm.lock);
+
 	if (!mptcp_pm_should_add_signal(msk))
 		return;
 
@@ -443,6 +452,8 @@ void mptcp_pm_nl_rm_addr_received(struct mptcp_sock *msk)
 
 	pr_debug("address rm_id %d", msk->pm.rm_id);
 
+	msk_owned_by_me(msk);
+
 	if (!msk->pm.rm_id)
 		return;
 
@@ -478,6 +489,8 @@ void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk, u8 rm_id)
 
 	pr_debug("subflow rm_id %d", rm_id);
 
+	msk_owned_by_me(msk);
+
 	if (!rm_id)
 		return;
 
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 056846eb2e5b..64b8a49652ae 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2186,6 +2186,8 @@ static void __mptcp_close_subflow(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow, *tmp;
 
+	might_sleep();
+
 	list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
@@ -2529,6 +2531,8 @@ static void __mptcp_destroy_sock(struct sock *sk)
 
 	pr_debug("msk=%p", msk);
 
+	might_sleep();
+
 	/* dispose the ancillatory tcp socket, if any */
 	if (msk->subflow) {
 		iput(SOCK_INODE(msk->subflow));
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 18fef4273bdc..c374345ad134 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -286,6 +286,11 @@ struct mptcp_sock {
 #define mptcp_for_each_subflow(__msk, __subflow)			\
 	list_for_each_entry(__subflow, &((__msk)->conn_list), node)
 
+static inline void msk_owned_by_me(const struct mptcp_sock *msk)
+{
+	sock_owned_by_me((const struct sock *)msk);
+}
+
 static inline struct mptcp_sock *mptcp_sk(const struct sock *sk)
 {
 	return (struct mptcp_sock *)sk;
-- 
2.30.1



