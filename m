Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE49DC094
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 11:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406672AbfJRJIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 05:08:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7462 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406023AbfJRJIs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 05:08:48 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B89E6C057F2C;
        Fri, 18 Oct 2019 09:08:47 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-117-168.ams2.redhat.com [10.36.117.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D73560BF1;
        Fri, 18 Oct 2019 09:08:44 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-gpio@vger.kernel.org,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] pinctrl: cherryview: Fix irq_valid_mask calculation
Date:   Fri, 18 Oct 2019 11:08:42 +0200
Message-Id: <20191018090842.11189-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 18 Oct 2019 09:08:47 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 03c4749dd6c7 ("gpio / ACPI: Drop unnecessary ACPI GPIO to Linux
GPIO translation") has made the cherryview gpio numbers sparse, to get
a 1:1 mapping between ACPI pin numbers and gpio numbers in Linux.

This has greatly simplified things, but the code setting the
irq_valid_mask was not updated for this, so the valid mask is still in
the old "compressed" numbering with the gaps in the pin numbers skipped,
which is wrong as irq_valid_mask needs to be expressed in gpio numbers.

This results in the following error on devices using pin 24 (0x0018) on
the north GPIO controller as an ACPI event source:

[    0.422452] cherryview-pinctrl INT33FF:01: Failed to translate GPIO to IRQ

This has been reported (by email) to be happening on a Caterpillar CAT T20
tablet and I've reproduced this myself on a Medion Akoya e2215t 2-in-1.

This commit uses the pin number instead of the compressed index into
community->pins to clear the correct bits in irq_valid_mask for GPIOs
using GPEs for interrupts, fixing these errors and in case of the
Medion Akoya e2215t also fixing the LID switch not working.

Cc: stable@vger.kernel.org
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Fixes: 03c4749dd6c7 ("gpio / ACPI: Drop unnecessary ACPI GPIO to Linux GPIO translation")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/pinctrl/intel/pinctrl-cherryview.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/intel/pinctrl-cherryview.c b/drivers/pinctrl/intel/pinctrl-cherryview.c
index aae51c507f59..02ff5e8b0510 100644
--- a/drivers/pinctrl/intel/pinctrl-cherryview.c
+++ b/drivers/pinctrl/intel/pinctrl-cherryview.c
@@ -1563,7 +1563,7 @@ static void chv_init_irq_valid_mask(struct gpio_chip *chip,
 		intsel >>= CHV_PADCTRL0_INTSEL_SHIFT;
 
 		if (intsel >= community->nirqs)
-			clear_bit(i, valid_mask);
+			clear_bit(desc->number, valid_mask);
 	}
 }
 
-- 
2.23.0

