Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4704F2A16
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbiDEIZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238663AbiDEITR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAB46D1B3;
        Tue,  5 Apr 2022 01:09:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42D6F60B01;
        Tue,  5 Apr 2022 08:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46598C385A1;
        Tue,  5 Apr 2022 08:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146157;
        bh=bMpDvhUZHs/Rk+rEvjrWU1xOX5yG+D1BVOcQTkPZsC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DxD2/8NwNH+MiSWmIagK+1YrZlSnnztnHumnkmb17SOkXWQJbCUkNZEs2Pk3NVXHE
         bk+S7Y0vFpuNtwqE7PcG7XSNWcimDAP96Yu4PUzhr829iREUBNeptUEBLVu/zLbyNH
         +d3/v55ExHYx/kbFGYB5rBS/vjwWypwq4yKLnTxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Yufen <wangyufen@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0662/1126] bpf, sockmap: Fix more uncharged while msg has more_data
Date:   Tue,  5 Apr 2022 09:23:29 +0200
Message-Id: <20220405070427.059457951@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

[ Upstream commit 84472b436e760ba439e1969a9e3c5ae7c86de39d ]

In tcp_bpf_send_verdict(), if msg has more data after
tcp_bpf_sendmsg_redir():

tcp_bpf_send_verdict()
 tosend = msg->sg.size  //msg->sg.size = 22220
 case __SK_REDIRECT:
  sk_msg_return()  //uncharged msg->sg.size(22220) sk->sk_forward_alloc
  tcp_bpf_sendmsg_redir() //after tcp_bpf_sendmsg_redir, msg->sg.size=11000
 goto more_data;
 tosend = msg->sg.size  //msg->sg.size = 11000
 case __SK_REDIRECT:
  sk_msg_return()  //uncharged msg->sg.size(11000) to sk->sk_forward_alloc

The msg->sg.size(11000) has been uncharged twice, to fix we can charge the
remaining msg->sg.size before goto more data.

This issue can cause the following info:
WARNING: CPU: 0 PID: 9860 at net/core/stream.c:208 sk_stream_kill_queues+0xd4/0x1a0
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
 ? vfs_write+0x237/0x290
 exit_to_user_mode_prepare+0xa9/0x200
 syscall_exit_to_user_mode+0x12/0x30
 do_syscall_64+0x46/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
 </TASK>

WARNING: CPU: 0 PID: 2136 at net/ipv4/af_inet.c:155 inet_sock_destruct+0x13c/0x260
Call Trace:
 <TASK>
 __sk_destruct+0x24/0x1f0
 sk_psock_destroy+0x19b/0x1c0
 process_one_work+0x1b3/0x3c0
 worker_thread+0x30/0x350
 ? process_one_work+0x3c0/0x3c0
 kthread+0xe6/0x110
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x22/0x30
 </TASK>

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20220304081145.2037182-4-wangyufen@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 9b9b02052fd3..304800c60427 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -335,7 +335,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 			cork = true;
 			psock->cork = NULL;
 		}
-		sk_msg_return(sk, msg, tosend);
+		sk_msg_return(sk, msg, msg->sg.size);
 		release_sock(sk);
 
 		ret = tcp_bpf_sendmsg_redir(sk_redir, msg, tosend, flags);
@@ -375,8 +375,11 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 		}
 		if (msg &&
 		    msg->sg.data[msg->sg.start].page_link &&
-		    msg->sg.data[msg->sg.start].length)
+		    msg->sg.data[msg->sg.start].length) {
+			if (eval == __SK_REDIRECT)
+				sk_mem_charge(sk, msg->sg.size);
 			goto more_data;
+		}
 	}
 	return ret;
 }
-- 
2.34.1



