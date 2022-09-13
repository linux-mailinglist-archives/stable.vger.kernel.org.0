Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 550CF5B7412
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235657AbiIMPOt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235838AbiIMPN7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:13:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF761786F8;
        Tue, 13 Sep 2022 07:33:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EB15614D8;
        Tue, 13 Sep 2022 14:33:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2908AC433C1;
        Tue, 13 Sep 2022 14:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079582;
        bh=tFKe29vBsrtAsOOzBfGmnkFi9oNi877R8GhDW+yP4ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DBiXmeFvs9mWKBEUNxWdz5v8QlX0WkzXNdNveAHfuOxm2MosOERBlgT3whtLX9jMr
         Fa1K2mzP0D0D+zd+bUulAN1GuZDiKAtb6KHn1rHu/cAlN1hjM4TpejHoe2XWrF2V45
         eiEpnZDFzOCb9XO5SryzUr6nXLN6rRHeQGxDCTIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Woithe <jwoithe@just42.net>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 75/79] USB: serial: ch341: fix disabled rx timer on older devices
Date:   Tue, 13 Sep 2022 16:07:33 +0200
Message-Id: <20220913140352.508538258@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
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
[ johan: backport to 5.4 ]
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ch341.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -176,8 +176,12 @@ static int ch341_set_baudrate_lcr(struct
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


