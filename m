Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01532548D8D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382948AbiFMOWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382933AbiFMOVV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:21:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DE9A2060;
        Mon, 13 Jun 2022 04:43:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E24DDB80E2C;
        Mon, 13 Jun 2022 11:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F04C34114;
        Mon, 13 Jun 2022 11:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120636;
        bh=vgKo32g688iQ+3jnemU02qj9Di+VAnXSWSB12XS0bkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s60zLo+sBW00tl9LGqgOLTeFk3199TvbnoDVxToq8HQ9zdHzDXhmB70LtD9D31ckx
         nNSFD8uaz/8nHeamtcdk6CfzU7SqmTyDCN0tXpo6zhTXo8glgREIpkRjCBU+sfGaIz
         pbcWOSNEkb1G7R5Yz5RtFUiwYXCWglOwMT39Ohe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tianhao Zhao <tizhao@redhat.com>,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 103/298] sfc: fix wrong tx channel offset with efx_separate_tx_channels
Date:   Mon, 13 Jun 2022 12:09:57 +0200
Message-Id: <20220613094928.075637456@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Íñigo Huguet <ihuguet@redhat.com>

[ Upstream commit c308dfd1b43ef0d4c3e57b741bb3462eb7a7f4a2 ]

tx_channel_offset is calculated in efx_allocate_msix_channels, but it is
also calculated again in efx_set_channels because it was originally done
there, and when efx_allocate_msix_channels was introduced it was
forgotten to be removed from efx_set_channels.

Moreover, the old calculation is wrong when using
efx_separate_tx_channels because now we can have XDP channels after the
TX channels, so n_channels - n_tx_channels doesn't point to the first TX
channel.

Remove the old calculation from efx_set_channels, and add the
initialization of this variable if MSI or legacy interrupts are used,
next to the initialization of the rest of the related variables, where
it was missing.

Fixes: 3990a8fffbda ("sfc: allocate channels for XDP tx queues")
Reported-by: Tianhao Zhao <tizhao@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/efx_channels.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index eec0db76d888..8ab9358a1c3d 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -309,6 +309,7 @@ int efx_probe_interrupts(struct efx_nic *efx)
 		efx->n_channels = 1;
 		efx->n_rx_channels = 1;
 		efx->n_tx_channels = 1;
+		efx->tx_channel_offset = 0;
 		efx->n_xdp_channels = 0;
 		efx->xdp_channel_offset = efx->n_channels;
 		rc = pci_enable_msi(efx->pci_dev);
@@ -329,6 +330,7 @@ int efx_probe_interrupts(struct efx_nic *efx)
 		efx->n_channels = 1 + (efx_separate_tx_channels ? 1 : 0);
 		efx->n_rx_channels = 1;
 		efx->n_tx_channels = 1;
+		efx->tx_channel_offset = 1;
 		efx->n_xdp_channels = 0;
 		efx->xdp_channel_offset = efx->n_channels;
 		efx->legacy_irq = efx->pci_dev->irq;
@@ -957,10 +959,6 @@ int efx_set_channels(struct efx_nic *efx)
 	struct efx_channel *channel;
 	int rc;
 
-	efx->tx_channel_offset =
-		efx_separate_tx_channels ?
-		efx->n_channels - efx->n_tx_channels : 0;
-
 	if (efx->xdp_tx_queue_count) {
 		EFX_WARN_ON_PARANOID(efx->xdp_tx_queues);
 
-- 
2.35.1



