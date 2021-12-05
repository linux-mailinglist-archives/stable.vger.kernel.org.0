Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA85468AEC
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 14:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbhLENGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 08:06:17 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42340 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhLENGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 08:06:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C703560FDF
        for <stable@vger.kernel.org>; Sun,  5 Dec 2021 13:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85C6C341C8;
        Sun,  5 Dec 2021 13:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638709369;
        bh=/Wv7Q2oW5B+mAefirko4r/uXLRQGdrBlwzYx+wG3KLc=;
        h=Subject:To:Cc:From:Date:From;
        b=w44abvgWGcxId1sPYu7zNPNIOaAJK3cnpVT76wWy1iM15liXDkzGR8eLon7lGajN8
         q9RnXW20GLOBqY32WNn56Ab0XXF6DwbR/JDwagl/BcMj+pZ618LRCYQqrof2JF7+eL
         f/nWm5JzTWAvX2EqhGQEdal+eHJuu9+ODgF7ICS4=
Subject: FAILED: patch "[PATCH] tcp: fix page frag corruption on page fault" failed to apply to 4.19-stable tree
To:     pabeni@redhat.com, davem@davemloft.net, edumazet@google.com,
        sfroemer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 05 Dec 2021 14:02:40 +0100
Message-ID: <163870936045106@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dacb5d8875cc6cd3a553363b4d6f06760fcbe70c Mon Sep 17 00:00:00 2001
From: Paolo Abeni <pabeni@redhat.com>
Date: Fri, 26 Nov 2021 19:34:21 +0100
Subject: [PATCH] tcp: fix page frag corruption on page fault

Steffen reported a TCP stream corruption for HTTP requests
served by the apache web-server using a cifs mount-point
and memory mapping the relevant file.

The root cause is quite similar to the one addressed by
commit 20eb4f29b602 ("net: fix sk_page_frag() recursion from
memory reclaim"). Here the nested access to the task page frag
is caused by a page fault on the (mmapped) user-space memory
buffer coming from the cifs file.

The page fault handler performs an smb transaction on a different
socket, inside the same process context. Since sk->sk_allaction
for such socket does not prevent the usage for the task_frag,
the nested allocation modify "under the hood" the page frag
in use by the outer sendmsg call, corrupting the stream.

The overall relevant stack trace looks like the following:

httpd 78268 [001] 3461630.850950:      probe:tcp_sendmsg_locked:
        ffffffff91461d91 tcp_sendmsg_locked+0x1
        ffffffff91462b57 tcp_sendmsg+0x27
        ffffffff9139814e sock_sendmsg+0x3e
        ffffffffc06dfe1d smb_send_kvec+0x28
        [...]
        ffffffffc06cfaf8 cifs_readpages+0x213
        ffffffff90e83c4b read_pages+0x6b
        ffffffff90e83f31 __do_page_cache_readahead+0x1c1
        ffffffff90e79e98 filemap_fault+0x788
        ffffffff90eb0458 __do_fault+0x38
        ffffffff90eb5280 do_fault+0x1a0
        ffffffff90eb7c84 __handle_mm_fault+0x4d4
        ffffffff90eb8093 handle_mm_fault+0xc3
        ffffffff90c74f6d __do_page_fault+0x1ed
        ffffffff90c75277 do_page_fault+0x37
        ffffffff9160111e page_fault+0x1e
        ffffffff9109e7b5 copyin+0x25
        ffffffff9109eb40 _copy_from_iter_full+0xe0
        ffffffff91462370 tcp_sendmsg_locked+0x5e0
        ffffffff91462370 tcp_sendmsg_locked+0x5e0
        ffffffff91462b57 tcp_sendmsg+0x27
        ffffffff9139815c sock_sendmsg+0x4c
        ffffffff913981f7 sock_write_iter+0x97
        ffffffff90f2cc56 do_iter_readv_writev+0x156
        ffffffff90f2dff0 do_iter_write+0x80
        ffffffff90f2e1c3 vfs_writev+0xa3
        ffffffff90f2e27c do_writev+0x5c
        ffffffff90c042bb do_syscall_64+0x5b
        ffffffff916000ad entry_SYSCALL_64_after_hwframe+0x65

The cifs filesystem rightfully sets sk_allocations to GFP_NOFS,
we can avoid the nesting using the sk page frag for allocation
lacking the __GFP_FS flag. Do not define an additional mm-helper
for that, as this is strictly tied to the sk page frag usage.

v1 -> v2:
 - use a stricted sk_page_frag() check instead of reordering the
   code (Eric)

Reported-by: Steffen Froemer <sfroemer@redhat.com>
Fixes: 5640f7685831 ("net: use a per task frag allocator")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/net/sock.h b/include/net/sock.h
index b32906e1ab55..715cdb4b2b79 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2430,19 +2430,22 @@ static inline void sk_stream_moderate_sndbuf(struct sock *sk)
  * @sk: socket
  *
  * Use the per task page_frag instead of the per socket one for
- * optimization when we know that we're in the normal context and owns
+ * optimization when we know that we're in process context and own
  * everything that's associated with %current.
  *
- * gfpflags_allow_blocking() isn't enough here as direct reclaim may nest
- * inside other socket operations and end up recursing into sk_page_frag()
- * while it's already in use.
+ * Both direct reclaim and page faults can nest inside other
+ * socket operations and end up recursing into sk_page_frag()
+ * while it's already in use: explicitly avoid task page_frag
+ * usage if the caller is potentially doing any of them.
+ * This assumes that page fault handlers use the GFP_NOFS flags.
  *
  * Return: a per task page_frag if context allows that,
  * otherwise a per socket one.
  */
 static inline struct page_frag *sk_page_frag(struct sock *sk)
 {
-	if (gfpflags_normal_context(sk->sk_allocation))
+	if ((sk->sk_allocation & (__GFP_DIRECT_RECLAIM | __GFP_MEMALLOC | __GFP_FS)) ==
+	    (__GFP_DIRECT_RECLAIM | __GFP_FS))
 		return &current->task_frag;
 
 	return &sk->sk_frag;

