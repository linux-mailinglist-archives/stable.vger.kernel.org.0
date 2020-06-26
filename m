Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A3720B44C
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 17:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgFZPRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 11:17:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbgFZPRX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jun 2020 11:17:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 203A4207E8;
        Fri, 26 Jun 2020 15:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593184642;
        bh=yiCbDRqU1w7i0MTQIap6mAIQGiGuYDlFa0SBU7COmgQ=;
        h=Subject:To:From:Date:From;
        b=v0Kwq1zBHjPS9YsZ3Q6C4126K4Pu9T5ilaNcSggVR4ls/oS/NPaK///0BiC2y30YI
         R7Nj0DF9fsEi/fJ0Yspwa19ZBIeFts9ANA+rYwvUyjszk3PTX+k5GPnBRvGHEXj089
         yuEDE+uHy9aLyT9VV9SK0kDlurS81Egv3/IE7wBw=
Subject: patch "usb: cdns3: trace: using correct dir value" added to usb-linus
To:     peter.chen@nxp.com, balbi@kernel.org, pawell@cadence.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 26 Jun 2020 17:17:13 +0200
Message-ID: <1593184633157126@kroah.com>
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


From ba3a80fe0fb67d8790f62b7bc60df97406d89871 Mon Sep 17 00:00:00 2001
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

Cc: <stable@vger.kernel.org>
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Reviewed-by: Pawel Laszczak <pawell@cadence.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
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


