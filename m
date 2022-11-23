Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC3A63536B
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 09:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236758AbiKWI5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 03:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236831AbiKWI4r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 03:56:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17AEEFFA9F
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 00:56:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8132B81EEF
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 08:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0769FC433D6;
        Wed, 23 Nov 2022 08:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669193803;
        bh=ci3juZchDFkR18VcpznMp8SROQDvsVYfuW5WVjS0hqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXR3MvbOobl83P/0PhSUI+1C9xmKp0k5RkS/1sIxM0Vu8hE4MKY9zRGvtjSTkvjph
         nrYYuFrecz8hc1kTgtcZFMUhVpofuhpvecvXmkHAtpQLTW7oWCpRJsjGqftnRF9OXW
         KMX9pV11Jz/TxiMToaH53W0Z2Q7hyXkGD9uYfD6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4.9 66/76] serial: 8250: Flush DMA Rx on RLSI
Date:   Wed, 23 Nov 2022 09:51:05 +0100
Message-Id: <20221123084548.912664129@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 1980860e0c8299316cddaf0992dd9e1258ec9d88 upstream.

Returning true from handle_rx_dma() without flushing DMA first creates
a data ordering hazard. If DMA Rx has handled any character at the
point when RLSI occurs, the non-DMA path handles any pending characters
jumping them ahead of those characters that are pending under DMA.

Fixes: 75df022b5f89 ("serial: 8250_dma: Fix RX handling")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20221108121952.5497-5-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1802,10 +1802,9 @@ static bool handle_rx_dma(struct uart_82
 		if (!up->dma->rx_running)
 			break;
 		/* fall-through */
+	case UART_IIR_RLSI:
 	case UART_IIR_RX_TIMEOUT:
 		serial8250_rx_dma_flush(up);
-		/* fall-through */
-	case UART_IIR_RLSI:
 		return true;
 	}
 	return up->dma->rx_dma(up);


