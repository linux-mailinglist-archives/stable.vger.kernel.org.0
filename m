Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6A0440D6A
	for <lists+stable@lfdr.de>; Sun, 31 Oct 2021 08:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhJaHPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Oct 2021 03:15:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229697AbhJaHPx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 31 Oct 2021 03:15:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6B3B60E9B;
        Sun, 31 Oct 2021 07:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635664402;
        bh=3TPOMb/o+yLnu3VQ2t/0HJ81RT/NYZ48e2KTPlkYd6k=;
        h=Subject:To:From:Date:From;
        b=O9gtu0anWVbusehgMdSU02B06Qd+zsHKdXWwcRKpvtaE5zUBiPc0WbvMsghm+lHDV
         PMD6BZLvL0pOVtrFJblr/Awx/qjmqnPMa3hG2AGVExhl3J+qQl7tU4cWbogNUweFmI
         +7JUbc2kN/UyPgceFsaIjgIb+Lju57WBVkWWA+eY=
Subject: patch "usb: gadget: Mark USB_FSL_QE broken on 64-bit" added to usb-next
To:     geert@linux-m68k.org, gregkh@linuxfoundation.org,
        leoyang.li@nxp.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 31 Oct 2021 08:12:59 +0100
Message-ID: <1635664379230219@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: Mark USB_FSL_QE broken on 64-bit

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From a0548b26901f082684ad1fb3ba397d2de3a1406a Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 27 Oct 2021 10:08:49 +0200
Subject: usb: gadget: Mark USB_FSL_QE broken on 64-bit
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 64-bit:

    drivers/usb/gadget/udc/fsl_qe_udc.c: In function ‘qe_ep0_rx’:
    drivers/usb/gadget/udc/fsl_qe_udc.c:842:13: error: cast from pointer to integer of different size [-Werror=pointer-to-int-cast]
      842 |     vaddr = (u32)phys_to_virt(in_be32(&bd->buf));
	  |             ^
    In file included from drivers/usb/gadget/udc/fsl_qe_udc.c:41:
    drivers/usb/gadget/udc/fsl_qe_udc.c:843:28: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
      843 |     frame_set_data(pframe, (u8 *)vaddr);
	  |                            ^

The driver assumes physical and virtual addresses are 32-bit, hence it
cannot work on 64-bit platforms.

Acked-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/r/20211027080849.3276289-1-geert@linux-m68k.org
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/udc/Kconfig b/drivers/usb/gadget/udc/Kconfig
index 8c614bb86c66..69394dc1cdfb 100644
--- a/drivers/usb/gadget/udc/Kconfig
+++ b/drivers/usb/gadget/udc/Kconfig
@@ -330,6 +330,7 @@ config USB_AMD5536UDC
 config USB_FSL_QE
 	tristate "Freescale QE/CPM USB Device Controller"
 	depends on FSL_SOC && (QUICC_ENGINE || CPM)
+	depends on !64BIT || BROKEN
 	help
 	   Some of Freescale PowerPC processors have a Full Speed
 	   QE/CPM2 USB controller, which support device mode with 4
-- 
2.33.1


