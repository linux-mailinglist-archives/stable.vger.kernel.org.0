Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD3A582E2F
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiG0RJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241491AbiG0RJG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:09:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632775B054;
        Wed, 27 Jul 2022 09:40:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C90460BAF;
        Wed, 27 Jul 2022 16:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75563C433D6;
        Wed, 27 Jul 2022 16:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940042;
        bh=NEa48WcsFvIgqPqblPrCpFOSbs6qiZ9b5ObRDAzNO18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n2Dn9yvr/EGFFqnqZjgKQv74lOy4ZaTIjU8wimDblEumOBVvVVDBQsNkS/JR2EC6v
         DntyAk5T2mcWupgqChXTm+Bj5iYtXY0Vyq49NJ+H8gRulPoFdZaVsAeXAjJ+2AKPbX
         ID+xIi1j6HF02qa9Em28jqIJePO2mDY/o7vR3Xz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cedric Wassenaar <cedric@bytespeed.nl>,
        Junxiao Chang <junxiao.chang@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/201] net: stmmac: fix dma queue left shift overflow issue
Date:   Wed, 27 Jul 2022 18:09:49 +0200
Message-Id: <20220727161031.268059384@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junxiao Chang <junxiao.chang@intel.com>

[ Upstream commit 613b065ca32e90209024ec4a6bb5ca887ee70980 ]

When queue number is > 4, left shift overflows due to 32 bits
integer variable. Mask calculation is wrong for MTL_RXQ_DMA_MAP1.

If CONFIG_UBSAN is enabled, kernel dumps below warning:
[   10.363842] ==================================================================
[   10.363882] UBSAN: shift-out-of-bounds in /build/linux-intel-iotg-5.15-8e6Tf4/
linux-intel-iotg-5.15-5.15.0/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c:224:12
[   10.363929] shift exponent 40 is too large for 32-bit type 'unsigned int'
[   10.363953] CPU: 1 PID: 599 Comm: NetworkManager Not tainted 5.15.0-1003-intel-iotg
[   10.363956] Hardware name: ADLINK Technology Inc. LEC-EL/LEC-EL, BIOS 0.15.11 12/22/2021
[   10.363958] Call Trace:
[   10.363960]  <TASK>
[   10.363963]  dump_stack_lvl+0x4a/0x5f
[   10.363971]  dump_stack+0x10/0x12
[   10.363974]  ubsan_epilogue+0x9/0x45
[   10.363976]  __ubsan_handle_shift_out_of_bounds.cold+0x61/0x10e
[   10.363979]  ? wake_up_klogd+0x4a/0x50
[   10.363983]  ? vprintk_emit+0x8f/0x240
[   10.363986]  dwmac4_map_mtl_dma.cold+0x42/0x91 [stmmac]
[   10.364001]  stmmac_mtl_configuration+0x1ce/0x7a0 [stmmac]
[   10.364009]  ? dwmac410_dma_init_channel+0x70/0x70 [stmmac]
[   10.364020]  stmmac_hw_setup.cold+0xf/0xb14 [stmmac]
[   10.364030]  ? page_pool_alloc_pages+0x4d/0x70
[   10.364034]  ? stmmac_clear_tx_descriptors+0x6e/0xe0 [stmmac]
[   10.364042]  stmmac_open+0x39e/0x920 [stmmac]
[   10.364050]  __dev_open+0xf0/0x1a0
[   10.364054]  __dev_change_flags+0x188/0x1f0
[   10.364057]  dev_change_flags+0x26/0x60
[   10.364059]  do_setlink+0x908/0xc40
[   10.364062]  ? do_setlink+0xb10/0xc40
[   10.364064]  ? __nla_validate_parse+0x4c/0x1a0
[   10.364068]  __rtnl_newlink+0x597/0xa10
[   10.364072]  ? __nla_reserve+0x41/0x50
[   10.364074]  ? __kmalloc_node_track_caller+0x1d0/0x4d0
[   10.364079]  ? pskb_expand_head+0x75/0x310
[   10.364082]  ? nla_reserve_64bit+0x21/0x40
[   10.364086]  ? skb_free_head+0x65/0x80
[   10.364089]  ? security_sock_rcv_skb+0x2c/0x50
[   10.364094]  ? __cond_resched+0x19/0x30
[   10.364097]  ? kmem_cache_alloc_trace+0x15a/0x420
[   10.364100]  rtnl_newlink+0x49/0x70

This change fixes MTL_RXQ_DMA_MAP1 mask issue and channel/queue
mapping warning.

Fixes: d43042f4da3e ("net: stmmac: mapping mtl rx to dma channel")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=216195
Reported-by: Cedric Wassenaar <cedric@bytespeed.nl>
Signed-off-by: Junxiao Chang <junxiao.chang@intel.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index b21745368983..412abfabd28b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -219,6 +219,9 @@ static void dwmac4_map_mtl_dma(struct mac_device_info *hw, u32 queue, u32 chan)
 	if (queue == 0 || queue == 4) {
 		value &= ~MTL_RXQ_DMA_Q04MDMACH_MASK;
 		value |= MTL_RXQ_DMA_Q04MDMACH(chan);
+	} else if (queue > 4) {
+		value &= ~MTL_RXQ_DMA_QXMDMACH_MASK(queue - 4);
+		value |= MTL_RXQ_DMA_QXMDMACH(chan, queue - 4);
 	} else {
 		value &= ~MTL_RXQ_DMA_QXMDMACH_MASK(queue);
 		value |= MTL_RXQ_DMA_QXMDMACH(chan, queue);
-- 
2.35.1



