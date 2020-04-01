Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1839819B04D
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732376AbgDAQZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:25:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387447AbgDAQZl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:25:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB57820BED;
        Wed,  1 Apr 2020 16:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758340;
        bh=ok2/8NJSWUu4X9e1M4vYeide9GdcckmZsFccmMIamaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tro3+YgJHwTro9W8gDV9L4A4Dt+eBqTzcZN20PCquTDGsxCJtSCsJDIMkrbajdBOS
         3XvEeb7EeMRJsVr7HR1ErHzXmDksoJTOgGQNKHdtMY/oS3gjCwrmjnAwUpFQclYNgA
         eDAU0KMj5q8PS8FwY892k3AGPH8SCCi9OoQcRoYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.19 060/116] gpiolib: acpi: Correct comment for HP x2 10 honor_wakeup quirk
Date:   Wed,  1 Apr 2020 18:17:16 +0200
Message-Id: <20200401161550.716241766@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161542.669484650@linuxfoundation.org>
References: <20200401161542.669484650@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit efaa87fa0947d525cf7c075316adde4e3ac7720b upstream.

Commit aa23ca3d98f7 ("gpiolib: acpi: Add honor_wakeup module-option +
quirk mechanism") added a quirk for some models of the HP x2 10 series.

There are 2 issues with the comment describing the quirk:
1) The comment claims the DMI quirk applies to all Cherry Trail based HP x2
   10 models. In the mean time I have learned that there are at least 3
   models of the HP x2 10 models:

   Bay Trail SoC + AXP288 PMIC
   Cherry Trail SoC + AXP288 PMIC
   Cherry Trail SoC + TI PMIC

   And this quirk's DMI matches only match the Cherry Trail SoC + TI PMIC
   SoC, which is good because we want a slightly different quirk for the
   others. This commit updates the comment to make it clear that the quirk
   is only for the Cherry Trail SoC + TI PMIC models.

2) The comment says that it is ok to disable wakeup on all ACPI GPIO event
   handlers, because there is only the one for the embedded-controller
   events. This is not true, there also is a handler for the special
   INT0002 device which is related to USB wakeups. We need to also disable
   wakeups on that one because the device turns of the USB-keyboard built
   into the dock when closing the lid. The XHCI controller takes a while
   to notice this, so it only notices it when already suspended, causing
   a spurious wakeup because of this. So disabling wakeup on all handlers
   is the right thing to do, but not because there only is the one handler
   for the EC events. This commit updates the comment to correctly reflect
   this.

Fixes: aa23ca3d98f7 ("gpiolib: acpi: Add honor_wakeup module-option + quirk mechanism")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20200302111225.6641-1-hdegoede@redhat.com
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpiolib-acpi.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -1299,12 +1299,14 @@ static const struct dmi_system_id gpioli
 	},
 	{
 		/*
-		 * Various HP X2 10 Cherry Trail models use an external
-		 * embedded-controller connected via I2C + an ACPI GPIO
-		 * event handler. The embedded controller generates various
-		 * spurious wakeup events when suspended. So disable wakeup
-		 * for its handler (it uses the only ACPI GPIO event handler).
-		 * This breaks wakeup when opening the lid, the user needs
+		 * HP X2 10 models with Cherry Trail SoC + TI PMIC use an
+		 * external embedded-controller connected via I2C + an ACPI GPIO
+		 * event handler on INT33FF:01 pin 0, causing spurious wakeups.
+		 * When suspending by closing the LID, the power to the USB
+		 * keyboard is turned off, causing INT0002 ACPI events to
+		 * trigger once the XHCI controller notices the keyboard is
+		 * gone. So INT0002 events cause spurious wakeups too. Ignoring
+		 * EC wakes breaks wakeup when opening the lid, the user needs
 		 * to press the power-button to wakeup the system. The
 		 * alternative is suspend simply not working, which is worse.
 		 */


