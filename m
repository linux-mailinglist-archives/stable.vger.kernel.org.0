Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68DB059D43F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241878AbiHWIR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242353AbiHWIOT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:14:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154256CD05;
        Tue, 23 Aug 2022 01:09:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59638612A0;
        Tue, 23 Aug 2022 08:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FD4C43151;
        Tue, 23 Aug 2022 08:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242176;
        bh=fzEwDqQnyvof+zgJDXrldKEzkZj1Amf9g0JJlC0VsSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gof6QOYNa7JsQBRExzWTywuiE+1IiSAFVVyQFQt4u+NY0D97ltyAvUFPV8HkBHCSa
         M5HNAm1FCgkzlJbvwuCg+y0l+M9L28Z1tMRHuGIzt+UmfbaMM8NPaW32SY75Enfe6W
         JHl6uKGhYLuYZK101WC67l2U6WEV5KTW5XUyKyPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k@lists.linux-m68k.org, uclinux-dev@uclinux.org,
        Angelo Dureghello <angelo@kernel-space.org>
Subject: [PATCH 5.19 072/365] m68k: coldfire/device.c: protect FLEXCAN blocks
Date:   Tue, 23 Aug 2022 09:59:33 +0200
Message-Id: <20220823080121.207289114@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit 3c2bf173501652fced1d058834e9c983d295b126 upstream.

When CAN_FLEXCAN=y and M5441x is not set/enabled, there are build
errors in coldfire/device.c:

../arch/m68k/coldfire/device.c:595:26: error: 'MCFFLEXCAN_BASE0' undeclared here (not in a function); did you mean 'MCFDMA_BASE0'?
  595 |                 .start = MCFFLEXCAN_BASE0,
../arch/m68k/coldfire/device.c:596:43: error: 'MCFFLEXCAN_SIZE' undeclared here (not in a function)
  596 |                 .end = MCFFLEXCAN_BASE0 + MCFFLEXCAN_SIZE,
../arch/m68k/coldfire/device.c:600:26: error: 'MCF_IRQ_IFL0' undeclared here (not in a function); did you mean 'MCF_IRQ_I2C0'?
  600 |                 .start = MCF_IRQ_IFL0,
../arch/m68k/coldfire/device.c:605:26: error: 'MCF_IRQ_BOFF0' undeclared here (not in a function); did you mean 'MCF_IRQ_I2C0'?
  605 |                 .start = MCF_IRQ_BOFF0,
../arch/m68k/coldfire/device.c:610:26: error: 'MCF_IRQ_ERR0' undeclared here (not in a function); did you mean 'MCF_IRQ_I2C0'?
  610 |                 .start = MCF_IRQ_ERR0,

Protect the FLEXCAN code blocks by checking if MCFFLEXCAN_SIZE
is defined.

Fixes: 35a9f9363a89 ("m68k: m5441x: add flexcan support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
Cc: uclinux-dev@uclinux.org
Cc: Angelo Dureghello <angelo@kernel-space.org>
Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/m68k/coldfire/device.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/m68k/coldfire/device.c
+++ b/arch/m68k/coldfire/device.c
@@ -581,7 +581,7 @@ static struct platform_device mcf_esdhc
 };
 #endif /* MCFSDHC_BASE */
 
-#if IS_ENABLED(CONFIG_CAN_FLEXCAN)
+#ifdef MCFFLEXCAN_SIZE
 
 #include <linux/can/platform/flexcan.h>
 
@@ -620,7 +620,7 @@ static struct platform_device mcf_flexca
 	.resource = mcf5441x_flexcan0_resource,
 	.dev.platform_data = &mcf5441x_flexcan_info,
 };
-#endif /* IS_ENABLED(CONFIG_CAN_FLEXCAN) */
+#endif /* MCFFLEXCAN_SIZE */
 
 static struct platform_device *mcf_devices[] __initdata = {
 	&mcf_uart,
@@ -657,7 +657,7 @@ static struct platform_device *mcf_devic
 #ifdef MCFSDHC_BASE
 	&mcf_esdhc,
 #endif
-#if IS_ENABLED(CONFIG_CAN_FLEXCAN)
+#ifdef MCFFLEXCAN_SIZE
 	&mcf_flexcan0,
 #endif
 };


