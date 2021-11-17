Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA16545481C
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 15:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbhKQOHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 09:07:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:60734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229678AbhKQOHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 09:07:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7D2D61B54;
        Wed, 17 Nov 2021 14:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637157882;
        bh=+44Vx/6vRRhLMLC4OuuokDZ7knvyAyhsvCdDjosUA7s=;
        h=Subject:To:From:Date:From;
        b=GEEesFjuGFEFYPqIthOUML9owT1b1pl5ZP3Piu241xn2AaMxxp7s6GCapyr8Gl+TS
         wis7fKahp5+qxJ1bLKM/ED+rway6jD7uaAa4U4iVVluF5ynvc/qn2OCLkC9s0eZyLk
         YyVRLxYIEEKgWZLg3utdh7DaysyMSWYMFhkqJ3xA=
Subject: patch "usb: typec: fusb302: Fix masking of comparator and bc_lvl interrupts" added to usb-linus
To:     megous@megous.com, gregkh@linuxfoundation.org, hdegoede@redhat.com,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 17 Nov 2021 15:04:29 +0100
Message-ID: <16371578697371@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: fusb302: Fix masking of comparator and bc_lvl interrupts

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 362468830dd5bea8bf6ad5203b2ea61f8a4e8288 Mon Sep 17 00:00:00 2001
From: Ondrej Jirman <megous@megous.com>
Date: Mon, 8 Nov 2021 11:28:32 +0100
Subject: usb: typec: fusb302: Fix masking of comparator and bc_lvl interrupts

The code that enables either BC_LVL or COMP_CHNG interrupt in tcpm_set_cc
wrongly assumes that the interrupt is unmasked by writing 1 to the apropriate
bit in the mask register. In fact, interrupts are enabled when the mask
is 0, so the tcpm_set_cc enables interrupt for COMP_CHNG when it expects
BC_LVL interrupt to be enabled.

This causes inability of the driver to recognize cable unplug events
in host mode (unplug is recognized only via a COMP_CHNG interrupt).

In device mode this bug was masked by simultaneous triggering of the VBUS
change interrupt, because of loss of VBUS when the port peer is providing
power.

Fixes: 48242e30532b ("usb: typec: fusb302: Revert "Resolve fixed power role contract setup"")
Cc: stable <stable@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Ondrej Jirman <megous@megous.com>
Link: https://lore.kernel.org/r/20211108102833.2793803-1-megous@megous.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/fusb302.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/tcpm/fusb302.c b/drivers/usb/typec/tcpm/fusb302.c
index 7a2a17866a82..72f9001b0792 100644
--- a/drivers/usb/typec/tcpm/fusb302.c
+++ b/drivers/usb/typec/tcpm/fusb302.c
@@ -669,25 +669,27 @@ static int tcpm_set_cc(struct tcpc_dev *dev, enum typec_cc_status cc)
 		ret = fusb302_i2c_mask_write(chip, FUSB_REG_MASK,
 					     FUSB_REG_MASK_BC_LVL |
 					     FUSB_REG_MASK_COMP_CHNG,
-					     FUSB_REG_MASK_COMP_CHNG);
+					     FUSB_REG_MASK_BC_LVL);
 		if (ret < 0) {
 			fusb302_log(chip, "cannot set SRC interrupt, ret=%d",
 				    ret);
 			goto done;
 		}
 		chip->intr_comp_chng = true;
+		chip->intr_bc_lvl = false;
 		break;
 	case TYPEC_CC_RD:
 		ret = fusb302_i2c_mask_write(chip, FUSB_REG_MASK,
 					     FUSB_REG_MASK_BC_LVL |
 					     FUSB_REG_MASK_COMP_CHNG,
-					     FUSB_REG_MASK_BC_LVL);
+					     FUSB_REG_MASK_COMP_CHNG);
 		if (ret < 0) {
 			fusb302_log(chip, "cannot set SRC interrupt, ret=%d",
 				    ret);
 			goto done;
 		}
 		chip->intr_bc_lvl = true;
+		chip->intr_comp_chng = false;
 		break;
 	default:
 		break;
-- 
2.34.0


