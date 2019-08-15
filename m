Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5308EBE2
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 14:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731306AbfHOMul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 08:50:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730379AbfHOMul (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Aug 2019 08:50:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59E082084D;
        Thu, 15 Aug 2019 12:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565873440;
        bh=pOHhFqkIwLF2xFJyNpW/8ujVDf1ei3Sz6qSnndqjRrg=;
        h=Subject:To:From:Date:From;
        b=TSuHwgqjFxfAAr0SWalBtuleXOikuphSobZB1LnTOBpCrZD8C5R9u5Ibba9EwdnNL
         WOPvFa28CYtqTJ1m5eEvFuTpjlJ3OOHxthMxRIz1PJiUFcs3poNBRX4PhqJ0mGIzXP
         RsaO3Y9xpV+JDddBNMwJWgPuBaPsEknlYhcqiOPM=
Subject: patch "USB: CDC: fix sanity checks in CDC union parser" added to usb-linus
To:     oneukum@suse.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 15 Aug 2019 14:50:35 +0200
Message-ID: <1565873435232235@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: CDC: fix sanity checks in CDC union parser

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 54364278fb3cabdea51d6398b07c87415065b3fc Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Tue, 13 Aug 2019 11:35:41 +0200
Subject: USB: CDC: fix sanity checks in CDC union parser

A few checks checked for the size of the pointer to a structure
instead of the structure itself. Copy & paste issue presumably.

Fixes: e4c6fb7794982 ("usbnet: move the CDC parser into USB core")
Cc: stable <stable@vger.kernel.org>
Reported-by: syzbot+45a53506b65321c1fe91@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20190813093541.18889-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/message.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index e844bb7b5676..5adf489428aa 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -2218,14 +2218,14 @@ int cdc_parse_cdc_header(struct usb_cdc_parsed_header *hdr,
 				(struct usb_cdc_dmm_desc *)buffer;
 			break;
 		case USB_CDC_MDLM_TYPE:
-			if (elength < sizeof(struct usb_cdc_mdlm_desc *))
+			if (elength < sizeof(struct usb_cdc_mdlm_desc))
 				goto next_desc;
 			if (desc)
 				return -EINVAL;
 			desc = (struct usb_cdc_mdlm_desc *)buffer;
 			break;
 		case USB_CDC_MDLM_DETAIL_TYPE:
-			if (elength < sizeof(struct usb_cdc_mdlm_detail_desc *))
+			if (elength < sizeof(struct usb_cdc_mdlm_detail_desc))
 				goto next_desc;
 			if (detail)
 				return -EINVAL;
-- 
2.22.1


