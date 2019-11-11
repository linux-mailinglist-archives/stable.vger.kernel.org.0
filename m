Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7E2F7B6F
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbfKKSgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:36:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:54240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727515AbfKKSgG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:36:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72137222C2;
        Mon, 11 Nov 2019 18:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497366;
        bh=NZhrlxQ18TlRomQloYcGBR/p7FgXeL0TLBcyqc7zA5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VjnWIjmYOmK0Ozr/lTZL3sr1PvF9NhGMnyn5HX97iHR319NfZ5z3yhhUdL459T8mf
         AkbHuarjF7JkjBua/Epp6ztKdz9nexG54ATO4HuF7U5S0gOb3t4jpYJ8zjxNBXTtoJ
         stqZOFmZhFUITKtydlhQV6gtgEl89VcEN9wkf8W8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.14 029/105] netfilter: nf_tables: Align nft_expr private data to 64-bit
Date:   Mon, 11 Nov 2019 19:27:59 +0100
Message-Id: <20191111181437.943063174@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org # v3.13+
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/netfilter/nf_tables.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -759,7 +759,8 @@ struct nft_expr_ops {
  */
 struct nft_expr {
 	const struct nft_expr_ops	*ops;
-	unsigned char			data[];
+	unsigned char			data[]
+		__attribute__((aligned(__alignof__(u64))));
 };
 
 static inline void *nft_expr_priv(const struct nft_expr *expr)


