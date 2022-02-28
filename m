Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C24FC4C75D1
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbiB1R4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234827AbiB1Ryq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CBAF2B;
        Mon, 28 Feb 2022 09:44:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F383B81085;
        Mon, 28 Feb 2022 17:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F2AC340E7;
        Mon, 28 Feb 2022 17:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070245;
        bh=TQEvo4SlinlRCuCloRelj2WzOa4s+iA4H9FM7v2aA1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p2VXuByLqeKUqyWfEXMsP2hbkTYrOARLPlovdasaP8tgHehnRLq+mQLbRHDXZ3Ewa
         ErWenudfie/SSFBDC5U4Av96J5+Xsn55T6nMGZUy9Ay5WyLgipDIxg7ZoLIROFFNV/
         ScxQq8Tttlj+X3Xs7EmBM5Grwf6FUTPEGN/nJQgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 038/164] mptcp: fix race in incoming ADD_ADDR option processing
Date:   Mon, 28 Feb 2022 18:23:20 +0100
Message-Id: <20220228172403.732021961@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

commit 837cf45df163a3780bc04b555700231e95b31dc9 upstream.

If an MPTCP endpoint received multiple consecutive incoming
ADD_ADDR options, mptcp_pm_add_addr_received() can overwrite
the current remote address value after the PM lock is released
in mptcp_pm_nl_add_addr_received() and before such address
is echoed.

Fix the issue caching the remote address value a little earlier
and always using the cached value after releasing the PM lock.

Fixes: f7efc7771eac ("mptcp: drop argument port from mptcp_pm_announce_addr")
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -606,6 +606,7 @@ static void mptcp_pm_nl_add_addr_receive
 	unsigned int add_addr_accept_max;
 	struct mptcp_addr_info remote;
 	unsigned int subflows_max;
+	bool reset_port = false;
 	int i, nr;
 
 	add_addr_accept_max = mptcp_pm_get_add_addr_accept_max(msk);
@@ -615,15 +616,19 @@ static void mptcp_pm_nl_add_addr_receive
 		 msk->pm.add_addr_accepted, add_addr_accept_max,
 		 msk->pm.remote.family);
 
-	if (lookup_subflow_by_daddr(&msk->conn_list, &msk->pm.remote))
+	remote = msk->pm.remote;
+	if (lookup_subflow_by_daddr(&msk->conn_list, &remote))
 		goto add_addr_echo;
 
+	/* pick id 0 port, if none is provided the remote address */
+	if (!remote.port) {
+		reset_port = true;
+		remote.port = sk->sk_dport;
+	}
+
 	/* connect to the specified remote address, using whatever
 	 * local address the routing configuration will pick.
 	 */
-	remote = msk->pm.remote;
-	if (!remote.port)
-		remote.port = sk->sk_dport;
 	nr = fill_local_addresses_vec(msk, addrs);
 
 	msk->pm.add_addr_accepted++;
@@ -636,8 +641,12 @@ static void mptcp_pm_nl_add_addr_receive
 		__mptcp_subflow_connect(sk, &addrs[i], &remote);
 	spin_lock_bh(&msk->pm.lock);
 
+	/* be sure to echo exactly the received address */
+	if (reset_port)
+		remote.port = 0;
+
 add_addr_echo:
-	mptcp_pm_announce_addr(msk, &msk->pm.remote, true);
+	mptcp_pm_announce_addr(msk, &remote, true);
 	mptcp_pm_nl_addr_send_ack(msk);
 }
 


