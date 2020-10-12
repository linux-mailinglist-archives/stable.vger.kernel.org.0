Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E8728B704
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731448AbgJLNjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:39:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731389AbgJLNja (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:39:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E9B0221FF;
        Mon, 12 Oct 2020 13:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509969;
        bh=XtpB59G9TYE4H0HNJH7eGgnDt+9I9era3TAO16Mqdc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GV5aP2jajcH94YmKI6wZhNPfIONjadJxO6digUUEbIpj8aCzEb4KOXuLyO9vSf2AP
         rqUci4yQXNccWyh3ndS3Ei2lAdouTk0y1+Y1Y8g+7vjVgkHdK4HwUQi0mnsqTHyrbo
         OtY5P25JVvSlUM5fO+fd5V8JTm+AEg6Pyezz35h0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4.19 08/49] platform/x86: intel-vbtn: Fix SW_TABLET_MODE always reporting 1 on the HP Pavilion 11 x360
Date:   Mon, 12 Oct 2020 15:26:54 +0200
Message-Id: <20201012132629.820632023@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.469542486@linuxfoundation.org>
References: <20201012132629.469542486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit d823346876a970522ff9e4d2b323c9b734dcc4de upstream.

Commit cfae58ed681c ("platform/x86: intel-vbtn: Only blacklist
SW_TABLET_MODE on the 9 / "Laptop" chasis-type") restored SW_TABLET_MODE
reporting on the HP stream x360 11 series on which it was previously broken
by commit de9647efeaa9 ("platform/x86: intel-vbtn: Only activate tablet
mode switch on 2-in-1's").

It turns out that enabling SW_TABLET_MODE reporting on devices with a
chassis-type of 10 ("Notebook") causes SW_TABLET_MODE to always report 1
at boot on the HP Pavilion 11 x360, which causes libinput to disable the
kbd and touchpad.

The HP Pavilion 11 x360's ACPI VGBS method sets bit 4 instead of bit 6 when
NOT in tablet mode at boot. Inspecting all the DSDTs in my DSDT collection
shows only one other model, the Medion E1239T ever setting bit 4 and it
always sets this together with bit 6.

So lets treat bit 4 as a second bit which when set indicates the device not
being in tablet-mode, as we already do for bit 6.

While at it also prefix all VGBS constant defines with "VGBS_".

Fixes: cfae58ed681c ("platform/x86: intel-vbtn: Only blacklist SW_TABLET_MODE on the 9 / "Laptop" chasis-type")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Mark Gross <mgross@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/intel-vbtn.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/platform/x86/intel-vbtn.c
+++ b/drivers/platform/x86/intel-vbtn.c
@@ -15,9 +15,13 @@
 #include <linux/platform_device.h>
 #include <linux/suspend.h>
 
+/* Returned when NOT in tablet mode on some HP Stream x360 11 models */
+#define VGBS_TABLET_MODE_FLAG_ALT	0x10
 /* When NOT in tablet mode, VGBS returns with the flag 0x40 */
-#define TABLET_MODE_FLAG 0x40
-#define DOCK_MODE_FLAG   0x80
+#define VGBS_TABLET_MODE_FLAG		0x40
+#define VGBS_DOCK_MODE_FLAG		0x80
+
+#define VGBS_TABLET_MODE_FLAGS (VGBS_TABLET_MODE_FLAG | VGBS_TABLET_MODE_FLAG_ALT)
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("AceLan Kao");
@@ -148,9 +152,9 @@ static void detect_tablet_mode(struct pl
 	if (ACPI_FAILURE(status))
 		return;
 
-	m = !(vgbs & TABLET_MODE_FLAG);
+	m = !(vgbs & VGBS_TABLET_MODE_FLAGS);
 	input_report_switch(priv->input_dev, SW_TABLET_MODE, m);
-	m = (vgbs & DOCK_MODE_FLAG) ? 1 : 0;
+	m = (vgbs & VGBS_DOCK_MODE_FLAG) ? 1 : 0;
 	input_report_switch(priv->input_dev, SW_DOCK, m);
 }
 


