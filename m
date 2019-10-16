Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A051D9DF2
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 23:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395174AbfJPVzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:55:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395158AbfJPVzC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:55:02 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06F5321925;
        Wed, 16 Oct 2019 21:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262902;
        bh=0BzHUrQye+rYcXuCHNc0Yjq0lAfviyokIpifD0QV5O0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x0gFMXg9Fdcj13iuMt8Y86AWdQTxpR9xpbW5SY2FgJiMVxLZoNbKYjoU+iXwGXR+6
         mHblPGCaZFDcmsi9NC3LLRLv8nGWAHl7VgbSCAKcvns2etC7CkTmImyY4KNz1QGT7O
         AYTAmossPqpca8sOELFuXxm6KQs83tCBW+G3dJ9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 62/92] USB: serial: fix runtime PM after driver unbind
Date:   Wed, 16 Oct 2019 14:50:35 -0700
Message-Id: <20191016214840.649571424@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214759.600329427@linuxfoundation.org>
References: <20191016214759.600329427@linuxfoundation.org>
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
@@ -315,10 +315,7 @@ static void serial_cleanup(struct tty_st
 	serial = port->serial;
 	owner = serial->type->driver.owner;
 
-	mutex_lock(&serial->disc_mutex);
-	if (!serial->disconnected)
-		usb_autopm_put_interface(serial->interface);
-	mutex_unlock(&serial->disc_mutex);
+	usb_autopm_put_interface(serial->interface);
 
 	usb_serial_put(serial);
 	module_put(owner);


