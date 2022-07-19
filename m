Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE3F9579F36
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243420AbiGSNMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243218AbiGSNLC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:11:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5E766AF8;
        Tue, 19 Jul 2022 05:29:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DC3C60DE0;
        Tue, 19 Jul 2022 12:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30FEC341C6;
        Tue, 19 Jul 2022 12:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233746;
        bh=9KEe7eaXtbhE+qjwrjNHYCHBExGftwM90ceOhxQI7wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MWXVXfpwcfek7tygYXCw4aokQxDwWTFp2gI7v6HilPd/+R0/fsXsaVnMJnUE7XBUQ
         bqnL9HYoHyS4HgLjgi0Qt4hM5uzj9zhm7z+nTUbLJYwMrakvs3Jo1PCkjGTUMvSlQl
         /lwjCqowXCIwjgkSNEd/k7LTL7l6QiiJ1c1nGjCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.18 227/231] serial: stm32: Clear prev values before setting RTS delays
Date:   Tue, 19 Jul 2022 13:55:12 +0200
Message-Id: <20220719114732.755608024@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 5c5f44e36217de5ead789ff25da71c31c2331c96 upstream.

The code lacks clearing of previous DEAT/DEDT values. Thus, changing
values on the fly results in garbage delays tending towards the maximum
value as more and more bits are ORed together. (Leaving RS485 mode
would have cleared the old values though).

Fixes: 1bcda09d2910 ("serial: stm32: add support for RS485 hardware control mode")
Cc: stable <stable@kernel.org>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220627150753.34510-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/stm32-usart.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -71,6 +71,8 @@ static void stm32_usart_config_reg_rs485
 	*cr3 |= USART_CR3_DEM;
 	over8 = *cr1 & USART_CR1_OVER8;
 
+	*cr1 &= ~(USART_CR1_DEDT_MASK | USART_CR1_DEAT_MASK);
+
 	if (over8)
 		rs485_deat_dedt = delay_ADE * baud * 8;
 	else


