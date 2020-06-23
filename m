Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502D8206664
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390798AbgFWVlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:41:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388440AbgFWUGQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:06:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06984206C3;
        Tue, 23 Jun 2020 20:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942775;
        bh=4REpVL5hvX1aLg8ZryAcXS5cvr5m8Q1j9q5VCTAu5Xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=USB7EATfytTyE7HgV/TtTyaY6RP+H/rzUyKEtwZjW72/5Iz7hSLnb9w/TPNKVNGCS
         iBBbsI+iUGU3UM47/QRTicGIyqzcSaKJMZ3Dwl3Ql7oNtCk5kqDDcHftIkMPdne6gi
         l5ryAcOmRAQK/2YMFu1XgmFvJPjm1mHDjYwMPBUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Sitnicki <jakub@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 103/477] bpf, sockhash: Fix memory leak when unlinking sockets in sock_hash_free
Date:   Tue, 23 Jun 2020 21:51:40 +0200
Message-Id: <20200623195412.458988977@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit 33a7c831565c43a7ee2f38c7df4c4a40e1dfdfed ]

When sockhash gets destroyed while sockets are still linked to it, we will
walk the bucket lists and delete the links. However, we are not freeing the
list elements after processing them, leaking the memory.

The leak can be triggered by close()'ing a sockhash map when it still
contains sockets, and observed with kmemleak:

  unreferenced object 0xffff888116e86f00 (size 64):
    comm "race_sock_unlin", pid 223, jiffies 4294731063 (age 217.404s)
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
      81 de e8 41 00 00 00 00 c0 69 2f 15 81 88 ff ff  ...A.....i/.....
    backtrace:
      [<00000000dd089ebb>] sock_hash_update_common+0x4ca/0x760
      [<00000000b8219bd5>] sock_hash_update_elem+0x1d2/0x200
      [<000000005e2c23de>] __do_sys_bpf+0x2046/0x2990
      [<00000000d0084618>] do_syscall_64+0xad/0x9a0
      [<000000000d96f263>] entry_SYSCALL_64_after_hwframe+0x49/0xb3

Fix it by freeing the list element when we're done with it.

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20200607205229.2389672-2-jakub@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index b08dfae10f88e..7edbf1e924571 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1024,6 +1024,7 @@ static void sock_hash_free(struct bpf_map *map)
 			sock_map_unref(elem->sk, elem);
 			rcu_read_unlock();
 			release_sock(elem->sk);
+			sock_hash_free_elem(htab, elem);
 		}
 	}
 
-- 
2.25.1



