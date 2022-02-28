Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDAA14C7307
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237070AbiB1RbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235039AbiB1RaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:30:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14251541B3;
        Mon, 28 Feb 2022 09:28:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D9146135F;
        Mon, 28 Feb 2022 17:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA12C340E7;
        Mon, 28 Feb 2022 17:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069302;
        bh=CRd4rCeCLKeHll0cDyYiFg6oShG+mdo264UAokc0Yw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LcwnO99yogfhHtUX6JDfqvZpoYbM5Y5hY7hrr8CikN0rb4y62Q7UynbSLXWb4Ng4d
         NXkoextAUGfc/+mgkyMrk+KYEUrlUHO6wqvkH5jh5xJd1scrRaYqOV5EUMAN12ehew
         DvGydP+Oe9kVrmEZyrsI9AFBY1VU0DgNPhrJ5a6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 07/31] serial: 8250: of: Fix mapped region size when using reg-offset property
Date:   Mon, 28 Feb 2022 18:24:03 +0100
Message-Id: <20220228172200.579201488@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172159.515152296@linuxfoundation.org>
References: <20220228172159.515152296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

commit d06b1cf28297e27127d3da54753a3a01a2fa2f28 upstream.

8250_of supports a reg-offset property which is intended to handle
cases where the device registers start at an offset inside the region
of memory allocated to the device. The Xilinx 16550 UART, for which this
support was initially added, requires this. However, the code did not
adjust the overall size of the mapped region accordingly, causing the
driver to request an area of memory past the end of the device's
allocation. For example, if the UART was allocated an address of
0xb0130000, size of 0x10000 and reg-offset of 0x1000 in the device
tree, the region of memory reserved was b0131000-b0140fff, which caused
the driver for the region starting at b0140000 to fail to probe.

Fix this by subtracting reg-offset from the mapped region size.

Fixes: b912b5e2cfb3 ([POWERPC] Xilinx: of_serial support for Xilinx uart 16550.)
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Link: https://lore.kernel.org/r/20220112194214.881844-1-robert.hancock@calian.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_of.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_of.c
+++ b/drivers/tty/serial/8250/8250_of.c
@@ -102,8 +102,17 @@ static int of_platform_serial_setup(stru
 	port->mapsize = resource_size(&resource);
 
 	/* Check for shifted address mapping */
-	if (of_property_read_u32(np, "reg-offset", &prop) == 0)
+	if (of_property_read_u32(np, "reg-offset", &prop) == 0) {
+		if (prop >= port->mapsize) {
+			dev_warn(&ofdev->dev, "reg-offset %u exceeds region size %pa\n",
+				 prop, &port->mapsize);
+			ret = -EINVAL;
+			goto err_unprepare;
+		}
+
 		port->mapbase += prop;
+		port->mapsize -= prop;
+	}
 
 	/* Compatibility with the deprecated pxa driver and 8250_pxa drivers. */
 	if (of_device_is_compatible(np, "mrvl,mmp-uart"))


