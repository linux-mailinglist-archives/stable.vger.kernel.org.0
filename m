Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2E321FC39
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730414AbgGNSvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:51:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729986AbgGNSvn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:51:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0201122B2A;
        Tue, 14 Jul 2020 18:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752702;
        bh=kTY2Fjn4gqXaQmk4478iYSdk+A5ULQRdbyTB/5xmTzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o9sxlssVWti3vjFqBFIMLCfV/JepOOFUZ4wH7EIjXfw5EyetujGrH/2hMh5fwKIIT
         aFnZICgy5bbvJB4al7ckHPT/cwFAaR1mG3LDpg8oO0r7Cpyxva5yVe/0Ox+LibVoDS
         5OZlLOb3S3sSXiBn0YmPDNKHrbTyMSoRCTlukTok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/109] netfilter: conntrack: refetch conntrack after nf_conntrack_update()
Date:   Tue, 14 Jul 2020 20:43:50 +0200
Message-Id: <20200714184107.774838090@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
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
index 48db4aec02dea..200cdad3ff3ab 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2012,6 +2012,8 @@ static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
 		err = __nf_conntrack_update(net, skb, ct, ctinfo);
 		if (err < 0)
 			return err;
+
+		ct = nf_ct_get(skb, &ctinfo);
 	}
 
 	return nf_confirm_cthelper(skb, ct, ctinfo);
-- 
2.25.1



