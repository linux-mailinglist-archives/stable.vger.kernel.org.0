Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553385EA483
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236023AbiIZLrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239011AbiIZLp3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:45:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0819774CE4;
        Mon, 26 Sep 2022 03:47:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01AB060BB7;
        Mon, 26 Sep 2022 10:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECCAC433D6;
        Mon, 26 Sep 2022 10:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189239;
        bh=hQcWRXxZ4BZEXkkxaFOZs/IaqlSrhGIRXSNxcRDbbQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UYgSCgVXWSZ4xCO8ABbn1I65uxXSdWxACKirBbENqHzyS27jwGYxh3YB53y4/GgD+
         QR4RO1NZx3WdJSo8jcrsqbNGikWtH26NwY03IwaN/G7qHQY8QCoczBH9Zx3VdDVDlz
         rsMkX9IcXx9sh8KG1fCV2Mt97TfLV8l/Q4OzqdYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tianhao Zhao <tizhao@redhat.com>,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 119/207] sfc: fix TX channel offset when using legacy interrupts
Date:   Mon, 26 Sep 2022 12:11:48 +0200
Message-Id: <20220926100811.892001916@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Íñigo Huguet <ihuguet@redhat.com>

[ Upstream commit f232af4295653afa4ade3230462b3be15ad16419 ]

In legacy interrupt mode the tx_channel_offset was hardcoded to 1, but
that's not correct if efx_sepparate_tx_channels is false. In that case,
the offset is 0 because the tx queues are in the single existing channel
at index 0, together with the rx queue.

Without this fix, as soon as you try to send any traffic, it tries to
get the tx queues from an uninitialized channel getting these errors:
  WARNING: CPU: 1 PID: 0 at drivers/net/ethernet/sfc/tx.c:540 efx_hard_start_xmit+0x12e/0x170 [sfc]
  [...]
  RIP: 0010:efx_hard_start_xmit+0x12e/0x170 [sfc]
  [...]
  Call Trace:
   <IRQ>
   dev_hard_start_xmit+0xd7/0x230
   sch_direct_xmit+0x9f/0x360
   __dev_queue_xmit+0x890/0xa40
  [...]
  BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
  [...]
  RIP: 0010:efx_hard_start_xmit+0x153/0x170 [sfc]
  [...]
  Call Trace:
   <IRQ>
   dev_hard_start_xmit+0xd7/0x230
   sch_direct_xmit+0x9f/0x360
   __dev_queue_xmit+0x890/0xa40
  [...]

Fixes: c308dfd1b43e ("sfc: fix wrong tx channel offset with efx_separate_tx_channels")
Reported-by: Tianhao Zhao <tizhao@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
Link: https://lore.kernel.org/r/20220914103648.16902-1-ihuguet@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/efx_channels.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 032b8c0bd788..5b4d661ab986 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -319,7 +319,7 @@ int efx_probe_interrupts(struct efx_nic *efx)
 		efx->n_channels = 1 + (efx_separate_tx_channels ? 1 : 0);
 		efx->n_rx_channels = 1;
 		efx->n_tx_channels = 1;
-		efx->tx_channel_offset = 1;
+		efx->tx_channel_offset = efx_separate_tx_channels ? 1 : 0;
 		efx->n_xdp_channels = 0;
 		efx->xdp_channel_offset = efx->n_channels;
 		efx->legacy_irq = efx->pci_dev->irq;
-- 
2.35.1



