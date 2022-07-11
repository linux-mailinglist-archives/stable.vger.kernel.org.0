Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E149E56FB0F
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbiGKJZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbiGKJYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:24:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B9E286F7;
        Mon, 11 Jul 2022 02:14:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92F6A6115B;
        Mon, 11 Jul 2022 09:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B407C34115;
        Mon, 11 Jul 2022 09:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530873;
        bh=sp7b6ESRpulFFd9mvznL9RA2PFRIIr/6Tdch+jz+hkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVSpHnx+kKupwjnSL2bXMEwHF8ANgOnOiUobf8OhUrKrs9GXlK3mF76Z0oYQHsHxO
         Iuy5eFx1kX8Y9KCbCFkV3gV40lEOmhtrR+pwKnMAsr7k/T5Cw307kJL5aL6YmS2V34
         pH107yctn4tIDrKOxDHJcqxOAzKkwUzIBzXRrwEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.18 015/112] can: mcp251xfd: mcp251xfd_stop(): add missing hrtimer_cancel()
Date:   Mon, 11 Jul 2022 11:06:15 +0200
Message-Id: <20220711090549.991364775@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit d5a972f561a003e302e4267340c57e8fbd096fa4 upstream.

In commit 169d00a25658 ("can: mcp251xfd: add TX IRQ coalescing
support") software based TX coalescing was added to the driver. The
key idea is to keep the TX complete IRQ disabled for some time after
processing it and re-enable later by a hrtimer. When bringing the
interface down, this timer has to be stopped.

Add the missing hrtimer_cancel() of the tx_irq_time hrtimer to
mcp251xfd_stop().

Link: https://lore.kernel.org/all/20220620143942.891811-1-mkl@pengutronix.de
Fixes: 169d00a25658 ("can: mcp251xfd: add TX IRQ coalescing support")
Cc: stable@vger.kernel.org # v5.18
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -1641,6 +1641,7 @@ static int mcp251xfd_stop(struct net_dev
 	netif_stop_queue(ndev);
 	set_bit(MCP251XFD_FLAGS_DOWN, priv->flags);
 	hrtimer_cancel(&priv->rx_irq_timer);
+	hrtimer_cancel(&priv->tx_irq_timer);
 	mcp251xfd_chip_interrupts_disable(priv);
 	free_irq(ndev->irq, priv);
 	can_rx_offload_disable(&priv->offload);


