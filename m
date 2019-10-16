Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C121ED9FA4
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391417AbfJPV5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:57:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437949AbfJPV5B (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:57:01 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49F4C21D7D;
        Wed, 16 Oct 2019 21:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263020;
        bh=majxEuL7VpOdF5gmfB0VT/XgrY8AjwHSQ50imORUPb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/3OXi3mc5uqiTUMIY8cDFwplQNe5yh75Ok8oLQfsy7j8ywVCLE0JNMVzeoGW48GK
         2wOGIrfbI9ZE/IcBAUj8fnT+VmqijyciDjH2p/KUnMENG1oXXfdRSl46yNFiQuQkvf
         fn5gDovF8FGdlAm+F2luozcHBO4+BG7pQ7fYSeU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 21/81] USB: usblp: fix runtime PM after driver unbind
Date:   Wed, 16 Oct 2019 14:50:32 -0700
Message-Id: <20191016214826.444202726@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214805.727399379@linuxfoundation.org>
References: <20191016214805.727399379@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 9a31535859bfd8d1c3ed391f5e9247cd87bb7909 upstream.

Since commit c2b71462d294 ("USB: core: Fix bug caused by duplicate
interface PM usage counter") USB drivers must always balance their
runtime PM gets and puts, including when the driver has already been
unbound from the interface.

Leaving the interface with a positive PM usage counter would prevent a
later bound driver from suspending the device.

Fixes: c2b71462d294 ("USB: core: Fix bug caused by duplicate interface PM usage counter")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191001084908.2003-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/usblp.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -461,10 +461,12 @@ static int usblp_release(struct inode *i
 
 	mutex_lock(&usblp_mutex);
 	usblp->used = 0;
-	if (usblp->present) {
+	if (usblp->present)
 		usblp_unlink_urbs(usblp);
-		usb_autopm_put_interface(usblp->intf);
-	} else		/* finish cleanup from disconnect */
+
+	usb_autopm_put_interface(usblp->intf);
+
+	if (!usblp->present)		/* finish cleanup from disconnect */
 		usblp_cleanup(usblp);
 	mutex_unlock(&usblp_mutex);
 	return 0;


