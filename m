Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E725C33F9FA
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 21:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhCQUbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 16:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233406AbhCQUbH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 16:31:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C375264D79;
        Wed, 17 Mar 2021 20:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616013063;
        bh=sKQhkuiwrgFXSYtQ2+yzMzO2UcJXUDVr7tG3Fd2KVg8=;
        h=Subject:To:From:Date:From;
        b=d+D5yxZQ4EG8rffseLCAQIZlUkI4jwLmB8JDRw5xIRH30VaNAx2zSyI08NAKD8S63
         JQ+9oQaVGwhD5KVL74qBEftDW61Ep6Fp1eEwuM0vI/1lPBF+unIM9IpeCTqnFh3ziI
         UcYrQu2i14M1jmH65395PCwyH87IWMzpcFrAbWzc=
Subject: patch "usbip: Fix incorrect double assignment to udc->ud.tcp_rx" added to usb-linus
To:     colin.king@canonical.com, gregkh@linuxfoundation.org,
        skhan@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 17 Mar 2021 21:31:00 +0100
Message-ID: <16160130608112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usbip: Fix incorrect double assignment to udc->ud.tcp_rx

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9858af27e69247c5d04c3b093190a93ca365f33d Mon Sep 17 00:00:00 2001
From: Colin Ian King <colin.king@canonical.com>
Date: Thu, 11 Mar 2021 10:44:45 +0000
Subject: usbip: Fix incorrect double assignment to udc->ud.tcp_rx

Currently udc->ud.tcp_rx is being assigned twice, the second assignment
is incorrect, it should be to udc->ud.tcp_tx instead of rx. Fix this.

Fixes: 46613c9dfa96 ("usbip: fix vudc usbip_sockfd_store races leading to gpf")
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: stable <stable@vger.kernel.org>
Addresses-Coverity: ("Unused value")
Link: https://lore.kernel.org/r/20210311104445.7811-1-colin.king@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/vudc_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/usbip/vudc_sysfs.c b/drivers/usb/usbip/vudc_sysfs.c
index a3ec39fc6177..7383a543c6d1 100644
--- a/drivers/usb/usbip/vudc_sysfs.c
+++ b/drivers/usb/usbip/vudc_sysfs.c
@@ -174,7 +174,7 @@ static ssize_t usbip_sockfd_store(struct device *dev,
 
 		udc->ud.tcp_socket = socket;
 		udc->ud.tcp_rx = tcp_rx;
-		udc->ud.tcp_rx = tcp_tx;
+		udc->ud.tcp_tx = tcp_tx;
 		udc->ud.status = SDEV_ST_USED;
 
 		spin_unlock_irq(&udc->ud.lock);
-- 
2.30.2


