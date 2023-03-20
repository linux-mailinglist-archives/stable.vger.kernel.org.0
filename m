Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBEF76C1859
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbjCTPXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbjCTPXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:23:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5009D2BF30
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:16:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBDE0615AD
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61EBC433D2;
        Mon, 20 Mar 2023 15:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325397;
        bh=TMe+YEG/jrnwL3TwmcqKzGKtVJVIfWUK1pzvxGYy2tM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lT+zv+XK8UUp3IcE07TSISsi5VHxTtciQ4v+geR9fs+fhqdk2hhrKeS3JOesED3IB
         0yqUGjQyVubXlDyI4YaHdi3pOYdcd70fsYwbm2+YW0erXOOC/6GOfgb+cue39OZtwu
         27vxp5OSMoT1QMrlb8QaUfRtyMSj8qlasoSlGsq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Breno Leitao <leitao@debian.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 033/211] tcp: tcp_make_synack() can be called from process context
Date:   Mon, 20 Mar 2023 15:52:48 +0100
Message-Id: <20230320145514.647565084@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Breno Leitao <leitao@debian.org>

[ Upstream commit bced3f7db95ff2e6ca29dc4d1c9751ab5e736a09 ]

tcp_rtx_synack() now could be called in process context as explained in
0a375c822497 ("tcp: tcp_rtx_synack() can be called from process
context").

tcp_rtx_synack() might call tcp_make_synack(), which will touch per-CPU
variables with preemption enabled. This causes the following BUG:

    BUG: using __this_cpu_add() in preemptible [00000000] code: ThriftIO1/5464
    caller is tcp_make_synack+0x841/0xac0
    Call Trace:
     <TASK>
     dump_stack_lvl+0x10d/0x1a0
     check_preemption_disabled+0x104/0x110
     tcp_make_synack+0x841/0xac0
     tcp_v6_send_synack+0x5c/0x450
     tcp_rtx_synack+0xeb/0x1f0
     inet_rtx_syn_ack+0x34/0x60
     tcp_check_req+0x3af/0x9e0
     tcp_rcv_state_process+0x59b/0x2030
     tcp_v6_do_rcv+0x5f5/0x700
     release_sock+0x3a/0xf0
     tcp_sendmsg+0x33/0x40
     ____sys_sendmsg+0x2f2/0x490
     __sys_sendmsg+0x184/0x230
     do_syscall_64+0x3d/0x90

Avoid calling __TCP_INC_STATS() with will touch per-cpu variables. Use
TCP_INC_STATS() which is safe to be called from context switch.

Fixes: 8336886f786f ("tcp: TCP Fast Open Server - support TFO listeners")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230308190745.780221-1-leitao@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 71d01cf3c13eb..ba839e441450f 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3605,7 +3605,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	th->window = htons(min(req->rsk_rcv_wnd, 65535U));
 	tcp_options_write(th, NULL, &opts);
 	th->doff = (tcp_header_size >> 2);
-	__TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
+	TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
 
 #ifdef CONFIG_TCP_MD5SIG
 	/* Okay, we have all we need - do the md5 hash if needed */
-- 
2.39.2



