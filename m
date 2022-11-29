Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182A363C24F
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 15:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235666AbiK2OUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 09:20:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbiK2OUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 09:20:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6AA32CC97;
        Tue, 29 Nov 2022 06:17:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78E1A61761;
        Tue, 29 Nov 2022 14:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6A4C433C1;
        Tue, 29 Nov 2022 14:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669731477;
        bh=B+EvtKvHdc8pXnOdn6vOMmv1YKZYwZ3wNOQZC//1McM=;
        h=From:To:Cc:Subject:Date:From;
        b=UEmu3fikl1hZfs3H9AxBDuSK6Md2FGRmFxaruYa7cTRzvyYb+YrcA3sS7ruF6ldcw
         qQ7SQYcLf6FHPL5hzGPE6Rp1F/b1MT+EpZqjJ2wX1G1d+RghDWCKPv3nTU8IA6V1PR
         gEt/ZQ4BnLXnIxciQPgFto7ReuySt8xkqLvZeC1YqPuKrexzKj/zqwbq3TqwyXo0yW
         xiY/k0jrYoWLVy2YmJ3HKygZNNSYP5tIbR+04CHl2S5Gvor8KSJ4cDQL9XatIMz1zF
         iTG4BJRcW24pQWNCIQQEfxh+AAd39/R2EvyOFS3tGa2nPGAMbm5vu+F/0AUj/iByjp
         2a9VPcP5CoGEA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1p01Qs-0003yW-BE; Tue, 29 Nov 2022 15:17:58 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Ji-Ze Hong <hpeter@gmail.com>
Subject: [PATCH] USB: serial: f81232: fix division by zero on line-speed change
Date:   Tue, 29 Nov 2022 15:17:49 +0100
Message-Id: <20221129141749.15270-1-johan@kernel.org>
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

Fixes: 268ddb5e9b62 ("USB: serial: f81232: add high baud rate support")
Cc: stable@vger.kernel.org      # 5.2
Cc: Ji-Ze Hong (Peter Hong) <hpeter@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/f81232.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/f81232.c b/drivers/usb/serial/f81232.c
index 2dd58cd9f0cc..891fb1fe69df 100644
--- a/drivers/usb/serial/f81232.c
+++ b/drivers/usb/serial/f81232.c
@@ -130,9 +130,6 @@ static u8 const clock_table[] = { F81232_CLK_1_846_MHZ, F81232_CLK_14_77_MHZ,
 
 static int calc_baud_divisor(speed_t baudrate, speed_t clockrate)
 {
-	if (!baudrate)
-		return 0;
-
 	return DIV_ROUND_CLOSEST(clockrate, baudrate);
 }
 
@@ -498,9 +495,14 @@ static void f81232_set_baudrate(struct tty_struct *tty,
 	speed_t baud_list[] = { baudrate, old_baudrate, F81232_DEF_BAUDRATE };
 
 	for (i = 0; i < ARRAY_SIZE(baud_list); ++i) {
-		idx = f81232_find_clk(baud_list[i]);
+		baudrate = baud_list[i];
+		if (baudrate == 0) {
+			tty_encode_baud_rate(tty, 0, 0);
+			return;
+		}
+
+		idx = f81232_find_clk(baudrate);
 		if (idx >= 0) {
-			baudrate = baud_list[i];
 			tty_encode_baud_rate(tty, baudrate, baudrate);
 			break;
 		}
-- 
2.37.4

