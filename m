Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1385E2C085D
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732942AbgKWMtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:49:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:34102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732872AbgKWMtK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:49:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6515E20888;
        Mon, 23 Nov 2020 12:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135749;
        bh=04QVacp8napUxMxpdkgCb8jqM0aRr4/f56mR8ELNaSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IggGRh5+WgTEYpNYuHt5OEYAcjGm7X8kXEqebY7GwE/6UuSReB8KQKhuXJwgp14Rv
         kvgKAw7diIO8M/hl2qg7rABPKoCNonpDSHIfECbTa9B0tTEZANpjoDZ5vJMNJGd8SG
         k0R54+pC8obhqlKTdmnhr5qco+SLZS5trIszScHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 151/252] bpf, sockmap: Fix partial copy_page_to_iter so progress can still be made
Date:   Mon, 23 Nov 2020 13:21:41 +0100
Message-Id: <20201123121842.877150236@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit c9c89dcd872ea33327673fcb97398993a1f22736 ]

If copy_page_to_iter() fails or even partially completes, but with fewer
bytes copied than expected we currently reset sg.start and return EFAULT.
This proves problematic if we already copied data into the user buffer
before we return an error. Because we leave the copied data in the user
buffer and fail to unwind the scatterlist so kernel side believes data
has been copied and user side believes data has _not_ been received.

Expected behavior should be to return number of bytes copied and then
on the next read we need to return the error assuming its still there. This
can happen if we have a copy length spanning multiple scatterlist elements
and one or more complete before the error is hit.

The error is rare enough though that my normal testing with server side
programs, such as nginx, httpd, envoy, etc., I have never seen this. The
only reliable way to reproduce that I've found is to stream movies over
my browser for a day or so and wait for it to hang. Not very scientific,
but with a few extra WARN_ON()s in the code the bug was obvious.

When we review the errors from copy_page_to_iter() it seems we are hitting
a page fault from copy_page_to_iter_iovec() where the code checks
fault_in_pages_writeable(buf, copy) where buf is the user buffer. It
also seems typical server applications don't hit this case.

The other way to try and reproduce this is run the sockmap selftest tool
test_sockmap with data verification enabled, but it doesn't reproduce the
fault. Perhaps we can trigger this case artificially somehow from the
test tools. I haven't sorted out a way to do that yet though.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/160556566659.73229.15694973114605301063.stgit@john-XPS-13-9370
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 7aa68f4aae6c3..d85ba32dc6e7a 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -15,8 +15,8 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 {
 	struct iov_iter *iter = &msg->msg_iter;
 	int peek = flags & MSG_PEEK;
-	int i, ret, copied = 0;
 	struct sk_msg *msg_rx;
+	int i, copied = 0;
 
 	msg_rx = list_first_entry_or_null(&psock->ingress_msg,
 					  struct sk_msg, list);
@@ -37,11 +37,9 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 			page = sg_page(sge);
 			if (copied + copy > len)
 				copy = len - copied;
-			ret = copy_page_to_iter(page, sge->offset, copy, iter);
-			if (ret != copy) {
-				msg_rx->sg.start = i;
-				return -EFAULT;
-			}
+			copy = copy_page_to_iter(page, sge->offset, copy, iter);
+			if (!copy)
+				return copied ? copied : -EFAULT;
 
 			copied += copy;
 			if (likely(!peek)) {
@@ -56,6 +54,11 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 						put_page(page);
 				}
 			} else {
+				/* Lets not optimize peek case if copy_page_to_iter
+				 * didn't copy the entire length lets just break.
+				 */
+				if (copy != sge->length)
+					return copied;
 				sk_msg_iter_var_next(i);
 			}
 
-- 
2.27.0



