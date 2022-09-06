Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A585AEA18
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbiIFNl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233232AbiIFNkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:40:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F7A7C51A;
        Tue,  6 Sep 2022 06:37:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 01A8BCE1780;
        Tue,  6 Sep 2022 13:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEED1C433C1;
        Tue,  6 Sep 2022 13:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471351;
        bh=2kANwVg4Rl6NnGBq0LzTxlY7t3U55WnFxJwykv2/8uQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VH2sCZmfrhMbPNBS7GpCupuP0bHBDnYPGC7wOI4SjhoKlOtkjXwVXpnI17YvJ1i0L
         lvcMXjQsFQlz1gEPsQ81dy5RsyccmdxNUEO19NxDqwRYPmj/VzFmG4XWkIWEcTracf
         sKZ6g7H0lr2P4jly64wP26DnWtbyvoZnU7fSzp1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Woithe <jwoithe@just42.net>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 79/80] USB: serial: ch341: fix lost character on LCR updates
Date:   Tue,  6 Sep 2022 15:31:16 +0200
Message-Id: <20220906132820.408184247@linuxfoundation.org>
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

commit 8e83622ae7ca481c76c8fd9579877f6abae64ca2 upstream.

Disable LCR updates for pre-0x30 devices which use a different (unknown)
protocol for line control and where the current register write causes
the next received character to be lost.

Note that updating LCR using the INIT command has no effect on these
devices either.

Reported-by: Jonathan Woithe <jwoithe@just42.net>
Tested-by: Jonathan Woithe <jwoithe@just42.net>
Link: https://lore.kernel.org/r/Ys1iPTfiZRWj2gXs@marvin.atrad.com.au
Fixes: 4e46c410e050 ("USB: serial: ch341: reinitialize chip on reconfiguration")
Fixes: 55fa15b5987d ("USB: serial: ch341: fix baud rate and line-control handling")
Cc: stable@vger.kernel.org      # 4.10
Signed-off-by: Johan Hovold <johan@kernel.org>
[ johan: adjust context to 5.15 ]
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ch341.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -97,7 +97,10 @@ struct ch341_private {
 	u8 mcr;
 	u8 msr;
 	u8 lcr;
+
 	unsigned long quirks;
+	u8 version;
+
 	unsigned long break_end;
 };
 
@@ -271,6 +274,9 @@ static int ch341_set_baudrate_lcr(struct
 	 * (stop bits, parity and word length). Version 0x30 and above use
 	 * CH341_REG_LCR only and CH341_REG_LCR2 is always set to zero.
 	 */
+	if (priv->version < 0x30)
+		return 0;
+
 	r = ch341_control_out(dev, CH341_REQ_WRITE_REG,
 			      CH341_REG_LCR2 << 8 | CH341_REG_LCR, lcr);
 	if (r)
@@ -323,7 +329,9 @@ static int ch341_configure(struct usb_de
 	r = ch341_control_in(dev, CH341_REQ_READ_VERSION, 0, 0, buffer, size);
 	if (r < 0)
 		goto out;
-	dev_dbg(&dev->dev, "Chip version: 0x%02x\n", buffer[0]);
+
+	priv->version = buffer[0];
+	dev_dbg(&dev->dev, "Chip version: 0x%02x\n", priv->version);
 
 	r = ch341_control_out(dev, CH341_REQ_SERIAL_INIT, 0, 0);
 	if (r < 0)


