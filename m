Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110DD3EB854
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241881AbhHMPM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:12:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241806AbhHMPLn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:11:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8F99610FE;
        Fri, 13 Aug 2021 15:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867476;
        bh=30KxOoloYmk5zGptQQfwJlpzpjCtuvoyUMdhH9lZjGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=16OLWzmKS1kHlI3+Iw1b5R+pKtNl2EVoda17Wie8FFHesvhsh9CqvCcAM5IWO9nJe
         FEHVK44F04sMAI+HUHC1dfikCNNKzMBDDJGyMmMzGBYXVinza4vOUmkIrZbzyNCLMo
         BHjW62eX2sxO7ym065Tqn+NOvyX95184/E8jJf6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Devaev <mdevaev@gmail.com>,
        Phil Elwell <phil@raspberrypi.com>
Subject: [PATCH 4.14 20/42] usb: gadget: f_hid: fixed NULL pointer dereference
Date:   Fri, 13 Aug 2021 17:06:46 +0200
Message-Id: <20210813150525.780787054@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150525.098817398@linuxfoundation.org>
References: <20210813150525.098817398@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Elwell <phil@raspberrypi.com>

commit 2867652e4766360adf14dfda3832455e04964f2a upstream.

Disconnecting and reconnecting the USB cable can lead to crashes
and a variety of kernel log spam.

The problem was found and reproduced on the Raspberry Pi [1]
and the original fix was created in Raspberry's own fork [2].

Link: https://github.com/raspberrypi/linux/issues/3870 [1]
Link: https://github.com/raspberrypi/linux/commit/a6e47d5f4efbd2ea6a0b6565cd2f9b7bb217ded5 [2]
Signed-off-by: Maxim Devaev <mdevaev@gmail.com>
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210723155928.210019-1-mdevaev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_hid.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -349,6 +349,11 @@ static ssize_t f_hidg_write(struct file
 
 	spin_lock_irqsave(&hidg->write_spinlock, flags);
 
+	if (!hidg->req) {
+		spin_unlock_irqrestore(&hidg->write_spinlock, flags);
+		return -ESHUTDOWN;
+	}
+
 #define WRITE_COND (!hidg->write_pending)
 try_again:
 	/* write queue */
@@ -369,8 +374,14 @@ try_again:
 	count  = min_t(unsigned, count, hidg->report_length);
 
 	spin_unlock_irqrestore(&hidg->write_spinlock, flags);
-	status = copy_from_user(req->buf, buffer, count);
 
+	if (!req) {
+		ERROR(hidg->func.config->cdev, "hidg->req is NULL\n");
+		status = -ESHUTDOWN;
+		goto release_write_pending;
+	}
+
+	status = copy_from_user(req->buf, buffer, count);
 	if (status != 0) {
 		ERROR(hidg->func.config->cdev,
 			"copy_from_user error\n");
@@ -398,14 +409,17 @@ try_again:
 
 	spin_unlock_irqrestore(&hidg->write_spinlock, flags);
 
+	if (!hidg->in_ep->enabled) {
+		ERROR(hidg->func.config->cdev, "in_ep is disabled\n");
+		status = -ESHUTDOWN;
+		goto release_write_pending;
+	}
+
 	status = usb_ep_queue(hidg->in_ep, req, GFP_ATOMIC);
-	if (status < 0) {
-		ERROR(hidg->func.config->cdev,
-			"usb_ep_queue error on int endpoint %zd\n", status);
+	if (status < 0)
 		goto release_write_pending;
-	} else {
+	else
 		status = count;
-	}
 
 	return status;
 release_write_pending:


