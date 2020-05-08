Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B881CAFA3
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgEHNSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:18:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729030AbgEHMnE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:43:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23C532495F;
        Fri,  8 May 2020 12:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941783;
        bh=OEOXJp0GplwOqua4HXBdjeGkIycP+sjXal95fZYY9Dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WtZ41GTfTlqVC3Jg2mPu2sm0OqYI98vlB30T/cA5gJikR1IEqNUnk/coxVpKfrPsk
         QzK2RKdyW0bc5RkW4AdrRLJ3weELwN0PFMGxzUHvVb/8qAxPy32g+vKRQr2IeRm4c4
         p/c1Cm/GeS/BFNt2RPZLiFrwVu2G53/wQvzqJ9l4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 4.4 170/312] [media] lirc_imon: do not leave imon_probe() with mutex held
Date:   Fri,  8 May 2020 14:32:41 +0200
Message-Id: <20200508123136.454970850@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

commit b833d0df943d70682e288c38c96b8e7bfff4023a upstream.

Commit af8a819a2513 ("[media] lirc_imon: simplify error handling code")
lost mutex_unlock(&context->ctx_lock), so imon_probe() exits with
the context->ctx_lock mutex acquired.

The patch adds mutex_unlock(&context->ctx_lock) back.

Found by Linux Driver Verification project (linuxtesting.org).

Fixes: af8a819a2513 ("[media] lirc_imon: simplify error handling code")

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/media/lirc/lirc_imon.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -885,12 +885,14 @@ static int imon_probe(struct usb_interfa
 		vendor, product, ifnum, usbdev->bus->busnum, usbdev->devnum);
 
 	/* Everything went fine. Just unlock and return retval (with is 0) */
+	mutex_unlock(&context->ctx_lock);
 	goto driver_unlock;
 
 unregister_lirc:
 	lirc_unregister_driver(driver->minor);
 
 free_tx_urb:
+	mutex_unlock(&context->ctx_lock);
 	usb_free_urb(tx_urb);
 
 free_rx_urb:


