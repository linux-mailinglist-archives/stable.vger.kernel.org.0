Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF963136D9
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbhBHPQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:16:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:55232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232955AbhBHPLr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:11:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3124164EEB;
        Mon,  8 Feb 2021 15:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796926;
        bh=+rXr+71ROZWrElgAVo1ZF+3aCSdzVLOjlEfPqRpA8A0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XdXAy8p39g/7+s2pBHjviT3hpGcYH5feHQwekc0Du0OmilTBjgYDuplTauxagnOwt
         lfjI5KVRJ9ZopYPklyq9CSSAz0960PDvwruXKaceGCi0Ti3ToIq20CGOGpuNtNKMLX
         aasWiCPocVrUsRHANHq8AqYg2BOYYqWrsEUs46zY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+df400f2f24a1677cd7e0@syzkaller.appspotmail.com,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        David Howells <dhowells@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/38] rxrpc: Fix deadlock around release of dst cached on udp tunnel
Date:   Mon,  8 Feb 2021 16:00:53 +0100
Message-Id: <20210208145806.394957674@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145806.141056364@linuxfoundation.org>
References: <20210208145806.141056364@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 5399d52233c47905bbf97dcbaa2d7a9cc31670ba ]

AF_RXRPC sockets use UDP ports in encap mode.  This causes socket and dst
from an incoming packet to get stolen and attached to the UDP socket from
whence it is leaked when that socket is closed.

When a network namespace is removed, the wait for dst records to be cleaned
up happens before the cleanup of the rxrpc and UDP socket, meaning that the
wait never finishes.

Fix this by moving the rxrpc (and, by dependence, the afs) private
per-network namespace registrations to the device group rather than subsys
group.  This allows cached rxrpc local endpoints to be cleared and their
UDP sockets closed before we try waiting for the dst records.

The symptom is that lines looking like the following:

	unregister_netdevice: waiting for lo to become free

get emitted at regular intervals after running something like the
referenced syzbot test.

Thanks to Vadim for tracking this down and work out the fix.

Reported-by: syzbot+df400f2f24a1677cd7e0@syzkaller.appspotmail.com
Reported-by: Vadim Fedorenko <vfedorenko@novek.ru>
Fixes: 5271953cad31 ("rxrpc: Use the UDP encap_rcv hook")
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Vadim Fedorenko <vfedorenko@novek.ru>
Link: https://lore.kernel.org/r/161196443016.3868642.5577440140646403533.stgit@warthog.procyon.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/main.c        | 6 +++---
 net/rxrpc/af_rxrpc.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/afs/main.c b/fs/afs/main.c
index 107427688eddd..8ecb127be63f9 100644
--- a/fs/afs/main.c
+++ b/fs/afs/main.c
@@ -190,7 +190,7 @@ static int __init afs_init(void)
 		goto error_cache;
 #endif
 
-	ret = register_pernet_subsys(&afs_net_ops);
+	ret = register_pernet_device(&afs_net_ops);
 	if (ret < 0)
 		goto error_net;
 
@@ -210,7 +210,7 @@ static int __init afs_init(void)
 error_proc:
 	afs_fs_exit();
 error_fs:
-	unregister_pernet_subsys(&afs_net_ops);
+	unregister_pernet_device(&afs_net_ops);
 error_net:
 #ifdef CONFIG_AFS_FSCACHE
 	fscache_unregister_netfs(&afs_cache_netfs);
@@ -241,7 +241,7 @@ static void __exit afs_exit(void)
 
 	proc_remove(afs_proc_symlink);
 	afs_fs_exit();
-	unregister_pernet_subsys(&afs_net_ops);
+	unregister_pernet_device(&afs_net_ops);
 #ifdef CONFIG_AFS_FSCACHE
 	fscache_unregister_netfs(&afs_cache_netfs);
 #endif
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 57f835d2442ec..fb7e3fffcb5ef 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -1010,7 +1010,7 @@ static int __init af_rxrpc_init(void)
 		goto error_security;
 	}
 
-	ret = register_pernet_subsys(&rxrpc_net_ops);
+	ret = register_pernet_device(&rxrpc_net_ops);
 	if (ret)
 		goto error_pernet;
 
@@ -1055,7 +1055,7 @@ error_key_type:
 error_sock:
 	proto_unregister(&rxrpc_proto);
 error_proto:
-	unregister_pernet_subsys(&rxrpc_net_ops);
+	unregister_pernet_device(&rxrpc_net_ops);
 error_pernet:
 	rxrpc_exit_security();
 error_security:
@@ -1077,7 +1077,7 @@ static void __exit af_rxrpc_exit(void)
 	unregister_key_type(&key_type_rxrpc);
 	sock_unregister(PF_RXRPC);
 	proto_unregister(&rxrpc_proto);
-	unregister_pernet_subsys(&rxrpc_net_ops);
+	unregister_pernet_device(&rxrpc_net_ops);
 	ASSERTCMP(atomic_read(&rxrpc_n_tx_skbs), ==, 0);
 	ASSERTCMP(atomic_read(&rxrpc_n_rx_skbs), ==, 0);
 
-- 
2.27.0



