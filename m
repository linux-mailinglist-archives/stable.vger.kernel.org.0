Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8EE28B822
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389931AbgJLNtc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:49:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731921AbgJLNsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B111F208B8;
        Mon, 12 Oct 2020 13:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510496;
        bh=NcLttnXbIFkLfWLaSHVxRmkVgEAXOwoUEuurVdyb/dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJZRd8fzRBHgNnZF/Qi0omQZdY/g0DfMpgb7D5Nr6esjWRf5rINOo7uyf2CcZ2xqP
         V0n9QsAQ7zCYiSK7BhtROW3khbCnxNBcou2AV5gapkwdY3ag+vVnKfOvwkJiMQrJli
         Sd2ypOX/dMg42lkKBNEPAv7sGWmMq7dntzEHvppo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rohit Maheshwari <rohitm@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 117/124] net/tls: race causes kernel panic
Date:   Mon, 12 Oct 2020 15:32:01 +0200
Message-Id: <20201012133152.512600163@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rohit Maheshwari <rohitm@chelsio.com>

commit 38f7e1c0c43dd25b06513137bb6fd35476f9ec6d upstream.

BUG: kernel NULL pointer dereference, address: 00000000000000b8
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 80000008b6fef067 P4D 80000008b6fef067 PUD 8b6fe6067 PMD 0
 Oops: 0000 [#1] SMP PTI
 CPU: 12 PID: 23871 Comm: kworker/12:80 Kdump: loaded Tainted: G S
 5.9.0-rc3+ #1
 Hardware name: Supermicro X10SRA-F/X10SRA-F, BIOS 2.1 03/29/2018
 Workqueue: events tx_work_handler [tls]
 RIP: 0010:tx_work_handler+0x1b/0x70 [tls]
 Code: dc fe ff ff e8 16 d4 a3 f6 66 0f 1f 44 00 00 0f 1f 44 00 00 55 53 48 8b
 6f 58 48 8b bd a0 04 00 00 48 85 ff 74 1c 48 8b 47 28 <48> 8b 90 b8 00 00 00 83
 e2 02 75 0c f0 48 0f ba b0 b8 00 00 00 00
 RSP: 0018:ffffa44ace61fe88 EFLAGS: 00010286
 RAX: 0000000000000000 RBX: ffff91da9e45cc30 RCX: dead000000000122
 RDX: 0000000000000001 RSI: ffff91da9e45cc38 RDI: ffff91d95efac200
 RBP: ffff91da133fd780 R08: 0000000000000000 R09: 000073746e657665
 R10: 8080808080808080 R11: 0000000000000000 R12: ffff91dad7d30700
 R13: ffff91dab6561080 R14: 0ffff91dad7d3070 R15: ffff91da9e45cc38
 FS:  0000000000000000(0000) GS:ffff91dad7d00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00000000000000b8 CR3: 0000000906478003 CR4: 00000000003706e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  process_one_work+0x1a7/0x370
  worker_thread+0x30/0x370
  ? process_one_work+0x370/0x370
  kthread+0x114/0x130
  ? kthread_park+0x80/0x80
  ret_from_fork+0x22/0x30

tls_sw_release_resources_tx() waits for encrypt_pending, which
can have race, so we need similar changes as in commit
0cada33241d9de205522e3858b18e506ca5cce2c here as well.

Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/tls/tls_sw.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2142,10 +2142,15 @@ void tls_sw_release_resources_tx(struct
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
 	struct tls_rec *rec, *tmp;
+	int pending;
 
 	/* Wait for any pending async encryptions to complete */
-	smp_store_mb(ctx->async_notify, true);
-	if (atomic_read(&ctx->encrypt_pending))
+	spin_lock_bh(&ctx->encrypt_compl_lock);
+	ctx->async_notify = true;
+	pending = atomic_read(&ctx->encrypt_pending);
+	spin_unlock_bh(&ctx->encrypt_compl_lock);
+
+	if (pending)
 		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
 
 	tls_tx_records(sk, -1);


