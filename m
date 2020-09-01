Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C7A2595D9
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731222AbgIAP4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:56:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731839AbgIAPou (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:44:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EC46206EB;
        Tue,  1 Sep 2020 15:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975089;
        bh=h20gwhi+ec5+XhdOH3pXAyexGBcuS6qPY0q8ACdgBgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9mdfTFREPMsr9/3eLMJ7i37gisPGYpr5y93x0PHHG5K0OgnYI0Koiw4S57qEiANI
         mJnjD0K2uzBz8TsNN1adn5tIrS+yLfPX3mWVT1w7HP/cH3aFVSnAilXRoKQKRKHG1C
         UlRkMe/Nhf3qrXEFzXJur4/CuIhsATR5jG6Mwh6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "M. Vefa Bicakci" <m.v.b@runbox.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bastien Nocera <hadess@hadess.net>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.8 205/255] usbip: Implement a match function to fix usbip
Date:   Tue,  1 Sep 2020 17:11:01 +0200
Message-Id: <20200901151010.524599037@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: M. Vefa Bicakci <m.v.b@runbox.com>

commit 7a2f2974f26542b4e7b9b4321edb3cbbf3eeb91a upstream.

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
Cc: Alan Stern <stern@rowland.harvard.edu>
Reviewed-by: Bastien Nocera <hadess@hadess.net>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20200810160017.46002-1-m.v.b@runbox.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/usbip/stub_dev.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/usbip/stub_dev.c
+++ b/drivers/usb/usbip/stub_dev.c
@@ -461,6 +461,11 @@ static void stub_disconnect(struct usb_d
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


