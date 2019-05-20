Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 835BD23633
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389707AbfETM2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:28:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389099AbfETM2f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:28:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9481B216C4;
        Mon, 20 May 2019 12:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355315;
        bh=iR/CRwxw8Y9GNxIe6y43msCHgJFVvMtFrS9EgdCBTTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LrLoHtowAeggcW71vR5EvulvLIY/xQ02XIktRsA7ZsTYlNi/tn2J81Lyi3K8qyR6P
         D1OOHDF6TBHPJCeAz/yy2GL1r/PaXBTNuh8nAcd5fAXXKpxOPyr6uqtnDnb8CIwp2C
         aoz/RqKp6LTcV+yCP48vm40eAgpUIuxlO0TRylOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rajat Jain <rajatja@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.0 073/123] ACPI: PM: Set enable_for_wake for wakeup GPEs during suspend-to-idle
Date:   Mon, 20 May 2019 14:14:13 +0200
Message-Id: <20190520115249.698856898@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rajat Jain <rajatja@google.com>

commit 2f844b61db8297a1f7a06adf2eb5c43381f2c183 upstream.

I noticed that recently multiple systems (chromebooks) couldn't wake
from S0ix using LID or Keyboard after updating to a newer kernel. I
bisected and it turned up commit f941d3e41da7 ("ACPI: EC / PM: Disable
non-wakeup GPEs for suspend-to-idle"). I checked that the issue got
fixed if that commit was reverted.

I debugged and found that although PNP0C0D:00 (representing the LID)
is wake capable and should wakeup the system per the code in
acpi_wakeup_gpe_init() and in drivers/acpi/button.c:

localhost /sys # cat /proc/acpi/wakeup
Device  S-state   Status   Sysfs node
LID0      S4    *enabled   platform:PNP0C0D:00
CREC      S5    *disabled  platform:GOOG0004:00
                *disabled  platform:cros-ec-dev.1.auto
                *disabled  platform:cros-ec-accel.0
                *disabled  platform:cros-ec-accel.1
                *disabled  platform:cros-ec-gyro.0
                *disabled  platform:cros-ec-ring.0
                *disabled  platform:cros-usbpd-charger.2.auto
                *disabled  platform:cros-usbpd-logger.3.auto
D015      S3    *enabled   i2c:i2c-ELAN0000:00
PENH      S3    *enabled   platform:PRP0001:00
XHCI      S3    *enabled   pci:0000:00:14.0
GLAN      S4    *disabled
WIFI      S3    *disabled  pci:0000:00:14.3
localhost /sys #

On debugging, I found that its corresponding GPE is not being enabled.
The particular GPE's "gpe_register_info->enable_for_wake" does not
have any bits set when acpi_enable_all_wakeup_gpes() comes around to
use it. I looked at code and could not find any other code path that
should set the bits in "enable_for_wake" bitmask for the wake enabled
devices for s2idle.  [I do see that it happens for S3 in
acpi_sleep_prepare()].

Thus I used the same call to enable the GPEs for wake enabled devices,
and verified that this fixes the regression I was seeing on multiple
of my devices.

[ rjw: The problem is that commit f941d3e41da7 ("ACPI: EC / PM:
  Disable non-wakeup GPEs for suspend-to-idle") forgot to add
  the acpi_enable_wakeup_devices() call for s2idle along with
  acpi_enable_all_wakeup_gpes(). ]

Fixes: f941d3e41da7 ("ACPI: EC / PM: Disable non-wakeup GPEs for suspend-to-idle")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=203579
Signed-off-by: Rajat Jain <rajatja@google.com>
[ rjw: Subject & changelog ]
Cc: 5.0+ <stable@vger.kernel.org> # 5.0+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/sleep.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -977,6 +977,8 @@ static int acpi_s2idle_prepare(void)
 	if (acpi_sci_irq_valid())
 		enable_irq_wake(acpi_sci_irq);
 
+	acpi_enable_wakeup_devices(ACPI_STATE_S0);
+
 	/* Change the configuration of GPEs to avoid spurious wakeup. */
 	acpi_enable_all_wakeup_gpes();
 	acpi_os_wait_events_complete();
@@ -1027,6 +1029,8 @@ static void acpi_s2idle_restore(void)
 {
 	acpi_enable_all_runtime_gpes();
 
+	acpi_disable_wakeup_devices(ACPI_STATE_S0);
+
 	if (acpi_sci_irq_valid())
 		disable_irq_wake(acpi_sci_irq);
 


