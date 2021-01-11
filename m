Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A722F16FD
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388257AbhAKN7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:59:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:54216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729019AbhAKNGe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:06:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CABA822A84;
        Mon, 11 Jan 2021 13:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370354;
        bh=tKi6PWYV5bNw9BXsAXL+CU+1j68gN25pgAmzVRYlXhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fRbRd9ZZASJDMq/Ve4Np2sutNbyNxSYnopDqsWj5Qounpd4Votb5eiQu9Bqt/E+ce
         sThNUgUPRG2/e87pDCRdWF7NbmxbqgpXsO8Pt9yHY5OHtuv1Hbhg9aaHgWQWo+GyQh
         tMnG3PeD0sqmMDP97He01lwhGKA3tHU/OHD9928g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.14 42/57] usb: gadget: select CONFIG_CRC32
Date:   Mon, 11 Jan 2021 14:02:01 +0100
Message-Id: <20210111130035.755300077@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.715773309@linuxfoundation.org>
References: <20210111130033.715773309@linuxfoundation.org>
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


