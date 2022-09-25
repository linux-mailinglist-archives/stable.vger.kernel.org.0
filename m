Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A60F5E917F
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 09:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiIYHj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 03:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiIYHjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 03:39:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E463BC4E
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 00:39:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2A75B80E96
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 07:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF92C433C1;
        Sun, 25 Sep 2022 07:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664091562;
        bh=M+yXNU2NRScjqQAkEBJsZHuacTp+oPa5sAslSdz5bJs=;
        h=Subject:To:Cc:From:Date:From;
        b=lXXThEnQvDKAan+7PUmB4MdoBp15dcXf3E9wys5+irk9jBu0v9TvXVB7pnKL0SlOX
         uiEM8ClN9gYlvquplnsUZID1W8q9HMuLCc4gW3iFyOU/kQEuKro/xPHepb0MtYDGb8
         To+a0DEVyVwV9j7EXQofEwLWjn39b02R5u1UjO6I=
Subject: FAILED: patch "[PATCH] serial: sifive: enable clocks for UART when probed" failed to apply to 5.19-stable tree
To:     olof@lixom.net, emil.renner.berthing@canonical.com,
        gregkh@linuxfoundation.org, palmer@dabbelt.com,
        palmer@rivosinc.com, paul.walmsley@sifive.com, stable@kernel.org,
        u.kleine-koenig@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 25 Sep 2022 09:39:19 +0200
Message-ID: <1664091559151151@kroah.com>
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


The patch below does not apply to the 5.19-stable tree.
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

