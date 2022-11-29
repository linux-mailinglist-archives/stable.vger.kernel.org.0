Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1014763C254
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 15:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235694AbiK2OU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 09:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235383AbiK2OUl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 09:20:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7C268694;
        Tue, 29 Nov 2022 06:18:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB1E46176F;
        Tue, 29 Nov 2022 14:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304C1C433C1;
        Tue, 29 Nov 2022 14:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669731511;
        bh=ksilrIsLtIQNg+osJth3VSYezKbX/p5M2jGxv4Rz5jI=;
        h=From:To:Cc:Subject:Date:From;
        b=qtIhwVsxalVdPYtedK9PL8Z/2RUeeu1MHWuY51ZuO07+r9MJfE/xPnDTXCD+uwNTY
         vdh4fl9WRfdeLj0G47t5BIjwvzmV/lz8206QMFl6mriKYXf8H1hyCJS3SsGpaRTVEV
         P28suXZ1DoUMavy4TXzpSHsYKnW8eO9oNcogDO0eI7IUo/TytKzdY7RB9Wf6qXkxi+
         psobVmV510vaDkOt60TKlkNYYoVu/uStMui1Mkl5vABgHO8Q8EU+8LmSje1+mOrqk3
         4f9H53m045TlFIgxMSzpdX4ODNpdZqaH9Y6Gyzq+eGz4scM3L0rFeXA6MypRnNzG2l
         VdebTS6tG4IYA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1p01RP-0003z9-RF; Tue, 29 Nov 2022 15:18:31 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Ji-Ze Hong <hpeter@gmail.com>
Subject: [PATCH] USB: serial: f81534: fix division by zero on line-speed change
Date:   Tue, 29 Nov 2022 15:18:19 +0100
Message-Id: <20221129141819.15310-1-johan@kernel.org>
X-Mailer: git-send-email 2.37.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver leaves the line speed unchanged in case a requested speed is
not supported. Make sure to handle the case where the current speed is
B0 (hangup) without dividing by zero when determining the clock source.

Fixes: 3aacac02f385 ("USB: serial: f81534: add high baud rate support")
Cc: stable@vger.kernel.org      # 4.16
Cc: Ji-Ze Hong (Peter Hong) <hpeter@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/f81534.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/f81534.c b/drivers/usb/serial/f81534.c
index ddfcd72eb0ae..4083ae961be4 100644
--- a/drivers/usb/serial/f81534.c
+++ b/drivers/usb/serial/f81534.c
@@ -536,9 +536,6 @@ static int f81534_submit_writer(struct usb_serial_port *port, gfp_t mem_flags)
 
 static u32 f81534_calc_baud_divisor(u32 baudrate, u32 clockrate)
 {
-	if (!baudrate)
-		return 0;
-
 	/* Round to nearest divisor */
 	return DIV_ROUND_CLOSEST(clockrate, baudrate);
 }
@@ -568,9 +565,14 @@ static int f81534_set_port_config(struct usb_serial_port *port,
 	u32 baud_list[] = {baudrate, old_baudrate, F81534_DEFAULT_BAUD_RATE};
 
 	for (i = 0; i < ARRAY_SIZE(baud_list); ++i) {
-		idx = f81534_find_clk(baud_list[i]);
+		baudrate = baud_list[i];
+		if (baudrate == 0) {
+			tty_encode_baud_rate(tty, 0, 0);
+			return 0;
+		}
+
+		idx = f81534_find_clk(baudrate);
 		if (idx >= 0) {
-			baudrate = baud_list[i];
 			tty_encode_baud_rate(tty, baudrate, baudrate);
 			break;
 		}
-- 
2.37.4

