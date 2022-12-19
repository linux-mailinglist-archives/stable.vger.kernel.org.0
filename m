Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDEA0651307
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbiLST0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbiLST0D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:26:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D96FCD4
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 11:25:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B455B80F4B
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9DBC433D2;
        Mon, 19 Dec 2022 19:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671477955;
        bh=f/+yAd95iiio2Apg+GwBH2JRY4ZFWoFTDUTP3iRCvok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AvVv1Kt19tnNAHSo/BolqH2TmafU78oRcFKUmqPZRu6U2s33AQSGCI8R+YKdfEwWy
         z79UEEkRR5nKmjudL6o0ytImCwuSpSpKoz0Ij966vYQ/CKOySgxWjrJZXrM4A05WxP
         d2cpYvskSIQOPNriWDrllWvQ4rhXE5qaPG6r2vzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Ji-Ze Hong (Peter Hong)" <hpeter@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.0 18/28] USB: serial: f81534: fix division by zero on line-speed change
Date:   Mon, 19 Dec 2022 20:23:05 +0100
Message-Id: <20221219182944.977692157@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
References: <20221219182944.179389009@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 188c9c2e0c7f4ae864113f80c40bafb394062271 upstream.

The driver leaves the line speed unchanged in case a requested speed is
not supported. Make sure to handle the case where the current speed is
B0 (hangup) without dividing by zero when determining the clock source.

Fixes: 3aacac02f385 ("USB: serial: f81534: add high baud rate support")
Cc: stable@vger.kernel.org      # 4.16
Cc: Ji-Ze Hong (Peter Hong) <hpeter@gmail.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/f81534.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/f81534.c
+++ b/drivers/usb/serial/f81534.c
@@ -536,9 +536,6 @@ static int f81534_submit_writer(struct u
 
 static u32 f81534_calc_baud_divisor(u32 baudrate, u32 clockrate)
 {
-	if (!baudrate)
-		return 0;
-
 	/* Round to nearest divisor */
 	return DIV_ROUND_CLOSEST(clockrate, baudrate);
 }
@@ -568,9 +565,14 @@ static int f81534_set_port_config(struct
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


