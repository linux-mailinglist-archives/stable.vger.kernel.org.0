Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2F77188004
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgCQLGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:06:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728615AbgCQLGa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:06:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 355D320658;
        Tue, 17 Mar 2020 11:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443189;
        bh=EGOVcHAm9+4S56CNGZKK0RMTbMh0xuIspggeSUBZaHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZyfShOpBCUZtEA3PLB0qfRoJrHW+lj2m7qUW0NCDKZWfQNizknHSm5OvfkxSkB/QV
         NA5J10R+HiTyZi3FiHUGfco+DV+QeRC/WP9SVRltYfE4wHQ+vWV0HqrP5sfeFcFo9Q
         TD2EgTGpMj2gx0g/KYcoi49qrVX1vItCEg5D8zEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 116/123] netfilter: nft_chain_nat: inet family is missing module ownership
Date:   Tue, 17 Mar 2020 11:55:43 +0100
Message-Id: <20200317103319.220673550@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 6a42cefb25d8bdc1b391f4a53c78c32164eea2dd upstream.

Set owner to THIS_MODULE, otherwise the nft_chain_nat module might be
removed while there are still inet/nat chains in place.

[  117.942096] BUG: unable to handle page fault for address: ffffffffa0d5e040
[  117.942101] #PF: supervisor read access in kernel mode
[  117.942103] #PF: error_code(0x0000) - not-present page
[  117.942106] PGD 200c067 P4D 200c067 PUD 200d063 PMD 3dc909067 PTE 0
[  117.942113] Oops: 0000 [#1] PREEMPT SMP PTI
[  117.942118] CPU: 3 PID: 27 Comm: kworker/3:0 Not tainted 5.6.0-rc3+ #348
[  117.942133] Workqueue: events nf_tables_trans_destroy_work [nf_tables]
[  117.942145] RIP: 0010:nf_tables_chain_destroy.isra.0+0x94/0x15a [nf_tables]
[  117.942149] Code: f6 45 54 01 0f 84 d1 00 00 00 80 3b 05 74 44 48 8b 75 e8 48 c7 c7 72 be de a0 e8 56 e6 2d e0 48 8b 45 e8 48 c7 c7 7f be de a0 <48> 8b 30 e8 43 e6 2d e0 48 8b 45 e8 48 8b 40 10 48 85 c0 74 5b 8b
[  117.942152] RSP: 0018:ffffc9000015be10 EFLAGS: 00010292
[  117.942155] RAX: ffffffffa0d5e040 RBX: ffff88840be87fc2 RCX: 0000000000000007
[  117.942158] RDX: 0000000000000007 RSI: 0000000000000086 RDI: ffffffffa0debe7f
[  117.942160] RBP: ffff888403b54b50 R08: 0000000000001482 R09: 0000000000000004
[  117.942162] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8883eda7e540
[  117.942164] R13: dead000000000122 R14: dead000000000100 R15: ffff888403b3db80
[  117.942167] FS:  0000000000000000(0000) GS:ffff88840e4c0000(0000) knlGS:0000000000000000
[  117.942169] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  117.942172] CR2: ffffffffa0d5e040 CR3: 00000003e4c52002 CR4: 00000000001606e0
[  117.942174] Call Trace:
[  117.942188]  nf_tables_trans_destroy_work.cold+0xd/0x12 [nf_tables]
[  117.942196]  process_one_work+0x1d6/0x3b0
[  117.942200]  worker_thread+0x45/0x3c0
[  117.942203]  ? process_one_work+0x3b0/0x3b0
[  117.942210]  kthread+0x112/0x130
[  117.942214]  ? kthread_create_worker_on_cpu+0x40/0x40
[  117.942221]  ret_from_fork+0x35/0x40

nf_tables_chain_destroy() crashes on module_put() because the module is
gone.

Fixes: d164385ec572 ("netfilter: nat: add inet family nat support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nft_chain_nat.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/nft_chain_nat.c
+++ b/net/netfilter/nft_chain_nat.c
@@ -89,6 +89,7 @@ static const struct nft_chain_type nft_c
 	.name		= "nat",
 	.type		= NFT_CHAIN_T_NAT,
 	.family		= NFPROTO_INET,
+	.owner		= THIS_MODULE,
 	.hook_mask	= (1 << NF_INET_PRE_ROUTING) |
 			  (1 << NF_INET_LOCAL_IN) |
 			  (1 << NF_INET_LOCAL_OUT) |


