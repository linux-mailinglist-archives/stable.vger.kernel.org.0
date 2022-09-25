Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4D95E9179
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 09:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiIYHix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 03:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiIYHiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 03:38:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1ED93BC4E
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 00:38:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E04CB80B86
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 07:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A14BC433D6;
        Sun, 25 Sep 2022 07:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664091529;
        bh=rb1dXoVB86dxO6kV7ss0L21MErITWja8AKONfjPl+U8=;
        h=Subject:To:Cc:From:Date:From;
        b=vXFnY/taMfHTyjhYcDpXueXKnETySS2h+dRKrHVkcT4EEW2ahfaefC+/u0KfYti8N
         DXVEliCQiRV9hDKr4SfFinpBz+nC/cU7B/mMXmBOzmu3x5b3ZPRdgiYZaQEOzmtiEL
         +oPw5VIiWGsD+23daHHaf9EKEW/1ErCdMMzwMC+g=
Subject: FAILED: patch "[PATCH] serial: sifive: enable clocks for UART when probed" failed to apply to 5.10-stable tree
To:     olof@lixom.net, emil.renner.berthing@canonical.com,
        gregkh@linuxfoundation.org, palmer@dabbelt.com,
        palmer@rivosinc.com, paul.walmsley@sifive.com, stable@kernel.org,
        u.kleine-koenig@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 25 Sep 2022 09:38:46 +0200
Message-ID: <16640915266294@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

643792048ee8 ("serial: sifive: enable clocks for UART when probed")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 643792048ee84b199052e9c8f89253649ca78922 Mon Sep 17 00:00:00 2001
From: Olof Johansson <olof@lixom.net>
Date: Tue, 20 Sep 2022 09:00:18 -0700
Subject: [PATCH] serial: sifive: enable clocks for UART when probed
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When the PWM driver was changed to disable clocks if no PWMs are enabled,
it ended up also disabling the shared parent with the UART, since the
UART doesn't do any clock enablement on its own.

To avoid these surprises, switch to clk_get_enabled().

Fixes: ace41d7564e655 ("pwm: sifive: Ensure the clk is enabled exactly once per running PWM")
Cc: stable <stable@kernel.org>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Link: https://lore.kernel.org/r/20220920160017.7315-1-olof@lixom.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/sifive.c b/drivers/tty/serial/sifive.c
index 5c3a07546a58..4b1d4fe8458e 100644
--- a/drivers/tty/serial/sifive.c
+++ b/drivers/tty/serial/sifive.c
@@ -945,7 +945,7 @@ static int sifive_serial_probe(struct platform_device *pdev)
 		return PTR_ERR(base);
 	}
 
-	clk = devm_clk_get(&pdev->dev, NULL);
+	clk = devm_clk_get_enabled(&pdev->dev, NULL);
 	if (IS_ERR(clk)) {
 		dev_err(&pdev->dev, "unable to find controller clock\n");
 		return PTR_ERR(clk);

