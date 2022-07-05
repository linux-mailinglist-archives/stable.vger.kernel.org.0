Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A069566E16
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237522AbiGEMbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237964AbiGEM03 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:26:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5760465D4;
        Tue,  5 Jul 2022 05:18:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB2CC61AC8;
        Tue,  5 Jul 2022 12:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081D8C341C7;
        Tue,  5 Jul 2022 12:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023510;
        bh=dy7bOytgF344lIFWXNRmT21pW2lZa+vQbXwQxR7s3v4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vMKIrJOz1GEptwXpLAjW0PoM6ubaRUqMoX/D6fwadmrujc4YYwC3vOr+s4nVYu+kG
         ftgD1nHlY8+n0hVhZoQmA9zilLPm4P7K97PDrgHhPZu0DzL1V+Hk3lB3zkSSAaZ1gK
         x562+Nsf9VyZlNj0Z+vZMa57nQPQJxCkVvYqjUDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tao Liu <thomas.liu@ucloud.cn>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.18 035/102] linux/dim: Fix divide by 0 in RDMA DIM
Date:   Tue,  5 Jul 2022 13:58:01 +0200
Message-Id: <20220705115619.410043049@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tao Liu <thomas.liu@ucloud.cn>

commit 0fe3dbbefb74a8575f61d7801b08dbc50523d60d upstream.

Fix a divide 0 error in rdma_dim_stats_compare() when prev->cpe_ratio ==
0.

CallTrace:
  Hardware name: H3C R4900 G3/RS33M2C9S, BIOS 2.00.37P21 03/12/2020
  task: ffff880194b78000 task.stack: ffffc90006714000
  RIP: 0010:backport_rdma_dim+0x10e/0x240 [mlx_compat]
  RSP: 0018:ffff880c10e83ec0 EFLAGS: 00010202
  RAX: 0000000000002710 RBX: ffff88096cd7f780 RCX: 0000000000000064
  RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000001
  RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000000 R12: 000000001d7c6c09
  R13: ffff88096cd7f780 R14: ffff880b174fe800 R15: 0000000000000000
  FS:  0000000000000000(0000) GS:ffff880c10e80000(0000)
  knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00000000a0965b00 CR3: 000000000200a003 CR4: 00000000007606e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  PKRU: 55555554
  Call Trace:
   <IRQ>
   ib_poll_handler+0x43/0x80 [ib_core]
   irq_poll_softirq+0xae/0x110
   __do_softirq+0xd1/0x28c
   irq_exit+0xde/0xf0
   do_IRQ+0x54/0xe0
   common_interrupt+0x8f/0x8f
   </IRQ>
   ? cpuidle_enter_state+0xd9/0x2a0
   ? cpuidle_enter_state+0xc7/0x2a0
   ? do_idle+0x170/0x1d0
   ? cpu_startup_entry+0x6f/0x80
   ? start_secondary+0x1b9/0x210
   ? secondary_startup_64+0xa5/0xb0
  Code: 0f 87 e1 00 00 00 8b 4c 24 14 44 8b 43 14 89 c8 4d 63 c8 44 29 c0 99 31 d0 29 d0 31 d2 48 98 48 8d 04 80 48 8d 04 80 48 c1 e0 02 <49> f7 f1 48 83 f8 0a 0f 86 c1 00 00 00 44 39 c1 7f 10 48 89 df
  RIP: backport_rdma_dim+0x10e/0x240 [mlx_compat] RSP: ffff880c10e83ec0

Fixes: f4915455dcf0 ("linux/dim: Implement RDMA adaptive moderation (DIM)")
Link: https://lore.kernel.org/r/20220627140004.3099-1-thomas.liu@ucloud.cn
Signed-off-by: Tao Liu <thomas.liu@ucloud.cn>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Acked-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/dim.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/dim.h
+++ b/include/linux/dim.h
@@ -21,7 +21,7 @@
  * We consider 10% difference as significant.
  */
 #define IS_SIGNIFICANT_DIFF(val, ref) \
-	(((100UL * abs((val) - (ref))) / (ref)) > 10)
+	((ref) && (((100UL * abs((val) - (ref))) / (ref)) > 10))
 
 /*
  * Calculate the gap between two values.


