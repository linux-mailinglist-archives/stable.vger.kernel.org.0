Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7C95EA49E
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238661AbiIZLsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238770AbiIZLrU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:47:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB2D74DF2;
        Mon, 26 Sep 2022 03:47:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8A7A60B6A;
        Mon, 26 Sep 2022 10:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF50FC433B5;
        Mon, 26 Sep 2022 10:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189260;
        bh=GHqo4WW2TGo/HZhXm8DCsaihIeiuLfz8NFLTCRhWsjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=11FlMc+saWsTIMbqEHjTnmlkY4CC7xLEcrb1MnVbc5HEqIr/tv6v9bgoxoUGb9fPW
         gFAI9MGMH3FaAO4HF+m5I1MXm0joDphMQ/bmYf17IwD0nvYGBFFBZjxWGSDihpIr8W
         vQkyVcXLWGgtJMX5vExKq3M607MXXfxyL3pDeDck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tianhao Zhao <tizhao@redhat.com>,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 126/207] sfc/siena: fix TX channel offset when using legacy interrupts
Date:   Mon, 26 Sep 2022 12:11:55 +0200
Message-Id: <20220926100812.200580187@linuxfoundation.org>
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

[ Upstream commit 974bb793aded499491246f6f9826e26c2b127320 ]

As in previous commit for sfc, fix TX channels offset when
efx_siena_separate_tx_channels is false (the default)

Fixes: 25bde571b4a8 ("sfc/siena: fix wrong tx channel offset with efx_separate_tx_channels")
Reported-by: Tianhao Zhao <tizhao@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
Link: https://lore.kernel.org/r/20220915141653.15504-1-ihuguet@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/siena/efx_channels.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/siena/efx_channels.c b/drivers/net/ethernet/sfc/siena/efx_channels.c
index 017212a40df3..f54ebd007286 100644
--- a/drivers/net/ethernet/sfc/siena/efx_channels.c
+++ b/drivers/net/ethernet/sfc/siena/efx_channels.c
@@ -320,7 +320,7 @@ int efx_siena_probe_interrupts(struct efx_nic *efx)
 		efx->n_channels = 1 + (efx_siena_separate_tx_channels ? 1 : 0);
 		efx->n_rx_channels = 1;
 		efx->n_tx_channels = 1;
-		efx->tx_channel_offset = 1;
+		efx->tx_channel_offset = efx_siena_separate_tx_channels ? 1 : 0;
 		efx->n_xdp_channels = 0;
 		efx->xdp_channel_offset = efx->n_channels;
 		efx->legacy_irq = efx->pci_dev->irq;
-- 
2.35.1



