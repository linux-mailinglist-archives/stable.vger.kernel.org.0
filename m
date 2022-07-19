Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 897FB579A97
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239191AbiGSMPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239006AbiGSMNn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:13:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF6915A03;
        Tue, 19 Jul 2022 05:04:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FA29B81B2C;
        Tue, 19 Jul 2022 12:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D53C341C6;
        Tue, 19 Jul 2022 12:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232262;
        bh=zjM5uGp2WvyhbyguXiRP4U+eFsN5c6pbeoztRa9fAj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XvI1b1Z+Ct9dwZJnUKYTRU8htsw7B6TiuvJV69l5zs2nubMLytmTsrX1tdrvhRa+H
         YLLXYKC3eHYaobMzyldJCxkhB9OHWGu121PQAixq/V/s4DJqznnoq6Uld32vTm7bIS
         QwRZ1ToC/5kteScPVsFDY+NMEmi49EY1bOzDaf5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.4 69/71] serial: stm32: Clear prev values before setting RTS delays
Date:   Tue, 19 Jul 2022 13:54:32 +0200
Message-Id: <20220719114559.346970211@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114552.477018590@linuxfoundation.org>
References: <20220719114552.477018590@linuxfoundation.org>
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
@@ -73,6 +73,8 @@ static void stm32_config_reg_rs485(u32 *
 	*cr3 |= USART_CR3_DEM;
 	over8 = *cr1 & USART_CR1_OVER8;
 
+	*cr1 &= ~(USART_CR1_DEDT_MASK | USART_CR1_DEAT_MASK);
+
 	if (over8)
 		rs485_deat_dedt = delay_ADE * baud * 8;
 	else


