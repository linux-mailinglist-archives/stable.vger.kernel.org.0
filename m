Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF96921FBC3
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729596AbgGNS4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:56:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:53972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730946AbgGNS4H (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:56:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB98C222B9;
        Tue, 14 Jul 2020 18:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752967;
        bh=myVRQdXGt0UVdgzE8muKBbLJoqWBSTT3ql4kxLGvZPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M1KzutpKGWyBrrhXQr2F6y+uS34b2qJ6Z3z/Uf33vKY4HkwfvXMSKvoYmj915bqGr
         L44V5dNyLRAQU55RJaJSi7PWfVY8PuOdgt5JtPCCAtHtLhjAC2S/riDQRSkplgb3vV
         MFpoD4ql4qNRrSXNbD/JxbT6VkSuSgm8wFsVpZ4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 069/166] netfilter: conntrack: refetch conntrack after nf_conntrack_update()
Date:   Tue, 14 Jul 2020 20:43:54 +0200
Message-Id: <20200714184119.164366028@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit d005fbb855d3b5660d62ee5a6bd2d99c13ff8cf3 ]

__nf_conntrack_update() might refresh the conntrack object that is
attached to the skbuff. Otherwise, this triggers UAF.

[  633.200434] ==================================================================
[  633.200472] BUG: KASAN: use-after-free in nf_conntrack_update+0x34e/0x770 [nf_conntrack]
[  633.200478] Read of size 1 at addr ffff888370804c00 by task nfqnl_test/6769

[  633.200487] CPU: 1 PID: 6769 Comm: nfqnl_test Not tainted 5.8.0-rc2+ #388
[  633.200490] Hardware name: LENOVO 23259H1/23259H1, BIOS G2ET32WW (1.12 ) 05/30/2012
[  633.200491] Call Trace:
[  633.200499]  dump_stack+0x7c/0xb0
[  633.200526]  ? nf_conntrack_update+0x34e/0x770 [nf_conntrack]
[  633.200532]  print_address_description.constprop.6+0x1a/0x200
[  633.200539]  ? _raw_write_lock_irqsave+0xc0/0xc0
[  633.200568]  ? nf_conntrack_update+0x34e/0x770 [nf_conntrack]
[  633.200594]  ? nf_conntrack_update+0x34e/0x770 [nf_conntrack]
[  633.200598]  kasan_report.cold.9+0x1f/0x42
[  633.200604]  ? call_rcu+0x2c0/0x390
[  633.200633]  ? nf_conntrack_update+0x34e/0x770 [nf_conntrack]
[  633.200659]  nf_conntrack_update+0x34e/0x770 [nf_conntrack]
[  633.200687]  ? nf_conntrack_find_get+0x30/0x30 [nf_conntrack]

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1436
Fixes: ee04805ff54a ("netfilter: conntrack: make conntrack userspace helpers work again")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index bb72ca5f3999a..3ab6dbb6588e2 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2149,6 +2149,8 @@ static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
 		err = __nf_conntrack_update(net, skb, ct, ctinfo);
 		if (err < 0)
 			return err;
+
+		ct = nf_ct_get(skb, &ctinfo);
 	}
 
 	return nf_confirm_cthelper(skb, ct, ctinfo);
-- 
2.25.1



