Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E3449A059
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1843846AbiAXXG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:06:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1842389AbiAXXBr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:01:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DC6C0F0551;
        Mon, 24 Jan 2022 13:13:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83D646147D;
        Mon, 24 Jan 2022 21:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C436C340E5;
        Mon, 24 Jan 2022 21:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058834;
        bh=hu2038tPn5JoE1cXR2b9Gyfb0XVbNKodylO5hpbvfNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GD7/bqbj7wEFCekn2sjHrkoyoF8XSvWCbCN9hUCJJ6JZvS6qrHCS8n0tTpV7Kjabz
         0g8A0tfPQpgxQmsiscU0sYDP+pvHghQVSryNBOJ5ocBr7ZjGLNbt/ZNjdygwEDfHJ/
         B5j/dNhYyqVK/7ICSN0i2e7jmNBWAyraLoXD9CeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0418/1039] mptcp: fix per socket endpoint accounting
Date:   Mon, 24 Jan 2022 19:36:47 +0100
Message-Id: <20220124184139.360599133@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit f7d6a237d7422809d458d754016de2844017cb4d ]

Since full-mesh endpoint support, the reception of a single ADD_ADDR
option can cause multiple subflows creation. When such option is
accepted we increment 'add_addr_accepted' by one. When we received
a paired RM_ADDR option, we deleted all the relevant subflows,
decrementing 'add_addr_accepted' by one for each of them.

We have a similar issue for 'local_addr_used'

Fix them moving the pm endpoint accounting outside the subflow
traversal.

Fixes: 1a0d6136c5f0 ("mptcp: local addresses fullmesh")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index f523051f5aef3..65764c8171b37 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -710,6 +710,8 @@ static void mptcp_pm_nl_rm_addr_or_subflow(struct mptcp_sock *msk,
 		return;
 
 	for (i = 0; i < rm_list->nr; i++) {
+		bool removed = false;
+
 		list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
 			struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 			int how = RCV_SHUTDOWN | SEND_SHUTDOWN;
@@ -729,15 +731,19 @@ static void mptcp_pm_nl_rm_addr_or_subflow(struct mptcp_sock *msk,
 			mptcp_close_ssk(sk, ssk, subflow);
 			spin_lock_bh(&msk->pm.lock);
 
-			if (rm_type == MPTCP_MIB_RMADDR) {
-				msk->pm.add_addr_accepted--;
-				WRITE_ONCE(msk->pm.accept_addr, true);
-			} else if (rm_type == MPTCP_MIB_RMSUBFLOW) {
-				msk->pm.local_addr_used--;
-			}
+			removed = true;
 			msk->pm.subflows--;
 			__MPTCP_INC_STATS(sock_net(sk), rm_type);
 		}
+		if (!removed)
+			continue;
+
+		if (rm_type == MPTCP_MIB_RMADDR) {
+			msk->pm.add_addr_accepted--;
+			WRITE_ONCE(msk->pm.accept_addr, true);
+		} else if (rm_type == MPTCP_MIB_RMSUBFLOW) {
+			msk->pm.local_addr_used--;
+		}
 	}
 }
 
-- 
2.34.1



