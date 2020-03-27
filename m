Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F347195176
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 07:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgC0Gpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 02:45:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbgC0Gpo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Mar 2020 02:45:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D880820714;
        Fri, 27 Mar 2020 06:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585291543;
        bh=T9gf3dazjNewCdI74E7CACABk4ph6Xwjb1i/fBY8AR8=;
        h=Subject:To:From:Date:From;
        b=Xq1SnPNOVlpgAjg/U0KkFLSzaE7LXaR9uAa8s7tInPl3+k+9e5yvS5AM4MwaA7uTf
         hToxVRia3LCKRV09W9RV0pz0seY5WgBc1tEcMp7uwFKYJBZVMxiA2ran5V/sQMbTBt
         7K+p3OlqMFpCmqyZJtvn9dFWuyOEA36sujMSH3RE=
Subject: patch "USB: serial: io_edgeport: fix slab-out-of-bounds read in" added to usb-next
To:     hqjagain@gmail.com, johan@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 27 Mar 2020 07:45:00 +0100
Message-ID: <1585291500179113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: io_edgeport: fix slab-out-of-bounds read in

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 57aa9f294b09463492f604feaa5cc719beaace32 Mon Sep 17 00:00:00 2001
From: Qiujun Huang <hqjagain@gmail.com>
Date: Wed, 25 Mar 2020 15:52:37 +0800
Subject: USB: serial: io_edgeport: fix slab-out-of-bounds read in
 edge_interrupt_callback

Fix slab-out-of-bounds read in the interrupt-URB completion handler.

The boundary condition should be (length - 1) as we access
data[position + 1].

Reported-and-tested-by: syzbot+37ba33391ad5f3935bbd@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/io_edgeport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index 5737add6a2a4..4cca0b836f43 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -710,7 +710,7 @@ static void edge_interrupt_callback(struct urb *urb)
 		/* grab the txcredits for the ports if available */
 		position = 2;
 		portNumber = 0;
-		while ((position < length) &&
+		while ((position < length - 1) &&
 				(portNumber < edge_serial->serial->num_ports)) {
 			txCredits = data[position] | (data[position+1] << 8);
 			if (txCredits) {
-- 
2.26.0


