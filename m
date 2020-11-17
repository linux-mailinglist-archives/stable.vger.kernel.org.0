Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0D52B61B4
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730870AbgKQNV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:21:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:55008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730686AbgKQNV1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:21:27 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0C92221FE;
        Tue, 17 Nov 2020 13:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619285;
        bh=hxBy64WOkcWKsRbU6YVf+Px82Buu2aX919pv4bVlwlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gtZksDGeFrx8GHyf9XuETbsG3HwYikEihu1gi2egeYXppvITaoDRkiONJDE7hZSgU
         Vi48wmUF5OjGlE+134Js4GVsRYTW/ZJ8XzqnVKGy4Ouq+008GGURHZ25UTktykAhEC
         Tjqrew/aL7i8JugdvKe4wNkCO9flgUiy1gYogEUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 091/101] tipc: fix memory leak in tipc_topsrv_start()
Date:   Tue, 17 Nov 2020 14:05:58 +0100
Message-Id: <20201117122117.568350702@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit fa6882c63621821f73cc806f291208e1c6ea6187 ]

kmemleak report a memory leak as follows:

unreferenced object 0xffff88810a596800 (size 512):
  comm "ip", pid 21558, jiffies 4297568990 (age 112.120s)
  hex dump (first 32 bytes):
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
    ff ff ff ff ff ff ff ff 00 83 60 b0 ff ff ff ff  ..........`.....
  backtrace:
    [<0000000022bbe21f>] tipc_topsrv_init_net+0x1f3/0xa70
    [<00000000fe15ddf7>] ops_init+0xa8/0x3c0
    [<00000000138af6f2>] setup_net+0x2de/0x7e0
    [<000000008c6807a3>] copy_net_ns+0x27d/0x530
    [<000000006b21adbd>] create_new_namespaces+0x382/0xa30
    [<00000000bb169746>] unshare_nsproxy_namespaces+0xa1/0x1d0
    [<00000000fe2e42bc>] ksys_unshare+0x39c/0x780
    [<0000000009ba3b19>] __x64_sys_unshare+0x2d/0x40
    [<00000000614ad866>] do_syscall_64+0x56/0xa0
    [<00000000a1b5ca3c>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

'srv' is malloced in tipc_topsrv_start() but not free before
leaving from the error handling cases. We need to free it.

Fixes: 5c45ab24ac77 ("tipc: make struct tipc_server private for server.c")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Link: https://lore.kernel.org/r/20201109140913.47370-1-wanghai38@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/topsrv.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -671,12 +671,18 @@ static int tipc_topsrv_start(struct net
 
 	ret = tipc_topsrv_work_start(srv);
 	if (ret < 0)
-		return ret;
+		goto err_start;
 
 	ret = tipc_topsrv_create_listener(srv);
 	if (ret < 0)
-		tipc_topsrv_work_stop(srv);
+		goto err_create;
 
+	return 0;
+
+err_create:
+	tipc_topsrv_work_stop(srv);
+err_start:
+	kfree(srv);
 	return ret;
 }
 


