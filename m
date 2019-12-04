Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2E411322F
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730518AbfLDSGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:06:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:54212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728703AbfLDSGP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:06:15 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6979C2081B;
        Wed,  4 Dec 2019 18:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482774;
        bh=/L/TkAQJT0J4xvQNLca+HqP2gcZgkXxvLBXfz2f2Gc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dlmHFIyF3+kCct3FjBC6UpyngS+GSHBJYrEKcHmj5j79He1wE3fCMUwJ2DXUbb6nZ
         dJanG1ZmFofxjlywlSy3gAbJvmVFGQzaDQ1G11CsvQNLFnXTJXNARSK/XTMz+YlZnE
         wwU9jtbNDdV4aPgJGaVt+5gjPWTwohBRc1n+mMFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 128/209] net/core/neighbour: tell kmemleak about hash tables
Date:   Wed,  4 Dec 2019 18:55:40 +0100
Message-Id: <20191204175331.916266715@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

[ Upstream commit 85704cb8dcfd88d351bfc87faaeba1c8214f3177 ]

This fixes false-positive kmemleak reports about leaked neighbour entries:

unreferenced object 0xffff8885c6e4d0a8 (size 1024):
  comm "softirq", pid 0, jiffies 4294922664 (age 167640.804s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 20 2c f3 83 ff ff ff ff  ........ ,......
    08 c0 ef 5f 84 88 ff ff 01 8c 7d 02 01 00 00 00  ..._......}.....
  backtrace:
    [<00000000748509fe>] ip6_finish_output2+0x887/0x1e40
    [<0000000036d7a0d8>] ip6_output+0x1ba/0x600
    [<0000000027ea7dba>] ip6_send_skb+0x92/0x2f0
    [<00000000d6e2111d>] udp_v6_send_skb.isra.24+0x680/0x15e0
    [<000000000668a8be>] udpv6_sendmsg+0x18c9/0x27a0
    [<000000004bd5fa90>] sock_sendmsg+0xb3/0xf0
    [<000000008227b29f>] ___sys_sendmsg+0x745/0x8f0
    [<000000008698009d>] __sys_sendmsg+0xde/0x170
    [<00000000889dacf1>] do_syscall_64+0x9b/0x400
    [<0000000081cdb353>] entry_SYSCALL_64_after_hwframe+0x49/0xbe
    [<000000005767ed39>] 0xffffffffffffffff

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index eb3efeabac91d..9a28a21a51f05 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -18,6 +18,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/slab.h>
+#include <linux/kmemleak.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -361,12 +362,14 @@ static struct neigh_hash_table *neigh_hash_alloc(unsigned int shift)
 	ret = kmalloc(sizeof(*ret), GFP_ATOMIC);
 	if (!ret)
 		return NULL;
-	if (size <= PAGE_SIZE)
+	if (size <= PAGE_SIZE) {
 		buckets = kzalloc(size, GFP_ATOMIC);
-	else
+	} else {
 		buckets = (struct neighbour __rcu **)
 			  __get_free_pages(GFP_ATOMIC | __GFP_ZERO,
 					   get_order(size));
+		kmemleak_alloc(buckets, size, 0, GFP_ATOMIC);
+	}
 	if (!buckets) {
 		kfree(ret);
 		return NULL;
@@ -386,10 +389,12 @@ static void neigh_hash_free_rcu(struct rcu_head *head)
 	size_t size = (1 << nht->hash_shift) * sizeof(struct neighbour *);
 	struct neighbour __rcu **buckets = nht->hash_buckets;
 
-	if (size <= PAGE_SIZE)
+	if (size <= PAGE_SIZE) {
 		kfree(buckets);
-	else
+	} else {
+		kmemleak_free(buckets);
 		free_pages((unsigned long)buckets, get_order(size));
+	}
 	kfree(nht);
 }
 
-- 
2.20.1



