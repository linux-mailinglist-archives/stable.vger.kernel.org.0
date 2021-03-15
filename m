Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162BC33BA65
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235090AbhCOOJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229868AbhCOODa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5601264E83;
        Mon, 15 Mar 2021 14:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817009;
        bh=dnOEBefTkEQGovmqEsF2IJREFw23MOB2niidlyjTGZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qEFWn9K8k1eOze1yADrE3e0j9N3kpCzoXzquRx8PAgWZzuoLtoWBf99y20IYy+Jig
         oLOj6FrccR2xXBRnxvZgHsdfgVarqaEqdtRVGffDS4A4thZ+mNGQ+foZ0zPuW7j9J/
         1zKZodbsdHPraGp/MlmFOrTLvaWFhQKwJT2zRzuM=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 258/306] mptcp: put subflow sock on connect error
Date:   Mon, 15 Mar 2021 14:55:21 +0100
Message-Id: <20210315135516.368742595@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Florian Westphal <fw@strlen.de>

[ Upstream commit f07157792c633b528de5fc1dbe2e4ea54f8e09d4 ]

mptcp_add_pending_subflow() performs a sock_hold() on the subflow,
then adds the subflow to the join list.

Without a sock_put the subflow sk won't be freed in case connect() fails.

unreferenced object 0xffff88810c03b100 (size 3000):
[..]
    sk_prot_alloc.isra.0+0x2f/0x110
    sk_alloc+0x5d/0xc20
    inet6_create+0x2b7/0xd30
    __sock_create+0x17f/0x410
    mptcp_subflow_create_socket+0xff/0x9c0
    __mptcp_subflow_connect+0x1da/0xaf0
    mptcp_pm_nl_work+0x6e0/0x1120
    mptcp_worker+0x508/0x9a0

Fixes: 5b950ff4331ddda ("mptcp: link MPC subflow into msk only after accept")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/subflow.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 81b7be67d288..c3090003a17b 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1174,6 +1174,7 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	spin_lock_bh(&msk->join_list_lock);
 	list_del(&subflow->node);
 	spin_unlock_bh(&msk->join_list_lock);
+	sock_put(mptcp_subflow_tcp_sock(subflow));
 
 failed:
 	subflow->disposable = 1;
-- 
2.30.1



