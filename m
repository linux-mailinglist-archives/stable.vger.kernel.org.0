Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 723A23A93C
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388713AbfFIREw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:04:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388670AbfFIREp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:04:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39A64206C3;
        Sun,  9 Jun 2019 17:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099884;
        bh=A7eutUFKo6yo83oVU/tFlirD2+eZz5kRU4Rm7mtouf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KAF7DL4PC08FzmUyTURjFlfAeBIA74REuUZdI9QYSUt+a0oqM12x7hjsK1zycMRK5
         D+ZyFv/vA9OH8xXjSN4sCOdSqMu4DAeO0Y47TU9bdwPHTgLNW/xU7k5W3i5Fe1J+Wz
         wEScUxDNskapcU5ohIc0uNovpM0NVnQz2+ZqvMT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        kbuild test robot <lkp@intel.com>
Subject: [PATCH 4.4 202/241] media: usb: siano: Fix false-positive "uninitialized variable" warning
Date:   Sun,  9 Jun 2019 18:42:24 +0200
Message-Id: <20190609164154.178300270@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 45457c01171fd1488a7000d1751c06ed8560ee38 upstream.

GCC complains about an apparently uninitialized variable recently
added to smsusb_init_device().  It's a false positive, but to silence
the warning this patch adds a trivial initialization.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: kbuild test robot <lkp@intel.com>
CC: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/siano/smsusb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -391,7 +391,7 @@ static int smsusb_init_device(struct usb
 	struct smsusb_device_t *dev;
 	void *mdev;
 	int i, rc;
-	int in_maxp;
+	int in_maxp = 0;
 
 	/* create device object */
 	dev = kzalloc(sizeof(struct smsusb_device_t), GFP_KERNEL);


