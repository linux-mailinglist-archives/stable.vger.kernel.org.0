Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0817205F4C
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390490AbgFWUba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:31:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391204AbgFWUb3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:31:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 358EF2070E;
        Tue, 23 Jun 2020 20:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944289;
        bh=VtCfLABy9jFIpwB0CiuNGNBuZRK0+oBQP1HeBXvQ2ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yvYaoQyBy/S8txccoQ0a9n7aOTZodDfqeRVUFtXS5mYcPpRZz5dEqW5RtkffI2pe5
         05hwTca/3gNy45ZVvTmLDtxRENp4QIMU2DjGt27+aplibW7jUwPH0Yh5o0aKt7c8Vc
         9Z4ucA2jTez13UEpqKdynNwTaxZxfYfj2NGaVI+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, dihu <anny.hu@linux.alibaba.com>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 247/314] bpf/sockmap: Fix kernel panic at __tcp_bpf_recvmsg
Date:   Tue, 23 Jun 2020 21:57:22 +0200
Message-Id: <20200623195350.731188809@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: dihu <anny.hu@linux.alibaba.com>

[ Upstream commit 487082fb7bd2a32b66927d2b22e3a81b072b44f0 ]

When user application calls read() with MSG_PEEK flag to read data
of bpf sockmap socket, kernel panic happens at
__tcp_bpf_recvmsg+0x12c/0x350. sk_msg is not removed from ingress_msg
queue after read out under MSG_PEEK flag is set. Because it's not
judged whether sk_msg is the last msg of ingress_msg queue, the next
sk_msg may be the head of ingress_msg queue, whose memory address of
sg page is invalid. So it's necessary to add check codes to prevent
this problem.

[20759.125457] BUG: kernel NULL pointer dereference, address:
0000000000000008
[20759.132118] CPU: 53 PID: 51378 Comm: envoy Tainted: G            E
5.4.32 #1
[20759.140890] Hardware name: Inspur SA5212M4/YZMB-00370-109, BIOS
4.1.12 06/18/2017
[20759.149734] RIP: 0010:copy_page_to_iter+0xad/0x300
[20759.270877] __tcp_bpf_recvmsg+0x12c/0x350
[20759.276099] tcp_bpf_recvmsg+0x113/0x370
[20759.281137] inet_recvmsg+0x55/0xc0
[20759.285734] __sys_recvfrom+0xc8/0x130
[20759.290566] ? __audit_syscall_entry+0x103/0x130
[20759.296227] ? syscall_trace_enter+0x1d2/0x2d0
[20759.301700] ? __audit_syscall_exit+0x1e4/0x290
[20759.307235] __x64_sys_recvfrom+0x24/0x30
[20759.312226] do_syscall_64+0x55/0x1b0
[20759.316852] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Signed-off-by: dihu <anny.hu@linux.alibaba.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20200605084625.9783-1-anny.hu@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 69b0254083904..ad9f382027311 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -96,6 +96,9 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 		} while (i != msg_rx->sg.end);
 
 		if (unlikely(peek)) {
+			if (msg_rx == list_last_entry(&psock->ingress_msg,
+						      struct sk_msg, list))
+				break;
 			msg_rx = list_next_entry(msg_rx, list);
 			continue;
 		}
-- 
2.25.1



