Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1BD66213A1
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234466AbiKHNwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234715AbiKHNwP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:52:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25516238B
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:52:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C83BB81AF7
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F9AC433C1;
        Tue,  8 Nov 2022 13:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915521;
        bh=HQ+2xMOcb8CWzm380tr5PiVGxKGaibhyYQ8mpCd/WhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFNe/4e6/DfB1YTvYruYRnYo9BNsSW6iC1oeaAhZT5CWWvfE4pBYIMlBUOfMoFbQ/
         4Ed4Rbs/27yCSaNv2c/PFgDUCT+EdSZYa33M2LmX0pOoN7w51CgLMULoX7+CFwuB2Q
         1wAG2oFY3jmd6APJ/7LZihZDehwFUf3oUopKs9zM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daniel Golle <daniel@makrotopia.org>,
        =?UTF-8?q?Ilpo=20J=C3=83=E2=82=ACrvinen?= 
        <ilpo.jarvinen@linux.intel.com>, Lukas Wunner <lukas@wunner.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/118] serial: ar933x: Deassert Transmit Enable on ->rs485_config()
Date:   Tue,  8 Nov 2022 14:38:00 +0100
Message-Id: <20221108133340.820386321@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
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

From: Lukas Wunner <lukas@wunner.de>

commit 3a939433ddc1bab98be028903aaa286e5e7461d7 upstream.

The ar933x_uart driver neglects to deassert Transmit Enable when
->rs485_config() is invoked.  Fix it.

Fixes: 9be1064fe524 ("serial: ar933x_uart: add RS485 support")
Cc: stable@vger.kernel.org # v5.7+
Cc: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Ilpo JÃ€rvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/ar933x_uart.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/tty/serial/ar933x_uart.c
+++ b/drivers/tty/serial/ar933x_uart.c
@@ -593,6 +593,11 @@ static int ar933x_config_rs485(struct ua
 		dev_err(port->dev, "RS485 needs rts-gpio\n");
 		return 1;
 	}
+
+	if (rs485conf->flags & SER_RS485_ENABLED)
+		gpiod_set_value(up->rts_gpiod,
+			!!(rs485conf->flags & SER_RS485_RTS_AFTER_SEND));
+
 	port->rs485 = *rs485conf;
 	return 0;
 }


