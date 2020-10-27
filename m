Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F9C29B35D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1766379AbgJ0Osj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:48:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1766406AbgJ0Osi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:48:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2718207DE;
        Tue, 27 Oct 2020 14:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810117;
        bh=8nBX5S8RBfmvJRKQaTLgvgqmvtam5NgpIbNOXayRkPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hKFSAenmA9c5GMWpbJGa1SBZxIJnM78qxZzlPfUjshfbOxziDfQfdkd5NLu0Xuz6D
         BVjslwE+dRQ6beoVmJWQfmAjothzDbKXg/JtFMQPc2ffWesKQK+ts3gmVtontdDU79
         UJ1TLZx/687ZF37dfwP5XLW8k9sxBMoW1/87SxsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Vasily Averin <vvs@virtuozzo.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 009/633] net: fix pos incrementment in ipv6_route_seq_next
Date:   Tue, 27 Oct 2020 14:45:52 +0100
Message-Id: <20201027135523.120469020@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit 6617dfd440149e42ce4d2be615eb31a4755f4d30 ]

Commit 4fc427e05158 ("ipv6_route_seq_next should increase position index")
tried to fix the issue where seq_file pos is not increased
if a NULL element is returned with seq_ops->next(). See bug
  https://bugzilla.kernel.org/show_bug.cgi?id=206283
The commit effectively does:
  - increase pos for all seq_ops->start()
  - increase pos for all seq_ops->next()

For ipv6_route, increasing pos for all seq_ops->next() is correct.
But increasing pos for seq_ops->start() is not correct
since pos is used to determine how many items to skip during
seq_ops->start():
  iter->skip = *pos;
seq_ops->start() just fetches the *current* pos item.
The item can be skipped only after seq_ops->show() which essentially
is the beginning of seq_ops->next().

For example, I have 7 ipv6 route entries,
  root@arch-fb-vm1:~/net-next dd if=/proc/net/ipv6_route bs=4096
  00000000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000400 00000001 00000000 00000001     eth0
  fe800000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000001 00000000 00000001     eth0
  00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
  00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001       lo
  fe800000000000002050e3fffebd3be8 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
  ff000000000000000000000000000000 08 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000004 00000000 00000001     eth0
  00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
  0+1 records in
  0+1 records out
  1050 bytes (1.0 kB, 1.0 KiB) copied, 0.00707908 s, 148 kB/s
  root@arch-fb-vm1:~/net-next

In the above, I specify buffer size 4096, so all records can be returned
to user space with a single trip to the kernel.

If I use buffer size 128, since each record size is 149, internally
kernel seq_read() will read 149 into its internal buffer and return the data
to user space in two read() syscalls. Then user read() syscall will trigger
next seq_ops->start(). Since the current implementation increased pos even
for seq_ops->start(), it will skip record #2, #4 and #6, assuming the first
record is #1.

  root@arch-fb-vm1:~/net-next dd if=/proc/net/ipv6_route bs=128
  00000000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000400 00000001 00000000 00000001     eth0
  00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
  fe800000000000002050e3fffebd3be8 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
  00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
4+1 records in
4+1 records out
600 bytes copied, 0.00127758 s, 470 kB/s

To fix the problem, create a fake pos pointer so seq_ops->start()
won't actually increase seq_file pos. With this fix, the
above `dd` command with `bs=128` will show correct result.

Fixes: 4fc427e05158 ("ipv6_route_seq_next should increase position index")
Cc: Alexei Starovoitov <ast@kernel.org>
Suggested-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_fib.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -2617,8 +2617,10 @@ static void *ipv6_route_seq_start(struct
 	iter->skip = *pos;
 
 	if (iter->tbl) {
+		loff_t p = 0;
+
 		ipv6_route_seq_setup_walk(iter, net);
-		return ipv6_route_seq_next(seq, NULL, pos);
+		return ipv6_route_seq_next(seq, NULL, &p);
 	} else {
 		return NULL;
 	}


