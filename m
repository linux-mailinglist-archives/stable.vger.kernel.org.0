Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36CFD12206C
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbfLQAyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:54:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35474 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727150AbfLQAvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15L-0003MA-Dg; Tue, 17 Dec 2019 00:51:35 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0005d0-La; Tue, 17 Dec 2019 00:51:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        "Lukas Wunner" <lukas@wunner.de>
Date:   Tue, 17 Dec 2019 00:47:30 +0000
Message-ID: <lsq.1576543535.161726696@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 116/136] netfilter: nf_tables: Align nft_expr private
 data to 64-bit
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

commit 250367c59e6ba0d79d702a059712d66edacd4a1a upstream.

Invoking the following commands on a 32-bit architecture with strict
alignment requirements (such as an ARMv7-based Raspberry Pi) results
in an alignment exception:

 # nft add table ip test-ip4
 # nft add chain ip test-ip4 output { type filter hook output priority 0; }
 # nft add rule  ip test-ip4 output quota 1025 bytes

Alignment trap: not handling instruction e1b26f9f at [<7f4473f8>]
Unhandled fault: alignment exception (0x001) at 0xb832e824
Internal error: : 1 [#1] PREEMPT SMP ARM
Hardware name: BCM2835
[<7f4473fc>] (nft_quota_do_init [nft_quota])
[<7f447448>] (nft_quota_init [nft_quota])
[<7f4260d0>] (nf_tables_newrule [nf_tables])
[<7f4168dc>] (nfnetlink_rcv_batch [nfnetlink])
[<7f416bd0>] (nfnetlink_rcv [nfnetlink])
[<8078b334>] (netlink_unicast)
[<8078b664>] (netlink_sendmsg)
[<8071b47c>] (sock_sendmsg)
[<8071bd18>] (___sys_sendmsg)
[<8071ce3c>] (__sys_sendmsg)
[<8071ce94>] (sys_sendmsg)

The reason is that nft_quota_do_init() calls atomic64_set() on an
atomic64_t which is only aligned to 32-bit, not 64-bit, because it
succeeds struct nft_expr in memory which only contains a 32-bit pointer.
Fix by aligning the nft_expr private data to 64-bit.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/netfilter/nf_tables.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -364,7 +364,8 @@ struct nft_expr_ops {
  */
 struct nft_expr {
 	const struct nft_expr_ops	*ops;
-	unsigned char			data[];
+	unsigned char			data[]
+		__attribute__((aligned(__alignof__(u64))));
 };
 
 static inline void *nft_expr_priv(const struct nft_expr *expr)

