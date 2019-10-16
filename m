Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9C1DD9FA9
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391343AbfJPV5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:57:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406669AbfJPV5I (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:57:08 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B775820872;
        Wed, 16 Oct 2019 21:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263027;
        bh=bmmJE0WLwJRxWkFTNcpVE3zwotn4CsZHkea48KPSqUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZFInKMNYcI1nu8SIQpMaFlj4c9cumnJfb6GvCoBweCANONmDkaZGyRxQV4xBYyZbh
         TXKh8sYjD2aNhwn1IaTzukDvqRlM2EFRustlSeHZaBcXELMSKQ9WfYhorDZ3ubRk3Z
         pSdFr8c6QOZ/BIiz3hISm8SAs6q1lIwQJWMRVtMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 29/81] USB: serial: fix runtime PM after driver unbind
Date:   Wed, 16 Oct 2019 14:50:40 -0700
Message-Id: <20191016214831.320656822@linuxfoundation.org>
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

commit d51bdb93ca7e71d7fb30a572c7b47ed0194bf3fe upstream.

Since commit c2b71462d294 ("USB: core: Fix bug caused by duplicate
interface PM usage counter") USB drivers must always balance their
runtime PM gets and puts, including when the driver has already been
unbound from the interface.

Leaving the interface with a positive PM usage counter would prevent a
later bound driver from suspending the device.

Fixes: c2b71462d294 ("USB: core: Fix bug caused by duplicate interface PM usage counter")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191001084908.2003-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/usb-serial.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -311,10 +311,7 @@ static void serial_cleanup(struct tty_st
 	serial = port->serial;
 	owner = serial->type->driver.owner;
 
-	mutex_lock(&serial->disc_mutex);
-	if (!serial->disconnected)
-		usb_autopm_put_interface(serial->interface);
-	mutex_unlock(&serial->disc_mutex);
+	usb_autopm_put_interface(serial->interface);
 
 	usb_serial_put(serial);
 	module_put(owner);


