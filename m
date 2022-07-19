Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63551579934
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237789AbiGSMAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237794AbiGSL7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 07:59:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04C62F672;
        Tue, 19 Jul 2022 04:57:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE7FEB81B2E;
        Tue, 19 Jul 2022 11:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C70C341C6;
        Tue, 19 Jul 2022 11:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231866;
        bh=jF5alRkszrWGyOrFSlTJbFMU72SJN99KjO7GoaANxsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AfmM66IdX0M9fgQZrE9nesIS5PCNRuHTmESY1b/gBWAy9BCXkgHf4A13z+kG0tqJp
         qxj1aNEgOPzRLVx/3D+cKFRRysM7rqp0tS6+tv4P2SB3qXQ7eTRFKbs84gO4RqzOh5
         Qe7JktMwfASHv5xNRJ4LAnkDwp9fPeA6YAhipfXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ma Yuying <yuma@redhat.com>,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 24/43] sfc: fix kernel panic when creating VF
Date:   Tue, 19 Jul 2022 13:53:55 +0200
Message-Id: <20220719114524.102627942@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114521.868169025@linuxfoundation.org>
References: <20220719114521.868169025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Íñigo Huguet <ihuguet@redhat.com>

[ Upstream commit ada74c5539eba06cf8b47d068f92e0b3963a9a6e ]

When creating VFs a kernel panic can happen when calling to
efx_ef10_try_update_nic_stats_vf.

When releasing a DMA coherent buffer, sometimes, I don't know in what
specific circumstances, it has to unmap memory with vunmap. It is
disallowed to do that in IRQ context or with BH disabled. Otherwise, we
hit this line in vunmap, causing the crash:
  BUG_ON(in_interrupt());

This patch reenables BH to release the buffer.

Log messages when the bug is hit:
 kernel BUG at mm/vmalloc.c:2727!
 invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
 CPU: 6 PID: 1462 Comm: NetworkManager Kdump: loaded Tainted: G          I      --------- ---  5.14.0-119.el9.x86_64 #1
 Hardware name: Dell Inc. PowerEdge R740/06WXJT, BIOS 2.8.2 08/27/2020
 RIP: 0010:vunmap+0x2e/0x30
 ...skip...
 Call Trace:
  __iommu_dma_free+0x96/0x100
  efx_nic_free_buffer+0x2b/0x40 [sfc]
  efx_ef10_try_update_nic_stats_vf+0x14a/0x1c0 [sfc]
  efx_ef10_update_stats_vf+0x18/0x40 [sfc]
  efx_start_all+0x15e/0x1d0 [sfc]
  efx_net_open+0x5a/0xe0 [sfc]
  __dev_open+0xe7/0x1a0
  __dev_change_flags+0x1d7/0x240
  dev_change_flags+0x21/0x60
  ...skip...

Fixes: d778819609a2 ("sfc: DMA the VF stats only when requested")
Reported-by: Ma Yuying <yuma@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
Link: https://lore.kernel.org/r/20220713092116.21238-1-ihuguet@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ef10.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 4f0da3963b01..1dfb14a035f9 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1896,7 +1896,10 @@ static int efx_ef10_try_update_nic_stats_vf(struct efx_nic *efx)
 
 	efx_update_sw_stats(efx, stats);
 out:
+	/* releasing a DMA coherent buffer with BH disabled can panic */
+	spin_unlock_bh(&efx->stats_lock);
 	efx_nic_free_buffer(efx, &stats_buf);
+	spin_lock_bh(&efx->stats_lock);
 	return rc;
 }
 
-- 
2.35.1



