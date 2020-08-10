Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B706240A16
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbgHJPZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728466AbgHJPZz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:25:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3061822CF7;
        Mon, 10 Aug 2020 15:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073154;
        bh=dK+dE3HFvoYVSktKHD4lSR0Qr1HltIXoGbfJokD2cB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jf+jsbTzdJoVSYPgD4rit7iVTnP5fJdouvt6gq/K84rvB9RxDM6dfAIetpKoBwmKb
         imdKWz4pmLzQ90yknbCWbX5KS8Jb1dDL7sAWy9F3P3xXwZNxZSZ6dPeNyKwlNe4aE6
         Rgv1NUXyOG9gsc2Mnj26al6tCRV5+zpmNjK8MdCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>
Subject: [PATCH 5.7 76/79] mptcp: be careful on subflow creation
Date:   Mon, 10 Aug 2020 17:21:35 +0200
Message-Id: <20200810151815.970854393@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit adf7341064982de923a1f8a11bcdec48be6b3004 ]

Nicolas reported the following oops:

[ 1521.392541] BUG: kernel NULL pointer dereference, address: 00000000000000c0
[ 1521.394189] #PF: supervisor read access in kernel mode
[ 1521.395376] #PF: error_code(0x0000) - not-present page
[ 1521.396607] PGD 0 P4D 0
[ 1521.397156] Oops: 0000 [#1] SMP PTI
[ 1521.398020] CPU: 0 PID: 22986 Comm: kworker/0:2 Not tainted 5.8.0-rc4+ #109
[ 1521.399618] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[ 1521.401728] Workqueue: events mptcp_worker
[ 1521.402651] RIP: 0010:mptcp_subflow_create_socket+0xf1/0x1c0
[ 1521.403954] Code: 24 08 89 44 24 04 48 8b 7a 18 e8 2a 48 d4 ff 8b 44 24 04 85 c0 75 7a 48 8b 8b 78 02 00 00 48 8b 54 24 08 48 8d bb 80 00 00 00 <48> 8b 89 c0 00 00 00 48 89 8a c0 00 00 00 48 8b 8b 78 02 00 00 8b
[ 1521.408201] RSP: 0000:ffffabc4002d3c60 EFLAGS: 00010246
[ 1521.409433] RAX: 0000000000000000 RBX: ffffa0b9ad8c9a00 RCX: 0000000000000000
[ 1521.411096] RDX: ffffa0b9ae78a300 RSI: 00000000fffffe01 RDI: ffffa0b9ad8c9a80
[ 1521.412734] RBP: ffffa0b9adff2e80 R08: ffffa0b9af02d640 R09: ffffa0b9ad923a00
[ 1521.414333] R10: ffffabc4007139f8 R11: fefefefefefefeff R12: ffffabc4002d3cb0
[ 1521.415918] R13: ffffa0b9ad91fa58 R14: ffffa0b9ad8c9f9c R15: 0000000000000000
[ 1521.417592] FS:  0000000000000000(0000) GS:ffffa0b9af000000(0000) knlGS:0000000000000000
[ 1521.419490] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1521.420839] CR2: 00000000000000c0 CR3: 000000002951e006 CR4: 0000000000160ef0
[ 1521.422511] Call Trace:
[ 1521.423103]  __mptcp_subflow_connect+0x94/0x1f0
[ 1521.425376]  mptcp_pm_create_subflow_or_signal_addr+0x200/0x2a0
[ 1521.426736]  mptcp_worker+0x31b/0x390
[ 1521.431324]  process_one_work+0x1fc/0x3f0
[ 1521.432268]  worker_thread+0x2d/0x3b0
[ 1521.434197]  kthread+0x117/0x130
[ 1521.435783]  ret_from_fork+0x22/0x30

on some unconventional configuration.

The MPTCP protocol is trying to create a subflow for an
unaccepted server socket. That is allowed by the RFC, even
if subflow creation will likely fail.
Unaccepted sockets have still a NULL sk_socket field,
avoid the issue by failing earlier.

Reported-and-tested-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
Fixes: 7d14b0d2b9b3 ("mptcp: set correct vfs info for subflows")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -999,6 +999,12 @@ int mptcp_subflow_create_socket(struct s
 	struct socket *sf;
 	int err;
 
+	/* un-accepted server sockets can reach here - on bad configuration
+	 * bail early to avoid greater trouble later
+	 */
+	if (unlikely(!sk->sk_socket))
+		return -EINVAL;
+
 	err = sock_create_kern(net, sk->sk_family, SOCK_STREAM, IPPROTO_TCP,
 			       &sf);
 	if (err)


