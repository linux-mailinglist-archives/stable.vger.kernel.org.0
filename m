Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C94D6133358
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbgAGVRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:17:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:52210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729246AbgAGVFc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:05:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B96CC20880;
        Tue,  7 Jan 2020 21:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431131;
        bh=McbvTobzyC0pAT1LhARxNTpZOgqqYc8/Yj0GOxRKUzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cuRf82hWEKdF4q1XgQjJGlgtisYoX1nvdwcZHp67ToFTypNmQ9tWXWv3hu+cYimrQ
         0Oj6K3n37Be+CxnyDc6ztAudsulm/9YxD2tvvip+Lv/nIPt8TDRPSsxCuB8YhZX1VU
         wXPFfxwSowCVvW2HeqSZoUkspa1ww1Y7OHFuBa3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 010/115] afs: Fix afs_find_server lookups for ipv4 peers
Date:   Tue,  7 Jan 2020 21:53:40 +0100
Message-Id: <20200107205246.338082294@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Dionne <marc.dionne@auristor.com>

[ Upstream commit 9bd0160d12370a076e44f8d1320cde9c83f2c647 ]

afs_find_server tries to find a server that has an address that
matches the transport address of an rxrpc peer.  The code assumes
that the transport address is always ipv6, with ipv4 represented
as ipv4 mapped addresses, but that's not the case.  If the transport
family is AF_INET, srx->transport.sin6.sin6_addr.s6_addr32[] will
be beyond the actual ipv4 address and will always be 0, and all
ipv4 addresses will be seen as matching.

As a result, the first ipv4 address seen on any server will be
considered a match, and the server returned may be the wrong one.

One of the consequences is that callbacks received over ipv4 will
only be correctly applied for the server that happens to have the
first ipv4 address on the fs_addresses4 list.  Callbacks over ipv4
from all other servers are dropped, causing the client to serve stale
data.

This is fixed by looking at the transport family, and comparing ipv4
addresses based on a sockaddr_in structure rather than a sockaddr_in6.

Fixes: d2ddc776a458 ("afs: Overhaul volume and server record caching and fileserver rotation")
Signed-off-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/server.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/afs/server.c b/fs/afs/server.c
index 1d329e6981d5..2c7f6211c360 100644
--- a/fs/afs/server.c
+++ b/fs/afs/server.c
@@ -34,18 +34,11 @@ static void afs_dec_servers_outstanding(struct afs_net *net)
 struct afs_server *afs_find_server(struct afs_net *net,
 				   const struct sockaddr_rxrpc *srx)
 {
-	const struct sockaddr_in6 *a = &srx->transport.sin6, *b;
 	const struct afs_addr_list *alist;
 	struct afs_server *server = NULL;
 	unsigned int i;
-	bool ipv6 = true;
 	int seq = 0, diff;
 
-	if (srx->transport.sin6.sin6_addr.s6_addr32[0] == 0 ||
-	    srx->transport.sin6.sin6_addr.s6_addr32[1] == 0 ||
-	    srx->transport.sin6.sin6_addr.s6_addr32[2] == htonl(0xffff))
-		ipv6 = false;
-
 	rcu_read_lock();
 
 	do {
@@ -54,7 +47,8 @@ struct afs_server *afs_find_server(struct afs_net *net,
 		server = NULL;
 		read_seqbegin_or_lock(&net->fs_addr_lock, &seq);
 
-		if (ipv6) {
+		if (srx->transport.family == AF_INET6) {
+			const struct sockaddr_in6 *a = &srx->transport.sin6, *b;
 			hlist_for_each_entry_rcu(server, &net->fs_addresses6, addr6_link) {
 				alist = rcu_dereference(server->addresses);
 				for (i = alist->nr_ipv4; i < alist->nr_addrs; i++) {
@@ -70,15 +64,16 @@ struct afs_server *afs_find_server(struct afs_net *net,
 				}
 			}
 		} else {
+			const struct sockaddr_in *a = &srx->transport.sin, *b;
 			hlist_for_each_entry_rcu(server, &net->fs_addresses4, addr4_link) {
 				alist = rcu_dereference(server->addresses);
 				for (i = 0; i < alist->nr_ipv4; i++) {
-					b = &alist->addrs[i].transport.sin6;
-					diff = ((u16 __force)a->sin6_port -
-						(u16 __force)b->sin6_port);
+					b = &alist->addrs[i].transport.sin;
+					diff = ((u16 __force)a->sin_port -
+						(u16 __force)b->sin_port);
 					if (diff == 0)
-						diff = ((u32 __force)a->sin6_addr.s6_addr32[3] -
-							(u32 __force)b->sin6_addr.s6_addr32[3]);
+						diff = ((u32 __force)a->sin_addr.s_addr -
+							(u32 __force)b->sin_addr.s_addr);
 					if (diff == 0)
 						goto found;
 				}
-- 
2.20.1



