Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B6D66C714
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbjAPQ1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232779AbjAPQ1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:27:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353FF22DD5
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:15:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C87006104D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC196C433EF;
        Mon, 16 Jan 2023 16:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885751;
        bh=AQ7MG9rA8sgwDU3yHwe3RpnSAeIdyX6/QzC2oG0tTbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CSabBxCBUo7zr8/g4Q84T6XEUU8iSoJLEuyaLKaPyaMejY00XIFyab7O7tmOjasR0
         u+nRoshP8RWRDOKaz5rMgO8fZbeliBtngIoFIroSTbqP9T9waprPlJbsc6rQiOL5ai
         2+ZR62BtJiX5L16fQ5GgvEHPR+Aztfv7dNXqdtgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pengcheng Yang <yangpc@wangsu.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 171/658] bpf, sockmap: Fix repeated calls to sock_put() when msg has more_data
Date:   Mon, 16 Jan 2023 16:44:19 +0100
Message-Id: <20230116154917.299364102@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Pengcheng Yang <yangpc@wangsu.com>

[ Upstream commit 7a9841ca025275b5b0edfb0b618934abb6ceec15 ]

In tcp_bpf_send_verdict() redirection, the eval variable is assigned to
__SK_REDIRECT after the apply_bytes data is sent, if msg has more_data,
sock_put() will be called multiple times.

We should reset the eval variable to __SK_NONE every time more_data
starts.

This causes:

IPv4: Attempt to release TCP socket in state 1 00000000b4c925d7
------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 5 PID: 4482 at lib/refcount.c:25 refcount_warn_saturate+0x7d/0x110
Modules linked in:
CPU: 5 PID: 4482 Comm: sockhash_bypass Kdump: loaded Not tainted 6.0.0 #1
Hardware name: Red Hat KVM, BIOS 1.11.0-2.el7 04/01/2014
Call Trace:
 <TASK>
 __tcp_transmit_skb+0xa1b/0xb90
 ? __alloc_skb+0x8c/0x1a0
 ? __kmalloc_node_track_caller+0x184/0x320
 tcp_write_xmit+0x22a/0x1110
 __tcp_push_pending_frames+0x32/0xf0
 do_tcp_sendpages+0x62d/0x640
 tcp_bpf_push+0xae/0x2c0
 tcp_bpf_sendmsg_redir+0x260/0x410
 ? preempt_count_add+0x70/0xa0
 tcp_bpf_send_verdict+0x386/0x4b0
 tcp_bpf_sendmsg+0x21b/0x3b0
 sock_sendmsg+0x58/0x70
 __sys_sendto+0xfa/0x170
 ? xfd_validate_state+0x1d/0x80
 ? switch_fpu_return+0x59/0xe0
 __x64_sys_sendto+0x24/0x30
 do_syscall_64+0x37/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: cd9733f5d75c ("tcp_bpf: Fix one concurrency problem in the tcp_bpf_send_verdict function")
Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/1669718441-2654-2-git-send-email-yangpc@wangsu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index f69dcd3c7797..229fa1f2b381 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -312,7 +312,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 	bool cork = false, enospc = sk_msg_full(msg);
 	struct sock *sk_redir;
 	u32 tosend, origsize, sent, delta = 0;
-	u32 eval = __SK_NONE;
+	u32 eval;
 	int ret;
 
 more_data:
@@ -343,6 +343,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
 	tosend = msg->sg.size;
 	if (psock->apply_bytes && psock->apply_bytes < tosend)
 		tosend = psock->apply_bytes;
+	eval = __SK_NONE;
 
 	switch (psock->eval) {
 	case __SK_PASS:
-- 
2.35.1



