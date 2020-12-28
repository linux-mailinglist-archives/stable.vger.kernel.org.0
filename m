Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767472E3FE0
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732100AbgL1Opb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:45:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:48144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506451AbgL1Opb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:45:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C41F223E8;
        Mon, 28 Dec 2020 14:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609166690;
        bh=xB6jz9fA5pPiM6k45InaZbQ02maTGIP9+AwXRDkTVyM=;
        h=Subject:To:From:Date:From;
        b=psi6FjL+mqOepHMwePM6Rbf4ZnQoKaA+I/+IYeAKn9wq4RmblmIwEiA/HV72Cg7qV
         bzJOhZaP9RhzwYgnoV1ebiN3G6nvFY2AiQGijRU6/RD7gKbavf3JOU9j9Lb3VFJSuR
         A+6f5PpSmVEyD3j98YioFk5HaIAor7GijdiDiUDE=
Subject: patch "usb: gadget: u_ether: Fix MTU size mismatch with RX packet size" added to usb-linus
To:     manish.narani@xilinx.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 15:46:05 +0100
Message-ID: <160916676527214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: u_ether: Fix MTU size mismatch with RX packet size

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0a88fa221ce911c331bf700d2214c5b2f77414d3 Mon Sep 17 00:00:00 2001
From: Manish Narani <manish.narani@xilinx.com>
Date: Tue, 17 Nov 2020 12:43:35 +0530
Subject: usb: gadget: u_ether: Fix MTU size mismatch with RX packet size

Fix the MTU size issue with RX packet size as the host sends the packet
with extra bytes containing ethernet header. This causes failure when
user sets the MTU size to the maximum i.e. 15412. In this case the
ethernet packet received will be of length 15412 plus the ethernet header
length. This patch fixes the issue where there is a check that RX packet
length must not be more than max packet length.

Fixes: bba787a860fa ("usb: gadget: ether: Allow jumbo frames")
Signed-off-by: Manish Narani <manish.narani@xilinx.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1605597215-122027-1-git-send-email-manish.narani@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/u_ether.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/function/u_ether.c b/drivers/usb/gadget/function/u_ether.c
index 31ea76adcc0d..c019f2b0c0af 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -45,9 +45,10 @@
 #define UETH__VERSION	"29-May-2008"
 
 /* Experiments show that both Linux and Windows hosts allow up to 16k
- * frame sizes. Set the max size to 15k+52 to prevent allocating 32k
+ * frame sizes. Set the max MTU size to 15k+52 to prevent allocating 32k
  * blocks and still have efficient handling. */
-#define GETHER_MAX_ETH_FRAME_LEN 15412
+#define GETHER_MAX_MTU_SIZE 15412
+#define GETHER_MAX_ETH_FRAME_LEN (GETHER_MAX_MTU_SIZE + ETH_HLEN)
 
 struct eth_dev {
 	/* lock is held while accessing port_usb
@@ -786,7 +787,7 @@ struct eth_dev *gether_setup_name(struct usb_gadget *g,
 
 	/* MTU range: 14 - 15412 */
 	net->min_mtu = ETH_HLEN;
-	net->max_mtu = GETHER_MAX_ETH_FRAME_LEN;
+	net->max_mtu = GETHER_MAX_MTU_SIZE;
 
 	dev->gadget = g;
 	SET_NETDEV_DEV(net, &g->dev);
@@ -848,7 +849,7 @@ struct net_device *gether_setup_name_default(const char *netname)
 
 	/* MTU range: 14 - 15412 */
 	net->min_mtu = ETH_HLEN;
-	net->max_mtu = GETHER_MAX_ETH_FRAME_LEN;
+	net->max_mtu = GETHER_MAX_MTU_SIZE;
 
 	return net;
 }
-- 
2.29.2


