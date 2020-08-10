Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD06240B2A
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 18:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgHJQ27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 12:28:59 -0400
Received: from aibo.runbox.com ([91.220.196.211]:58910 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbgHJQ26 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 12:28:58 -0400
X-Greylist: delayed 1691 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Aug 2020 12:28:57 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector2; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
        Subject:Cc:To:From; bh=bo1G8C5GYYhENQGfKCwbxKc3IBx2vVMOyqyqCffyR9w=; b=Z/2Ie+
        ur4KKxiw5e6nNnVi6b7ACMAp6nMwNQC7F6N+qfzcL/TmXz8gxbeC/wzuwW6JkIa4Nada+dIAgLymK
        wePJmkqhpSafnkZVSkgLT+ma+b9p8EYKwi99fT85BEov2SZ6Xg4OLLqGPPPKLshKL5+UStonQv7hC
        yQDzMZpqa9qsNwdvA+F/GQIVttTSKl1SvJ+PWE8vS01xLP+GV2lwwI6wvTLos7rmnqQ5pyQoh3wrm
        ebdA+NvkuFDRhVcOcoFmQC/0CSJzO1Z6LIK+DPQRPrPeQYmVDnhCd2O5ZQUxZBQc22Yg5bDIBcvf1
        360uJA3dL3ykA3nJvEct8Da3Z8TQ==;
Received: from [10.9.9.74] (helo=submission03.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1k5AE8-0001mT-EV; Mon, 10 Aug 2020 18:00:44 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1k5ADq-0001c7-OM; Mon, 10 Aug 2020 18:00:26 +0200
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
To:     linux-usb@vger.kernel.org
Cc:     "M. Vefa Bicakci" <m.v.b@runbox.com>, stable@vger.kernel.org,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bastien Nocera <hadess@hadess.net>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] usbip: Implement a match function to fix usbip
Date:   Mon, 10 Aug 2020 19:00:17 +0300
Message-Id: <20200810160017.46002-1-m.v.b@runbox.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 88b7381a939d ("USB: Select better matching USB drivers when
available") introduced the use of a "match" function to select a
non-generic/better driver for a particular USB device. This
unfortunately breaks the operation of usbip in general, as reported in
the kernel bugzilla with bug 208267 (linked below).

Upon inspecting the aforementioned commit, one can observe that the
original code in the usb_device_match function used to return 1
unconditionally, but the aforementioned commit makes the usb_device_match
function use identifier tables and "match" virtual functions, if either of
them are available.

Hence, this commit implements a match function for usbip that
unconditionally returns true to ensure that usbip is functional again.

This change has been verified to restore usbip functionality, with a
v5.7.y kernel on an up-to-date version of Qubes OS 4.0, which uses
usbip to redirect USB devices between VMs.

Thanks to Jonathan Dieter for the effort in bisecting this issue down
to the aforementioned commit.

Fixes: 88b7381a939d ("USB: Select better matching USB drivers when available")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=208267
Link: https://bugzilla.redhat.com/show_bug.cgi?id=1856443
Link: https://github.com/QubesOS/qubes-issues/issues/5905
Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
Cc: <stable@vger.kernel.org> # 5.7
Cc: Valentina Manea <valentina.manea.m@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bastien Nocera <hadess@hadess.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/usbip/stub_dev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/usbip/stub_dev.c b/drivers/usb/usbip/stub_dev.c
index 2305d425e6c9..9d7d642022d1 100644
--- a/drivers/usb/usbip/stub_dev.c
+++ b/drivers/usb/usbip/stub_dev.c
@@ -461,6 +461,11 @@ static void stub_disconnect(struct usb_device *udev)
 	return;
 }
 
+static bool usbip_match(struct usb_device *udev)
+{
+	return true;
+}
+
 #ifdef CONFIG_PM
 
 /* These functions need usb_port_suspend and usb_port_resume,
@@ -486,6 +491,7 @@ struct usb_device_driver stub_driver = {
 	.name		= "usbip-host",
 	.probe		= stub_probe,
 	.disconnect	= stub_disconnect,
+	.match		= usbip_match,
 #ifdef CONFIG_PM
 	.suspend	= stub_suspend,
 	.resume		= stub_resume,
-- 
2.26.2

