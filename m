Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 853F86C16D5
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbjCTPJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbjCTPJB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:09:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E20E6E89
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:04:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00178B80EAB
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABD3C433EF;
        Mon, 20 Mar 2023 15:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324667;
        bh=jDuWyESHNSkwSanRPr4F1dco/CrojfDJYK8D6SIbpCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vBw6rzQFrC7JZuGwRORAhCX8w13NPsiRL16pV+99H6TBZpitt2hJy5rEgxS7dRVMz
         zdVSZPiKb3k0IbTW08TD0ejPdyh6UtSeGAAXNuo+i3Pq1CFkEtFttRCeQ0nGSpB+uZ
         uKC0hCR20ztbourZfMGfKDPskql+YbXEPxBm6ngc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Breno Leitao <leitao@debian.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/115] tcp: tcp_make_synack() can be called from process context
Date:   Mon, 20 Mar 2023 15:53:46 +0100
Message-Id: <20230320145449.985762283@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
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
index 33ba1268a111f..1f39b56bbab32 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3610,7 +3610,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	th->window = htons(min(req->rsk_rcv_wnd, 65535U));
 	tcp_options_write((__be32 *)(th + 1), NULL, &opts);
 	th->doff = (tcp_header_size >> 2);
-	__TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
+	TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
 
 #ifdef CONFIG_TCP_MD5SIG
 	/* Okay, we have all we need - do the md5 hash if needed */
-- 
2.39.2



