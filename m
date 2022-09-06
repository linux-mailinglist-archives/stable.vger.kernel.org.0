Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E24F5AEC46
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241568AbiIFOQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241578AbiIFOOy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:14:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B8E89CE2;
        Tue,  6 Sep 2022 06:49:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F310B818DC;
        Tue,  6 Sep 2022 13:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037F1C433B5;
        Tue,  6 Sep 2022 13:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662472155;
        bh=JASWaJC+v+2H2clv/pvy30CI6OB9y7udfCrEM/Tp+bg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sXJu/gTM8M0csvbwkSHD5aV2D1GnM7ZpvkAb2usshGOUSxs5UVgumK9MijJomf/8p
         0JJwu5izG/2S5vlSoJt8Ew79cEVLujUQgjsRAi4Uaq0tgG2R2hjfgv9VMRjG4rYv2b
         R2k+VzaaZVudhBMjjh6lgrNejPjroIuMYBPkH0KKQLU68j3XoN3fQXpsc5yPQOC/OC
         ywmi+rUDrwdKdSovkGe01aGQCAwpyHL2wlp9FjVU7dNOrP9VwtiAP5pT1BJ2ygJrfx
         /MF/VL5cbvnbXgzP/Aw/nNU3ArcANfruumiqM6NihdTuqnW1EoAbZPewK7HfnQkNOw
         Wyaia2A7bslSA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oVYx5-00050Y-Ld; Tue, 06 Sep 2022 15:49:19 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Jonathan Woithe <jwoithe@just42.net>
Subject: [PATCH stable-4.19 4/4] USB: serial: ch341: fix disabled rx timer on older devices
Date:   Tue,  6 Sep 2022 15:49:15 +0200
Message-Id: <20220906134915.19225-5-johan@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220906134915.19225-1-johan@kernel.org>
References: <20220906134915.19225-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 41ca302a697b64a3dab4676e01d0d11bb184737d upstream.

At least one older CH341 appears to have the RX timer enable bit
inverted so that setting it disables the RX timer and prevents the FIFO
from emptying until it is full.

Only set the RX timer enable bit for devices with version newer than
0x27 (even though this probably affects all pre-0x30 devices).

Reported-by: Jonathan Woithe <jwoithe@just42.net>
Tested-by: Jonathan Woithe <jwoithe@just42.net>
Link: https://lore.kernel.org/r/Ys1iPTfiZRWj2gXs@marvin.atrad.com.au
Fixes: 4e46c410e050 ("USB: serial: ch341: reinitialize chip on reconfiguration")
Cc: stable@vger.kernel.org      # 4.10
Signed-off-by: Johan Hovold <johan@kernel.org>
[ johan: backport to 5.4 ]
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/ch341.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 58b5fd95b29f..7eabb1bfafde 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -176,8 +176,12 @@ static int ch341_set_baudrate_lcr(struct usb_device *dev,
 	/*
 	 * CH341A buffers data until a full endpoint-size packet (32 bytes)
 	 * has been received unless bit 7 is set.
+	 *
+	 * At least one device with version 0x27 appears to have this bit
+	 * inverted.
 	 */
-	a |= BIT(7);
+	if (priv->version > 0x27)
+		a |= BIT(7);
 
 	r = ch341_control_out(dev, CH341_REQ_WRITE_REG, 0x1312, a);
 	if (r)
-- 
2.35.1

