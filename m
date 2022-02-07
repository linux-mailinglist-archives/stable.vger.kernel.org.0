Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83CFB4ABCAA
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387013AbiBGLig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385683AbiBGLcG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:32:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F32C0401D3;
        Mon,  7 Feb 2022 03:31:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A6A160A67;
        Mon,  7 Feb 2022 11:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE7CC004E1;
        Mon,  7 Feb 2022 11:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233512;
        bh=se97KZL3JpsFxJ8ZQy95Brw1C50SVIoarbrezIf3j+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0nCAo6feEwdEQyvwNeUd/5ZZiVny/BI64UJu5IkSBuT3MBZAi58Av5Oecz26dOwCw
         6XsFJTPGRXMHAI4Any1hvy6eHXiWl9uxAfe31JCBwMtHS72+hp0GTs/mW9lxwnB48P
         LsSmPJpSmaZk/F5cwpOxTPQfzSkun/IFTL4JtLFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.16 036/126] IB/hfi1: Fix panic with larger ipoib send_queue_size
Date:   Mon,  7 Feb 2022 12:06:07 +0100
Message-Id: <20220207103805.388207888@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

commit 8c83d39cc730378bbac64d67a551897b203a606e upstream.

When the ipoib send_queue_size is increased from the default the following
panic happens:

  RIP: 0010:hfi1_ipoib_drain_tx_ring+0x45/0xf0 [hfi1]
  Code: 31 e4 eb 0f 8b 85 c8 02 00 00 41 83 c4 01 44 39 e0 76 60 8b 8d cc 02 00 00 44 89 e3 be 01 00 00 00 d3 e3 48 03 9d c0 02 00 00 <c7> 83 18 01 00 00 00 00 00 00 48 8b bb 30 01 00 00 e8 25 af a7 e0
  RSP: 0018:ffffc9000798f4a0 EFLAGS: 00010286
  RAX: 0000000000008000 RBX: ffffc9000aa0f000 RCX: 000000000000000f
  RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
  RBP: ffff88810ff08000 R08: ffff88889476d900 R09: 0000000000000101
  R10: 0000000000000000 R11: ffffc90006590ff8 R12: 0000000000000200
  R13: ffffc9000798fba8 R14: 0000000000000000 R15: 0000000000000001
  FS:  00007fd0f79cc3c0(0000) GS:ffff88885fb00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffffc9000aa0f118 CR3: 0000000889c84001 CR4: 00000000001706e0
  Call Trace:
   <TASK>
   hfi1_ipoib_napi_tx_disable+0x45/0x60 [hfi1]
   hfi1_ipoib_dev_stop+0x18/0x80 [hfi1]
   ipoib_ib_dev_stop+0x1d/0x40 [ib_ipoib]
   ipoib_stop+0x48/0xc0 [ib_ipoib]
   __dev_close_many+0x9e/0x110
   __dev_change_flags+0xd9/0x210
   dev_change_flags+0x21/0x60
   do_setlink+0x31c/0x10f0
   ? __nla_validate_parse+0x12d/0x1a0
   ? __nla_parse+0x21/0x30
   ? inet6_validate_link_af+0x5e/0xf0
   ? cpumask_next+0x1f/0x20
   ? __snmp6_fill_stats64.isra.53+0xbb/0x140
   ? __nla_validate_parse+0x47/0x1a0
   __rtnl_newlink+0x530/0x910
   ? pskb_expand_head+0x73/0x300
   ? __kmalloc_node_track_caller+0x109/0x280
   ? __nla_put+0xc/0x20
   ? cpumask_next_and+0x20/0x30
   ? update_sd_lb_stats.constprop.144+0xd3/0x820
   ? _raw_spin_unlock_irqrestore+0x25/0x37
   ? __wake_up_common_lock+0x87/0xc0
   ? kmem_cache_alloc_trace+0x3d/0x3d0
   rtnl_newlink+0x43/0x60

The issue happens when the shift that should have been a function of the
txq item size mistakenly used the ring size.

Fix by using the item size.

Cc: stable@vger.kernel.org
Fixes: d47dfc2b00e6 ("IB/hfi1: Remove cache and embed txreq in ring")
Link: https://lore.kernel.org/r/1642287756-182313-2-git-send-email-mike.marciniszyn@cornelisnetworks.com
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hfi1/ipoib_tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/hfi1/ipoib_tx.c
+++ b/drivers/infiniband/hw/hfi1/ipoib_tx.c
@@ -731,7 +731,7 @@ int hfi1_ipoib_txreq_init(struct hfi1_ip
 			goto free_txqs;
 
 		txq->tx_ring.max_items = tx_ring_size;
-		txq->tx_ring.shift = ilog2(tx_ring_size);
+		txq->tx_ring.shift = ilog2(tx_item_size);
 		txq->tx_ring.avail = hfi1_ipoib_ring_hwat(txq);
 
 		netif_tx_napi_add(dev, &txq->napi,


