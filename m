Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15BC6F7F2A
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfKKSdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:33:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:50568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727161AbfKKSdO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:33:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8109521655;
        Mon, 11 Nov 2019 18:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497193;
        bh=mqyEWFvgOemgk+WYbPoXVJtGwlTN2nroQNnURcth40M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cO/jrqRFcuS37HDhO5FGYs/0+/Sr9/2aai9kITJftgXrDqCfpslFtWlAtraiIGX6T
         kp1pg2JKMHeGU3qaBVxHaibVWUjQJ4Bi3iMeOTGmkXkwhBxeGlciPy5j1JHJxku58o
         FzOGFnzBaTTNAHmdfuKnz6tmKyuquobfl2MEwNXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <shuah@kernel.org>
Subject: [PATCH 4.9 34/65] usbip: Fix vhci_urb_enqueue() URB null transfer buffer error path
Date:   Mon, 11 Nov 2019 19:28:34 +0100
Message-Id: <20191111181346.896360052@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181331.917659011@linuxfoundation.org>
References: <20191111181331.917659011@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <shuah@kernel.org>

commit 2c904963b1dd2acd4bc785b6c72e10a6283c2081 upstream.

Fix vhci_urb_enqueue() to print debug msg and return error instead of
failing with BUG_ON.

Signed-off-by: Shuah Khan <shuah@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/usbip/vhci_hcd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/usbip/vhci_hcd.c
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -512,8 +512,10 @@ static int vhci_urb_enqueue(struct usb_h
 	}
 	vdev = &vhci->vdev[portnum-1];
 
-	/* patch to usb_sg_init() is in 2.5.60 */
-	BUG_ON(!urb->transfer_buffer && urb->transfer_buffer_length);
+	if (!urb->transfer_buffer && urb->transfer_buffer_length) {
+		dev_dbg(dev, "Null URB transfer buffer\n");
+		return -EINVAL;
+	}
 
 	spin_lock_irqsave(&vhci->lock, flags);
 


