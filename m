Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E9720752E
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 16:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404014AbgFXODU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 10:03:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403985AbgFXODT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jun 2020 10:03:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9A6220724;
        Wed, 24 Jun 2020 14:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593007399;
        bh=xHdtMMqS+wcVNTAf7nWRhLX1VGbf3e3Py9HcWtbTuGQ=;
        h=Subject:To:From:Date:From;
        b=oV8eOj5YT450oyr/qMJ6N6Y1fOTSpEXWTeEBw9dgqxacDIp2KepkxZ3sWJNgSeSil
         aC7bKHXm1tB04mzoKI3WLP39MDLAKrNPMJbXXd6in2P1lTVQAK0oPdwFnoyMy/fCAZ
         M2/jWc2ikT9J4HHq9nxrVgbOovVAc5uHDcncT2y0=
Subject: patch "usb: cdns3: trace: using correct dir value" added to usb-linus
To:     peter.chen@nxp.com, gregkh@linuxfoundation.org, pawell@cadence.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 24 Jun 2020 16:03:07 +0200
Message-ID: <15930073871455@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdns3: trace: using correct dir value

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 813072b67ee97659807049d014c9d4e36fd62e94 Mon Sep 17 00:00:00 2001
From: Peter Chen <peter.chen@nxp.com>
Date: Tue, 23 Jun 2020 11:09:17 +0800
Subject: usb: cdns3: trace: using correct dir value

It should use the correct direction value from register, not depends
on previous software setting. It fixed the EP number wrong issue at
trace when the TRBERR interrupt occurs for EP0IN.

When the EP0IN IOC has finished, software prepares the setup packet
request, the expected direction is OUT, but at that time, the TRBERR
for EP0IN may occur since it is DMULT mode, the DMA does not stop
until TRBERR has met.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Cc: <stable@vger.kernel.org>
Reviewed-by: Pawel Laszczak <pawell@cadence.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20200623030918.8409-3-peter.chen@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/trace.h b/drivers/usb/cdns3/trace.h
index 8d121e207fd8..755c56582257 100644
--- a/drivers/usb/cdns3/trace.h
+++ b/drivers/usb/cdns3/trace.h
@@ -156,7 +156,7 @@ DECLARE_EVENT_CLASS(cdns3_log_ep0_irq,
 		__dynamic_array(char, str, CDNS3_MSG_MAX)
 	),
 	TP_fast_assign(
-		__entry->ep_dir = priv_dev->ep0_data_dir;
+		__entry->ep_dir = priv_dev->selected_ep;
 		__entry->ep_sts = ep_sts;
 	),
 	TP_printk("%s", cdns3_decode_ep0_irq(__get_str(str),
-- 
2.27.0


