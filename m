Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31710627FB9
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237698AbiKNNBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:01:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237692AbiKNNB1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:01:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8652228701
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:01:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D16CB80EAF
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CF1C433D6;
        Mon, 14 Nov 2022 13:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430883;
        bh=+IZwKGTlSu1H9Brc2lBrZGvqLB4/cTqn+dH8qFCcBBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3aqGdP508qiVdOJjOri1nXMtcYc+v74zYl0o+wJFnCX9gSNirWTXjIhkB6qbGVM1
         6sKUxR3pz0xalbVjlvBVBANZomkYY5IRGlXJY3KNdhQnXRjjwF0ibQx3sqEvdxng6Q
         oiDilBoC6JGye4OFOpug1oaUTduxHdqTCScX9EFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jakub Sitnicki <jakub@cloudflare.com>,
        Wang Yufen <wangyufen@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 024/190] bpf, sockmap: Fix the sk->sk_forward_alloc warning of sk_stream_kill_queues
Date:   Mon, 14 Nov 2022 13:44:08 +0100
Message-Id: <20221114124459.828729971@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 8ec95b94716a1e4d126edc3fb2bc426a717e2dba ]

When running `test_sockmap` selftests, the following warning appears:

  WARNING: CPU: 2 PID: 197 at net/core/stream.c:205 sk_stream_kill_queues+0xd3/0xf0
  Call Trace:
  <TASK>
  inet_csk_destroy_sock+0x55/0x110
  tcp_rcv_state_process+0xd28/0x1380
  ? tcp_v4_do_rcv+0x77/0x2c0
  tcp_v4_do_rcv+0x77/0x2c0
  __release_sock+0x106/0x130
  __tcp_close+0x1a7/0x4e0
  tcp_close+0x20/0x70
  inet_release+0x3c/0x80
  __sock_release+0x3a/0xb0
  sock_close+0x14/0x20
  __fput+0xa3/0x260
  task_work_run+0x59/0xb0
  exit_to_user_mode_prepare+0x1b3/0x1c0
  syscall_exit_to_user_mode+0x19/0x50
  do_syscall_64+0x48/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae

The root case is in commit 84472b436e76 ("bpf, sockmap: Fix more uncharged
while msg has more_data"), where I used msg->sg.size to replace the tosend,
causing breakage:

  if (msg->apply_bytes && msg->apply_bytes < tosend)
    tosend = psock->apply_bytes;

Fixes: 84472b436e76 ("bpf, sockmap: Fix more uncharged while msg has more_data")
Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/1667266296-8794-1-git-send-email-wangyufen@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index c501c329b1db..cf9c3e8f7ccb 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -278,7 +278,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 {
 	bool cork = false, enospc = sk_msg_full(msg);
 	struct sock *sk_redir;
-	u32 tosend, delta = 0;
+	u32 tosend, origsize, sent, delta = 0;
 	u32 eval = __SK_NONE;
 	int ret;
 
@@ -333,10 +333,12 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 			cork = true;
 			psock->cork = NULL;
 		}
-		sk_msg_return(sk, msg, msg->sg.size);
+		sk_msg_return(sk, msg, tosend);
 		release_sock(sk);
 
+		origsize = msg->sg.size;
 		ret = tcp_bpf_sendmsg_redir(sk_redir, msg, tosend, flags);
+		sent = origsize - msg->sg.size;
 
 		if (eval == __SK_REDIRECT)
 			sock_put(sk_redir);
@@ -375,7 +377,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 		    msg->sg.data[msg->sg.start].page_link &&
 		    msg->sg.data[msg->sg.start].length) {
 			if (eval == __SK_REDIRECT)
-				sk_mem_charge(sk, msg->sg.size);
+				sk_mem_charge(sk, tosend - sent);
 			goto more_data;
 		}
 	}
-- 
2.35.1



