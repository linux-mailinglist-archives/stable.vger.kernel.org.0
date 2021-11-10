Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95BB44C75F
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhKJSui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:50:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:47820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233197AbhKJStO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:49:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84EBD6137F;
        Wed, 10 Nov 2021 18:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636569978;
        bh=9vh4/Poq6fHp7ATT1zlN7oohjKfXqdwbh1vvydivTTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b8f0Actsn6hZnoCWOQde6lp2xRS4sj4o+BElF687fqCQd4MDNZ9mkPIp6S0C3sJlp
         Z/2YwaMjoHVUdYFG+UKN281L87Dnm72eNFRuEtkKEmwM/vtpTP7rb8/7Wp+NqEqM5p
         AYPl7Ldwf+j5msydmN0bU3hjD1umh7ZZlts6aPII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 4.14 10/22] usb: gadget: Mark USB_FSL_QE broken on 64-bit
Date:   Wed, 10 Nov 2021 19:43:30 +0100
Message-Id: <20211110182003.000335549@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182002.666244094@linuxfoundation.org>
References: <20211110182002.666244094@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit a0548b26901f082684ad1fb3ba397d2de3a1406a upstream.

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
 drivers/usb/gadget/udc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/udc/Kconfig
+++ b/drivers/usb/gadget/udc/Kconfig
@@ -328,6 +328,7 @@ config USB_AMD5536UDC
 config USB_FSL_QE
 	tristate "Freescale QE/CPM USB Device Controller"
 	depends on FSL_SOC && (QUICC_ENGINE || CPM)
+	depends on !64BIT || BROKEN
 	help
 	   Some of Freescale PowerPC processors have a Full Speed
 	   QE/CPM2 USB controller, which support device mode with 4


