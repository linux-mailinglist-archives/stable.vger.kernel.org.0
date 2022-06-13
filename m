Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD5A548B47
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354319AbiFMLfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354584AbiFMLd3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:33:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69073968A;
        Mon, 13 Jun 2022 03:47:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10AF86112A;
        Mon, 13 Jun 2022 10:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25AEBC34114;
        Mon, 13 Jun 2022 10:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117248;
        bh=h22vLYdgdva+a54IzP5sYoSo8XOMrX/sUBB6usoDs/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQGPxNDMfK0iOjmj+u2doCP+vnx/vron9+75G0e4NgmO5rbmhtR3n2cdNhtX6Cn7r
         6dIlAQ7xXI+e87zZmn3Ie3EqJwkzxnJLGUvUDGL3rLAty4dF0WjqUfLj1hg3cR9Lz5
         SbZHF5XOXXbljHUr0lTbhZmk8jHpWse54trmsYGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Laurent Fasnacht <laurent.fasnacht@proton.ch>,
        Neal Cardwell <ncardwell@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 333/411] tcp: tcp_rtx_synack() can be called from process context
Date:   Mon, 13 Jun 2022 12:10:06 +0200
Message-Id: <20220613094938.707534130@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0a375c822497ed6ad6b5da0792a12a6f1af10c0b ]

Laurent reported the enclosed report [1]

This bug triggers with following coditions:

0) Kernel built with CONFIG_DEBUG_PREEMPT=y

1) A new passive FastOpen TCP socket is created.
   This FO socket waits for an ACK coming from client to be a complete
   ESTABLISHED one.
2) A socket operation on this socket goes through lock_sock()
   release_sock() dance.
3) While the socket is owned by the user in step 2),
   a retransmit of the SYN is received and stored in socket backlog.
4) At release_sock() time, the socket backlog is processed while
   in process context.
5) A SYNACK packet is cooked in response of the SYN retransmit.
6) -> tcp_rtx_synack() is called in process context.

Before blamed commit, tcp_rtx_synack() was always called from BH handler,
from a timer handler.

Fix this by using TCP_INC_STATS() & NET_INC_STATS()
which do not assume caller is in non preemptible context.

[1]
BUG: using __this_cpu_add() in preemptible [00000000] code: epollpep/2180
caller is tcp_rtx_synack.part.0+0x36/0xc0
CPU: 10 PID: 2180 Comm: epollpep Tainted: G           OE     5.16.0-0.bpo.4-amd64 #1  Debian 5.16.12-1~bpo11+1
Hardware name: Supermicro SYS-5039MC-H8TRF/X11SCD-F, BIOS 1.7 11/23/2021
Call Trace:
 <TASK>
 dump_stack_lvl+0x48/0x5e
 check_preemption_disabled+0xde/0xe0
 tcp_rtx_synack.part.0+0x36/0xc0
 tcp_rtx_synack+0x8d/0xa0
 ? kmem_cache_alloc+0x2e0/0x3e0
 ? apparmor_file_alloc_security+0x3b/0x1f0
 inet_rtx_syn_ack+0x16/0x30
 tcp_check_req+0x367/0x610
 tcp_rcv_state_process+0x91/0xf60
 ? get_nohz_timer_target+0x18/0x1a0
 ? lock_timer_base+0x61/0x80
 ? preempt_count_add+0x68/0xa0
 tcp_v4_do_rcv+0xbd/0x270
 __release_sock+0x6d/0xb0
 release_sock+0x2b/0x90
 sock_setsockopt+0x138/0x1140
 ? __sys_getsockname+0x7e/0xc0
 ? aa_sk_perm+0x3e/0x1a0
 __sys_setsockopt+0x198/0x1e0
 __x64_sys_setsockopt+0x21/0x30
 do_syscall_64+0x38/0xc0
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 168a8f58059a ("tcp: TCP Fast Open Server - main code path")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Laurent Fasnacht <laurent.fasnacht@proton.ch>
Acked-by: Neal Cardwell <ncardwell@google.com>
Link: https://lore.kernel.org/r/20220530213713.601888-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 67493ec6318a..739fc69cdcc6 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3869,8 +3869,8 @@ int tcp_rtx_synack(const struct sock *sk, struct request_sock *req)
 	tcp_rsk(req)->txhash = net_tx_rndhash();
 	res = af_ops->send_synack(sk, NULL, &fl, req, NULL, TCP_SYNACK_NORMAL);
 	if (!res) {
-		__TCP_INC_STATS(sock_net(sk), TCP_MIB_RETRANSSEGS);
-		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNRETRANS);
+		TCP_INC_STATS(sock_net(sk), TCP_MIB_RETRANSSEGS);
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNRETRANS);
 		if (unlikely(tcp_passive_fastopen(sk)))
 			tcp_sk(sk)->total_retrans++;
 		trace_tcp_retransmit_synack(sk, req);
-- 
2.35.1



