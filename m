Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9AF3215F8
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhBVMPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:15:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230296AbhBVMOv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:14:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C30164F04;
        Mon, 22 Feb 2021 12:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996041;
        bh=4EOEIar5w3owvOWf/YV6gO4rfvd44ZBDkwIEZooU3g4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZsPRjvASM72C5kNXGCDZA/xmbgzd6MLlHEqJXOm2EW1gURjd1KsNQOMtQMycai/aA
         A7kZC4YsQBSMXojy0wirJf3UCo9uyZrRi1vUB+lJNEso4dm8zv4gZY5LOKMUjvcAu8
         N9wPslN2xiUktb+UhGilLuIvVOh6RLR+DX6vswsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonatan Linik <yonatanlinik@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 15/29] net: fix proc_fs init handling in af_packet and tls
Date:   Mon, 22 Feb 2021 13:13:09 +0100
Message-Id: <20210222121022.233608866@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.444399883@linuxfoundation.org>
References: <20210222121019.444399883@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonatan Linik <yonatanlinik@gmail.com>

[ Upstream commit a268e0f2455c32653140775662b40c2b1f1b2efa ]

proc_fs was used, in af_packet, without a surrounding #ifdef,
although there is no hard dependency on proc_fs.
That caused the initialization of the af_packet module to fail
when CONFIG_PROC_FS=n.

Specifically, proc_create_net() was used in af_packet.c,
and when it fails, packet_net_init() returns -ENOMEM.
It will always fail when the kernel is compiled without proc_fs,
because, proc_create_net() for example always returns NULL.

The calling order that starts in af_packet.c is as follows:
packet_init()
register_pernet_subsys()
register_pernet_operations()
__register_pernet_operations()
ops_init()
ops->init() (packet_net_ops.init=packet_net_init())
proc_create_net()

It worked in the past because register_pernet_subsys()'s return value
wasn't checked before this Commit 36096f2f4fa0 ("packet: Fix error path in
packet_init.").
It always returned an error, but was not checked before, so everything
was working even when CONFIG_PROC_FS=n.

The fix here is simply to add the necessary #ifdef.

This also fixes a similar error in tls_proc.c, that was found by Jakub
Kicinski.

Fixes: d26b698dd3cd ("net/tls: add skeleton of MIB statistics")
Fixes: 36096f2f4fa0 ("packet: Fix error path in packet_init")
Signed-off-by: Yonatan Linik <yonatanlinik@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 2 ++
 net/tls/tls_proc.c     | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 7a18ffff85514..a0121e7c98b14 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4615,9 +4615,11 @@ static int __net_init packet_net_init(struct net *net)
 	mutex_init(&net->packet.sklist_lock);
 	INIT_HLIST_HEAD(&net->packet.sklist);
 
+#ifdef CONFIG_PROC_FS
 	if (!proc_create_net("packet", 0, net->proc_net, &packet_seq_ops,
 			sizeof(struct seq_net_private)))
 		return -ENOMEM;
+#endif /* CONFIG_PROC_FS */
 
 	return 0;
 }
diff --git a/net/tls/tls_proc.c b/net/tls/tls_proc.c
index 3a5dd1e072332..feeceb0e4cb48 100644
--- a/net/tls/tls_proc.c
+++ b/net/tls/tls_proc.c
@@ -37,9 +37,12 @@ static int tls_statistics_seq_show(struct seq_file *seq, void *v)
 
 int __net_init tls_proc_init(struct net *net)
 {
+#ifdef CONFIG_PROC_FS
 	if (!proc_create_net_single("tls_stat", 0444, net->proc_net,
 				    tls_statistics_seq_show, NULL))
 		return -ENOMEM;
+#endif /* CONFIG_PROC_FS */
+
 	return 0;
 }
 
-- 
2.27.0



