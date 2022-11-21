Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A01632135
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 12:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiKULtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 06:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiKULti (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 06:49:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5842201A5
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 03:49:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D12C961057
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 11:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB04C433D6;
        Mon, 21 Nov 2022 11:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669031375;
        bh=XMTI3B0eGZbYz+C02VXbd+siYgkRjC5T9HJcZeeS4PM=;
        h=Subject:To:Cc:From:Date:From;
        b=dfnHzLuMLITRVQoOGLvV2+gCOgH1fAaSqFozep1vROq5fD/NiwBbqMA6761nK7F+u
         wKBg51lGHWBPwIx7X4qZESTQiVzJF+cbefCfCq3GCq/kfWSZWZyvRzeTqfc4PapBWF
         9Hpy9lY2Lyzbn2dpayUExSk4XLhBMElbOUz9v11s=
Subject: FAILED: patch "[PATCH] serial: 8250_lpss: Use 16B DMA burst with Elkhart Lake" failed to apply to 5.15-stable tree
To:     ilpo.jarvinen@linux.intel.com, andriy.shevchenko@linux.intel.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        wentong.wu@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Nov 2022 12:49:32 +0100
Message-ID: <166903137218779@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

7090abd6ad06 ("serial: 8250_lpss: Use 16B DMA burst with Elkhart Lake")
2cb3315107b5 ("serial: 8250_lpss: Enable PSE UART Auto Flow Control")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7090abd6ad0610a144523ce4ffcb8560909bf2a8 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Tue, 8 Nov 2022 14:19:51 +0200
Subject: [PATCH] serial: 8250_lpss: Use 16B DMA burst with Elkhart Lake
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Configure DMA to use 16B burst size with Elkhart Lake. This makes the
bus use more efficient and works around an issue which occurs with the
previously used 1B.

The fix was initially developed by Srikanth Thokala and Aman Kumar.
This together with the previous config change is the cleaned up version
of the original fix.

Fixes: 0a9410b981e9 ("serial: 8250_lpss: Enable DMA on Intel Elkhart Lake")
Cc: <stable@vger.kernel.org> # serial: 8250_lpss: Configure DMA also w/o DMA filter
Reported-by: Wentong Wu <wentong.wu@intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20221108121952.5497-4-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/8250/8250_lpss.c b/drivers/tty/serial/8250/8250_lpss.c
index 7d9cddbfef40..0e43bdfb7459 100644
--- a/drivers/tty/serial/8250/8250_lpss.c
+++ b/drivers/tty/serial/8250/8250_lpss.c
@@ -174,6 +174,8 @@ static int ehl_serial_setup(struct lpss8250 *lpss, struct uart_port *port)
 	 */
 	up->dma = dma;
 
+	lpss->dma_maxburst = 16;
+
 	port->set_termios = dw8250_do_set_termios;
 
 	return 0;

