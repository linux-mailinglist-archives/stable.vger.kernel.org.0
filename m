Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1DB55A78AA
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 10:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbiHaIPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 04:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbiHaIPk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 04:15:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF544F69B;
        Wed, 31 Aug 2022 01:15:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A79DB81FA0;
        Wed, 31 Aug 2022 08:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F5BC433D6;
        Wed, 31 Aug 2022 08:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661933735;
        bh=eSm/Gxj0y/7tZ+reMqFOc9ngJfIpQ318HJ976ReDtSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijr5kKeYGJiF+80G6s1jxzwVPFiyqgMFN8x7i3ch1TO+jsOprvCgF8ulnU8vD/Tk8
         qMNtBMKEH0YVssbuTGHdsEZoGyS5hGhBwEbQug2w5RiNtoL+xqaQ8EzssWKYKIgvtg
         UoqLxDgfHkpM+0BfeHjvvCueLiljKOeAY0dDd36zr9w2kyKQd+91tOIV8CwApWpXxb
         +Kck1xNqcYqHVwbTcX25WapHwO0dK0dhEFNwfFpIqaMs/0zK/lvI55fsSV3eTIc+2l
         9YgkrbyVoebSQUN51a9qhIS0vR44lu6BWmSiwEmYuM6pk4fuxVNH+SxjTV7HrXUTcw
         mCgH+oMOZGpDg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oTIsn-0007xC-QF; Wed, 31 Aug 2022 10:15:33 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>,
        Jonathan Woithe <jwoithe@just42.net>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 2/2] USB: serial: ch341: fix disabled rx timer on older devices
Date:   Wed, 31 Aug 2022 10:15:25 +0200
Message-Id: <20220831081525.30557-3-johan@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220831081525.30557-1-johan@kernel.org>
References: <20220831081525.30557-1-johan@kernel.org>
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

At least one older CH341 appears to have the RX timer enable bit
inverted so that setting it disables the RX timer and prevents the FIFO
from emptying until it is full.

Only set the RX timer enable bit for devices with version newer than
0x27 (even though this probably affects all pre-0x30 devices).

Reported-by: Jonathan Woithe <jwoithe@just42.net>
Link: https://lore.kernel.org/r/Ys1iPTfiZRWj2gXs@marvin.atrad.com.au
Fixes: 4e46c410e050 ("USB: serial: ch341: reinitialize chip on reconfiguration")
Cc: stable@vger.kernel.org      # 4.10
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/ch341.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 2bcce172355b..af01a462cc43 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -253,8 +253,12 @@ static int ch341_set_baudrate_lcr(struct usb_device *dev,
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
-- 
2.35.1

