Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7682F1653
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730843AbhAKNvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:51:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:56682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730796AbhAKNJV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:09:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9225F22515;
        Mon, 11 Jan 2021 13:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370521;
        bh=tKi6PWYV5bNw9BXsAXL+CU+1j68gN25pgAmzVRYlXhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8skMZK0ZxoTmhpDsao98x+9JEvsCuomNxBLQ+HltYIZgbMZtbvdQ2NPDZBp+W6Pl
         zlFJYh0ORcIfXgvGbpBmBxRu/ordE7+ovNKi2wRp//wZw1tyqAbVK/XiumPaZTn6Dp
         OQeaJ8HBmt/5mTYwYSDKSPCs1xvZon+s+fFi9jJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.19 57/77] usb: gadget: select CONFIG_CRC32
Date:   Mon, 11 Jan 2021 14:02:06 +0100
Message-Id: <20210111130039.157792477@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
References: <20210111130036.414620026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit d7889c2020e08caab0d7e36e947f642d91015bd0 upstream.

Without crc32 support, this driver fails to link:

arm-linux-gnueabi-ld: drivers/usb/gadget/function/f_eem.o: in function `eem_unwrap':
f_eem.c:(.text+0x11cc): undefined reference to `crc32_le'
arm-linux-gnueabi-ld: drivers/usb/gadget/function/f_ncm.o:f_ncm.c:(.text+0x1e40):
more undefined references to `crc32_le' follow

Fixes: 6d3865f9d41f ("usb: gadget: NCM: Add transmit multi-frame.")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210103214224.1996535-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -264,6 +264,7 @@ config USB_CONFIGFS_NCM
 	depends on NET
 	select USB_U_ETHER
 	select USB_F_NCM
+	select CRC32
 	help
 	  NCM is an advanced protocol for Ethernet encapsulation, allows
 	  grouping of several ethernet frames into one USB transfer and
@@ -313,6 +314,7 @@ config USB_CONFIGFS_EEM
 	depends on NET
 	select USB_U_ETHER
 	select USB_F_EEM
+	select CRC32
 	help
 	  CDC EEM is a newer USB standard that is somewhat simpler than CDC ECM
 	  and therefore can be supported by more hardware.  Technically ECM and


