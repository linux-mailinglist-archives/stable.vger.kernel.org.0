Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38BF2469D81
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386774AbhLFP37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358704AbhLFP1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:27:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A162C08EAFC;
        Mon,  6 Dec 2021 07:17:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD35D61344;
        Mon,  6 Dec 2021 15:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B75C341D3;
        Mon,  6 Dec 2021 15:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803863;
        bh=5ydVTXaKARYQR4eAZq3ploeOVeblFmJLQYAT41B++Cg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PjaajRMoojNGo6+8IHP2NgQXvXCgmWJ8edkvB37Znx1QDr3csPWGfUFe167H/Pdky
         9RjB0+9Qj3Qizl3e56NtK/CRhbZJvMB4UTQ1Yn8qCzCOTTwN75wUIBv76a17+q6cO2
         29v+ZRRcjvki3pKqqttf5iGUveBCcNnP8ocmYV5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steffen Froemer <sfroemer@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 066/130] tcp: fix page frag corruption on page fault
Date:   Mon,  6 Dec 2021 15:56:23 +0100
Message-Id: <20211206145601.953993405@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

commit dacb5d8875cc6cd3a553363b4d6f06760fcbe70c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sock.h |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2322,19 +2322,22 @@ struct sk_buff *sk_stream_alloc_skb(stru
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


