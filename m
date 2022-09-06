Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8C5F5AEA39
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238451AbiIFNnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233436AbiIFNlU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:41:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDF77CB77;
        Tue,  6 Sep 2022 06:37:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F353F61539;
        Tue,  6 Sep 2022 13:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A123C433C1;
        Tue,  6 Sep 2022 13:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471354;
        bh=m9DIWf9ufwNNTQBYkogqjdGKTwxaeyTIk20g2hFR/Us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M7jaxSdq5vdXYBWG05j2rae0QjHvm4gNwIEw0S5RH1wFrWPDtIJ8fj2s99EY45Uj2
         pCByG9Jm1M75VCsX+uf+1Bt73rg//mYb55yiHFasqwRLTC6uJzfw4t0asS1Rb24exX
         HPUIPhcQvXr/CTbYAbGCg9Gi1VV5BCsUj1VITEEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Woithe <jwoithe@just42.net>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 80/80] USB: serial: ch341: fix disabled rx timer on older devices
Date:   Tue,  6 Sep 2022 15:31:17 +0200
Message-Id: <20220906132820.452337382@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Johan Hovold <johan@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ch341.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -259,8 +259,12 @@ static int ch341_set_baudrate_lcr(struct
 	/*
 	 * CH341A buffers data until a full endpoint-size packet (32 bytes)
 	 * has been received unless bit 7 is set.
+	 *
+	 * At least one device with version 0x27 appears to have this bit
+	 * inverted.
 	 */
-	val |= BIT(7);
+	if (priv->version > 0x27)
+		val |= BIT(7);
 
 	r = ch341_control_out(dev, CH341_REQ_WRITE_REG,
 			      CH341_REG_DIVISOR << 8 | CH341_REG_PRESCALER,


