Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB760528E91
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346257AbiEPTsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346263AbiEPTsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:48:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82CE3F306;
        Mon, 16 May 2022 12:44:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4337BB8160D;
        Mon, 16 May 2022 19:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A279EC385AA;
        Mon, 16 May 2022 19:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730276;
        bh=M3L8iA3uzVxubFSnpSF1lgZbXB1VocSXLu2v7J1vBmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zeaYJtuGGaVX6iO6CAXKY71KVTKgsoRvItZQxs6GXnObOe1QMvTHZtIiLxcbYyGKV
         0kr0sBgtO2ZLlY2AHQMjHwep2SJ8tBAQySxv19P7P7iL6nrtX/67soYr3ouRN4KjiA
         amKvWHv1MvfMvdmUJPS+QpJ8+uRGUB6EbLJR/Gto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/66] sfc: Use swap() instead of open coding it
Date:   Mon, 16 May 2022 21:36:13 +0200
Message-Id: <20220516193619.800336883@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193619.400083785@linuxfoundation.org>
References: <20220516193619.400083785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit 0cf765fb00ce083c017f2571ac449cf7912cdb06 ]

Clean the following coccicheck warning:

./drivers/net/ethernet/sfc/efx_channels.c:870:36-37: WARNING opportunity
for swap().

./drivers/net/ethernet/sfc/efx_channels.c:824:36-37: WARNING opportunity
for swap().

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/efx_channels.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 0a8799a208cf..fe1ad682e3d5 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -797,11 +797,8 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 	old_txq_entries = efx->txq_entries;
 	efx->rxq_entries = rxq_entries;
 	efx->txq_entries = txq_entries;
-	for (i = 0; i < efx->n_channels; i++) {
-		channel = efx->channel[i];
-		efx->channel[i] = other_channel[i];
-		other_channel[i] = channel;
-	}
+	for (i = 0; i < efx->n_channels; i++)
+		swap(efx->channel[i], other_channel[i]);
 
 	/* Restart buffer table allocation */
 	efx->next_buffer_table = next_buffer_table;
@@ -843,11 +840,8 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 	/* Swap back */
 	efx->rxq_entries = old_rxq_entries;
 	efx->txq_entries = old_txq_entries;
-	for (i = 0; i < efx->n_channels; i++) {
-		channel = efx->channel[i];
-		efx->channel[i] = other_channel[i];
-		other_channel[i] = channel;
-	}
+	for (i = 0; i < efx->n_channels; i++)
+		swap(efx->channel[i], other_channel[i]);
 	goto out;
 }
 
-- 
2.35.1



