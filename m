Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEEC41D8374
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732859AbgERSEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:04:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732857AbgERSEx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:04:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EACA20715;
        Mon, 18 May 2020 18:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825093;
        bh=8kVMZVJ1E7gi76obbwwyWZArSsiPule4tEWDW6aO31s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dpcjh4JjN0zEsnktFu5yHuY+/Di2IYA9mNVJJtIwNS5bDU3n30NHDLSTV06B8Dg27
         s43S4GV9rJuWWFmdJNuoH/Ygi7lCeuVy25r0PCrtH6NdLzqI702WSmg31Z8MbXPyIs
         CgwYt9Dz56HVVf/dULHB/m/b9x+pjl5FyuOcxj8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 087/194] bpf, sockmap: bpf_tcp_ingress needs to subtract bytes from sg.size
Date:   Mon, 18 May 2020 19:36:17 +0200
Message-Id: <20200518173538.924074160@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 81aabbb9fb7b4b1efd073b62f0505d3adad442f3 ]

In bpf_tcp_ingress we used apply_bytes to subtract bytes from sg.size
which is used to track total bytes in a message. But this is not
correct because apply_bytes is itself modified in the main loop doing
the mem_charge.

Then at the end of this we have sg.size incorrectly set and out of
sync with actual sk values. Then we can get a splat if we try to
cork the data later and again try to redirect the msg to ingress. To
fix instead of trying to track msg.size do the easy thing and include
it as part of the sk_msg_xfer logic so that when the msg is moved the
sg.size is always correct.

To reproduce the below users will need ingress + cork and hit an
error path that will then try to 'free' the skmsg.

[  173.699981] BUG: KASAN: null-ptr-deref in sk_msg_free_elem+0xdd/0x120
[  173.699987] Read of size 8 at addr 0000000000000008 by task test_sockmap/5317

[  173.700000] CPU: 2 PID: 5317 Comm: test_sockmap Tainted: G          I       5.7.0-rc1+ #43
[  173.700005] Hardware name: Dell Inc. Precision 5820 Tower/002KVM, BIOS 1.9.2 01/24/2019
[  173.700009] Call Trace:
[  173.700021]  dump_stack+0x8e/0xcb
[  173.700029]  ? sk_msg_free_elem+0xdd/0x120
[  173.700034]  ? sk_msg_free_elem+0xdd/0x120
[  173.700042]  __kasan_report+0x102/0x15f
[  173.700052]  ? sk_msg_free_elem+0xdd/0x120
[  173.700060]  kasan_report+0x32/0x50
[  173.700070]  sk_msg_free_elem+0xdd/0x120
[  173.700080]  __sk_msg_free+0x87/0x150
[  173.700094]  tcp_bpf_send_verdict+0x179/0x4f0
[  173.700109]  tcp_bpf_sendpage+0x3ce/0x5d0

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/158861290407.14306.5327773422227552482.stgit@john-Precision-5820-Tower
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skmsg.h | 1 +
 net/ipv4/tcp_bpf.c    | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 14d61bba0b79b..71db17927a9da 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -187,6 +187,7 @@ static inline void sk_msg_xfer(struct sk_msg *dst, struct sk_msg *src,
 	dst->sg.data[which] = src->sg.data[which];
 	dst->sg.data[which].length  = size;
 	dst->sg.size		   += size;
+	src->sg.size		   -= size;
 	src->sg.data[which].length -= size;
 	src->sg.data[which].offset += size;
 }
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 8a01428f80c1c..19bd10e6ab830 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -200,7 +200,6 @@ static int bpf_tcp_ingress(struct sock *sk, struct sk_psock *psock,
 
 	if (!ret) {
 		msg->sg.start = i;
-		msg->sg.size -= apply_bytes;
 		sk_psock_queue_msg(psock, tmp);
 		sk_psock_data_ready(sk, psock);
 	} else {
-- 
2.20.1



