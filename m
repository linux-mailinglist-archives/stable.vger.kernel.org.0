Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798813442C5
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhCVMpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:45:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:34112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232663AbhCVMnI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:43:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CCA4619BB;
        Mon, 22 Mar 2021 12:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416857;
        bh=kQzTkNmWoOH20H0aGo1hXNvC1nSjrt1CUgzu4rT3LBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKghO68AcnFzEnukb+utnB+9GogNSDRFYVB+f02/kA9F7sUJ7GZ5L2PgCjV1fLGjT
         OIsqdK0b9Uzbmk5E06yPaal9RGzFgDc/66X0aFNu50GKDUgNaFX/gNjmH7wnmSEhqM
         TECSigI/MHc9nR+MpVD4xWC+3rpP6I2GE174JYy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/157] mptcp: put subflow sock on connect error
Date:   Mon, 22 Mar 2021 13:27:41 +0100
Message-Id: <20210322121937.071435221@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 16adba172fb9..591546d0953f 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1133,6 +1133,7 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	spin_lock_bh(&msk->join_list_lock);
 	list_add_tail(&subflow->node, &msk->join_list);
 	spin_unlock_bh(&msk->join_list_lock);
+	sock_put(mptcp_subflow_tcp_sock(subflow));
 
 	return err;
 
-- 
2.30.1



