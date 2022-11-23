Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3961A6358E8
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbiKWKE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237082AbiKWKD1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:03:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B7C8C0B7
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:55:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B37461B56
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C223C433C1;
        Wed, 23 Nov 2022 09:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197305;
        bh=AaZEUOPEVCNu8SSax7Af4DD7Lyx32nmLqBE7HvFPhhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V++HwGaz7zPpOErrJT4wp5yCYrI4KYwomIIQTRW3lB5v2oHwfyZtitcuE5m39yzaD
         q2ni9mX9eSb/miZmOYwj5nxhFLqd/3yNQUNKcFkeRgjokgLqRWLZ+2DUAusFeMBFgg
         YaJv9ZT4DJAvvH4fz2NTCqFofuiHT3F6Gx4A+O+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wentong Wu <wentong.wu@intel.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.0 256/314] serial: 8250_lpss: Use 16B DMA burst with Elkhart Lake
Date:   Wed, 23 Nov 2022 09:51:41 +0100
Message-Id: <20221123084637.121521703@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

commit 7090abd6ad0610a144523ce4ffcb8560909bf2a8 upstream.

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
---
 drivers/tty/serial/8250/8250_lpss.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/tty/serial/8250/8250_lpss.c
+++ b/drivers/tty/serial/8250/8250_lpss.c
@@ -174,6 +174,8 @@ static int ehl_serial_setup(struct lpss8
 	 */
 	up->dma = dma;
 
+	lpss->dma_maxburst = 16;
+
 	port->set_termios = dw8250_do_set_termios;
 
 	return 0;


