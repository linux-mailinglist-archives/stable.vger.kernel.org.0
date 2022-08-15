Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13B7594C71
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242868AbiHPArG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243202AbiHPApF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:45:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E340AE222;
        Mon, 15 Aug 2022 13:41:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53ABAB80EA8;
        Mon, 15 Aug 2022 20:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB70C433D6;
        Mon, 15 Aug 2022 20:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596114;
        bh=p39y+PYbrUySdsjZRfs7nDjzVMLSTQa5YZkb/iUYSn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S5zP4Qx3UPF0JhD18UGqm93meJmUZs/Sf2DamSPxdpOvQR4APh4f1nDZfXQRKmpMh
         iCzTvxBXdgyDm3TAAo0N456JgQinOIHqzCHLwEH8tSNCsi3VVW/3gLwx4iARkDMIQs
         in0hFL4BsipUmHGLeS0JxRbvqU5OdZCNo5EDu5QE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0942/1157] serial: 8250_fsl: Dont report FE, PE and OE twice
Date:   Mon, 15 Aug 2022 20:04:58 +0200
Message-Id: <20220815180517.215471644@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 9d3aaceb73acadf134596a2f8db9c451c1332d3d ]

Some Freescale 8250 implementations have the problem that a single long
break results in one irq per character frame time. The code in
fsl8250_handle_irq() that is supposed to handle that uses the BI bit in
lsr_saved_flags to detect such a situation and then skip the second
received character. However it also stores other error bits and so after
a single frame error the character received in the next irq handling is
passed to the upper layer with a frame error, too.

So after a spike on the data line (which is correctly recognized as a
frame error) the following valid character is thrown away, because the
driver reports a frame error for that one, too.

To weaken this problem restrict saving LSR to only the BI bit.

Note however that the handling is still broken:

 - lsr_saved_flags is updated using orig_lsr which is the LSR content
   for the first received char, but there might be more in the FIFO, so
   a character is thrown away that is received later and not necessarily
   the one following the break.
 - The doubled break might be the 2nd and 3rd char in the FIFO, so the
   workaround doesn't catch these, because serial8250_rx_chars() doesn't
   handle the workaround.
 - lsr_saved_flags might have set UART_LSR_BI at the entry of
   fsl8250_handle_irq() which doesn't originate from
   fsl8250_handle_irq()'s "up->lsr_saved_flags |= orig_lsr &
   UART_LSR_BI;" but from e.g. from serial8250_tx_empty().
 - For a long or a short break this isn't about two characters, but more
   or only a single one.

Fixes: 9deaa53ac7fa ("serial: add irq handler for Freescale 16550 errata.")
Acked-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20220704085119.55900-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_fsl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_fsl.c b/drivers/tty/serial/8250/8250_fsl.c
index 9c01c531349d..71ce43685797 100644
--- a/drivers/tty/serial/8250/8250_fsl.c
+++ b/drivers/tty/serial/8250/8250_fsl.c
@@ -77,7 +77,7 @@ int fsl8250_handle_irq(struct uart_port *port)
 	if ((lsr & UART_LSR_THRE) && (up->ier & UART_IER_THRI))
 		serial8250_tx_chars(up);
 
-	up->lsr_saved_flags = orig_lsr;
+	up->lsr_saved_flags |= orig_lsr & UART_LSR_BI;
 
 	uart_unlock_and_check_sysrq_irqrestore(&up->port, flags);
 
-- 
2.35.1



