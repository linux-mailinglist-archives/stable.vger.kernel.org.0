Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD04F4F33E8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243117AbiDEJjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243772AbiDEJJQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:09:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC5ECB00F;
        Tue,  5 Apr 2022 01:58:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B11D961476;
        Tue,  5 Apr 2022 08:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C172BC385A0;
        Tue,  5 Apr 2022 08:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149114;
        bh=vjsrtqUyE3qmQ6zDoHeGzm8tnzALeS3OuodQrayDuPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMolNrFsF4126WH58f4PlHGsLiz9hs4YikRzPMdg+/O4BK1xIczgkKdpC/5hPahfY
         My9pxdG+4jdxAF9JPYOC6K/fHUtbFdoJ9hvKl+pbzao/orGxwG3IdyFBcQFP8oUGw4
         Ml3EmqYgXxdjihr52v/B12Opq7jCcE1dY8kzcu4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Yufen <wangyufen@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0600/1017] bpf, sockmap: Fix memleak in tcp_bpf_sendmsg while sk msg is full
Date:   Tue,  5 Apr 2022 09:25:13 +0200
Message-Id: <20220405070412.088227343@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 9c34e38c4a870eb30b13f42f5b44f42e9d19ccb8 ]

If tcp_bpf_sendmsg() is running while sk msg is full. When sk_msg_alloc()
returns -ENOMEM error, tcp_bpf_sendmsg() goes to wait_for_memory. If partial
memory has been alloced by sk_msg_alloc(), that is, msg_tx->sg.size is
greater than osize after sk_msg_alloc(), memleak occurs. To fix we use
sk_msg_trim() to release the allocated memory, then goto wait for memory.

Other call paths of sk_msg_alloc() have the similar issue, such as
tls_sw_sendmsg(), so handle sk_msg_trim logic inside sk_msg_alloc(),
as Cong Wang suggested.

This issue can cause the following info:
WARNING: CPU: 3 PID: 7950 at net/core/stream.c:208 sk_stream_kill_queues+0xd4/0x1a0
Call Trace:
 <TASK>
 inet_csk_destroy_sock+0x55/0x110
 __tcp_close+0x279/0x470
 tcp_close+0x1f/0x60
 inet_release+0x3f/0x80
 __sock_release+0x3d/0xb0
 sock_close+0x11/0x20
 __fput+0x92/0x250
 task_work_run+0x6a/0xa0
 do_exit+0x33b/0xb60
 do_group_exit+0x2f/0xa0
 get_signal+0xb6/0x950
 arch_do_signal_or_restart+0xac/0x2a0
 exit_to_user_mode_prepare+0xa9/0x200
 syscall_exit_to_user_mode+0x12/0x30
 do_syscall_64+0x46/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
 </TASK>

WARNING: CPU: 3 PID: 2094 at net/ipv4/af_inet.c:155 inet_sock_destruct+0x13c/0x260
Call Trace:
 <TASK>
 __sk_destruct+0x24/0x1f0
 sk_psock_destroy+0x19b/0x1c0
 process_one_work+0x1b3/0x3c0
 kthread+0xe6/0x110
 ret_from_fork+0x22/0x30
 </TASK>

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20220304081145.2037182-3-wangyufen@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 929a2b096b04..cc381165ea08 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -27,6 +27,7 @@ int sk_msg_alloc(struct sock *sk, struct sk_msg *msg, int len,
 		 int elem_first_coalesce)
 {
 	struct page_frag *pfrag = sk_page_frag(sk);
+	u32 osize = msg->sg.size;
 	int ret = 0;
 
 	len -= msg->sg.size;
@@ -35,13 +36,17 @@ int sk_msg_alloc(struct sock *sk, struct sk_msg *msg, int len,
 		u32 orig_offset;
 		int use, i;
 
-		if (!sk_page_frag_refill(sk, pfrag))
-			return -ENOMEM;
+		if (!sk_page_frag_refill(sk, pfrag)) {
+			ret = -ENOMEM;
+			goto msg_trim;
+		}
 
 		orig_offset = pfrag->offset;
 		use = min_t(int, len, pfrag->size - orig_offset);
-		if (!sk_wmem_schedule(sk, use))
-			return -ENOMEM;
+		if (!sk_wmem_schedule(sk, use)) {
+			ret = -ENOMEM;
+			goto msg_trim;
+		}
 
 		i = msg->sg.end;
 		sk_msg_iter_var_prev(i);
@@ -71,6 +76,10 @@ int sk_msg_alloc(struct sock *sk, struct sk_msg *msg, int len,
 	}
 
 	return ret;
+
+msg_trim:
+	sk_msg_trim(sk, msg, osize);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(sk_msg_alloc);
 
-- 
2.34.1



