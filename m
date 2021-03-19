Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA94341C83
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhCSMVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:21:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230527AbhCSMUr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:20:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01C6964F6A;
        Fri, 19 Mar 2021 12:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156446;
        bh=js529rVkBkIZs0DCJLRCuffamEhj/InIOopjlbZe69s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oU8Aw7xUoLlvdfETmR1UcKyiCnuz70IvplUDZguni0qLDEeEnoJr6id1UX9uqeyPX
         nqbDtBEevIRz+rewWxX9mTvr7dIWkrk8GenOadWKZwCZl9shYT7cmelHRW1imiMPaO
         3sviDA0eHAWkoW03Qq7kd8sWYCJcoAAV9GeEVPjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 04/31] mptcp: send ack for every add_addr
Date:   Fri, 19 Mar 2021 13:18:58 +0100
Message-Id: <20210319121747.349516748@linuxfoundation.org>
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

From: Geliang Tang <geliangtang@gmail.com>

[ Upstream commit b5a7acd3bd63c7430c98d7f66d0aa457c9ccde30 ]

This patch changes the sending ACK conditions for the ADD_ADDR, send an
ACK packet for any ADD_ADDR, not just when ipv6 addresses or port
numbers are included.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/139
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm.c         |  3 +--
 net/mptcp/pm_netlink.c | 10 ++++------
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index da2ed576f289..5463d7c8c931 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -188,8 +188,7 @@ void mptcp_pm_add_addr_received(struct mptcp_sock *msk,
 
 void mptcp_pm_add_addr_send_ack(struct mptcp_sock *msk)
 {
-	if (!mptcp_pm_should_add_signal_ipv6(msk) &&
-	    !mptcp_pm_should_add_signal_port(msk))
+	if (!mptcp_pm_should_add_signal(msk))
 		return;
 
 	mptcp_pm_schedule_work(msk, MPTCP_PM_ADD_ADDR_SEND_ACK);
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index a6d983d80576..b81ce0ea1f8b 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -408,8 +408,7 @@ void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow;
 
-	if (!mptcp_pm_should_add_signal_ipv6(msk) &&
-	    !mptcp_pm_should_add_signal_port(msk))
+	if (!mptcp_pm_should_add_signal(msk))
 		return;
 
 	__mptcp_flush_join_list(msk);
@@ -419,10 +418,9 @@ void mptcp_pm_nl_add_addr_send_ack(struct mptcp_sock *msk)
 		u8 add_addr;
 
 		spin_unlock_bh(&msk->pm.lock);
-		if (mptcp_pm_should_add_signal_ipv6(msk))
-			pr_debug("send ack for add_addr6");
-		if (mptcp_pm_should_add_signal_port(msk))
-			pr_debug("send ack for add_addr_port");
+		pr_debug("send ack for add_addr%s%s",
+			 mptcp_pm_should_add_signal_ipv6(msk) ? " [ipv6]" : "",
+			 mptcp_pm_should_add_signal_port(msk) ? " [port]" : "");
 
 		lock_sock(ssk);
 		tcp_send_ack(ssk);
-- 
2.30.1



