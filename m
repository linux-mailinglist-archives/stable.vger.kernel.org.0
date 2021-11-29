Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B335B46254D
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbhK2Wht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:37:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232831AbhK2WhZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:37:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92EDDC12BCCA;
        Mon, 29 Nov 2021 10:34:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AEC7B815E9;
        Mon, 29 Nov 2021 18:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778CDC53FD3;
        Mon, 29 Nov 2021 18:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210850;
        bh=DY/D5OjPSLesIzzu7NcFSXYPpT46PKRqNjZB7tofiBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBTnLCLLyZNuq6nqmloCfgtnizcgTnn89MkVMvrKEJO1FFNtsNCEcpYSlbtmvdaqp
         nDopO3M8yo8QN1Nf6Vch+JYppYOyI1l19si8vydJVTqIItFJlmDXoFIaFPBHwqYOTa
         OGmAXfc58hFh4WjTlQyVAa2Z/sXTVuE7fw7qc6b4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Ondrej Jirman <megous@megous.com>
Subject: [PATCH 5.15 017/179] usb: typec: fusb302: Fix masking of comparator and bc_lvl interrupts
Date:   Mon, 29 Nov 2021 19:16:51 +0100
Message-Id: <20211129181719.517492005@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

commit 362468830dd5bea8bf6ad5203b2ea61f8a4e8288 upstream.

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
 drivers/usb/typec/tcpm/fusb302.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/tcpm/fusb302.c
+++ b/drivers/usb/typec/tcpm/fusb302.c
@@ -669,25 +669,27 @@ static int tcpm_set_cc(struct tcpc_dev *
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


