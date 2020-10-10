Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8763428A38A
	for <lists+stable@lfdr.de>; Sun, 11 Oct 2020 01:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390325AbgJJW4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Oct 2020 18:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731202AbgJJTxO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Oct 2020 15:53:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC55A2158C;
        Sat, 10 Oct 2020 10:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602326231;
        bh=+Wlv5eH1WTti9EvolLzz2SMnHtXxmJKq/fArz4JPhjY=;
        h=Subject:To:From:Date:From;
        b=aj9LnpC6yrpv+DiC+LcPuzY2p2QJaPud9AY3c+f57ficSVCtU3CmwPBvNUSJkpnRF
         nyokpV6WjEOE/ttmMmoN8hrWoQeOtGsneSDYl8w3KuBFoqpEk6abVG568zHYkfrlGN
         Z6xFcry2TJnm8wyngOj9XE5jekV6prfUCFJpfrZU=
Subject: patch "staging: comedi: check validity of wMaxPacketSize of usb endpoints" added to staging-testing
To:     anant.thazhemadam@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 10 Oct 2020 12:37:55 +0200
Message-ID: <160232627519420@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: comedi: check validity of wMaxPacketSize of usb endpoints

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From e1f13c879a7c21bd207dc6242455e8e3a1e88b40 Mon Sep 17 00:00:00 2001
From: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Date: Sat, 10 Oct 2020 13:59:32 +0530
Subject: staging: comedi: check validity of wMaxPacketSize of usb endpoints
 found

While finding usb endpoints in vmk80xx_find_usb_endpoints(), check if
wMaxPacketSize = 0 for the endpoints found.

Some devices have isochronous endpoints that have wMaxPacketSize = 0
(as required by the USB-2 spec).
However, since this doesn't apply here, wMaxPacketSize = 0 can be
considered to be invalid.

Reported-by: syzbot+009f546aa1370056b1c2@syzkaller.appspotmail.com
Tested-by: syzbot+009f546aa1370056b1c2@syzkaller.appspotmail.com
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201010082933.5417-1-anant.thazhemadam@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/vmk80xx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index 65dc6c51037e..7956abcbae22 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -667,6 +667,9 @@ static int vmk80xx_find_usb_endpoints(struct comedi_device *dev)
 	if (!devpriv->ep_rx || !devpriv->ep_tx)
 		return -ENODEV;
 
+	if (!usb_endpoint_maxp(devpriv->ep_rx) || !usb_endpoint_maxp(devpriv->ep_tx))
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
2.28.0


