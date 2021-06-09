Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D260F3A0F02
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 10:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237819AbhFIIyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 04:54:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237807AbhFIIyW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 04:54:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFECD61263;
        Wed,  9 Jun 2021 08:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623228748;
        bh=Z8wCLmYnd4ndL+wBiKq2/4RoK20g/jfGN0eE9LM/37o=;
        h=Subject:To:From:Date:From;
        b=DgPo2ldD32Wrrb0RMwy2SRxBnR+kT08hdhl4AxhhKX+SyxlUi9mx0Lqn18ty2TWcC
         uf6ASuCw5gQT+MrWNFjwyXv7ZMHkCWgGdtB19h39KhbjP6MonvMB1f3c2ducuRBs3v
         EJS3hBa+8QaYp8r2ooCm4puZPs9z94fAky+a/nyo=
Subject: patch "usb: typec: tcpm: Do not finish VDM AMS for retrying Responses" added to usb-linus
To:     kyletso@google.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Jun 2021 10:52:25 +0200
Message-ID: <16232287458213@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpm: Do not finish VDM AMS for retrying Responses

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5ab14ab1f2db24ffae6c5c39a689660486962e6e Mon Sep 17 00:00:00 2001
From: Kyle Tso <kyletso@google.com>
Date: Sun, 6 Jun 2021 16:14:52 +0800
Subject: usb: typec: tcpm: Do not finish VDM AMS for retrying Responses

If the VDM responses couldn't be sent successfully, it doesn't need to
finish the AMS until the retry count reaches the limit.

Fixes: 0908c5aca31e ("usb: typec: tcpm: AMS and Collision Avoidance")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Cc: stable <stable@vger.kernel.org>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Kyle Tso <kyletso@google.com>
Link: https://lore.kernel.org/r/20210606081452.764032-1-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index a7c336f56849..63470cf7f4cd 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1942,6 +1942,9 @@ static void vdm_run_state_machine(struct tcpm_port *port)
 			tcpm_log(port, "VDM Tx error, retry");
 			port->vdm_retries++;
 			port->vdm_state = VDM_STATE_READY;
+			if (PD_VDO_SVDM(vdo_hdr) && PD_VDO_CMDT(vdo_hdr) == CMDT_INIT)
+				tcpm_ams_finish(port);
+		} else {
 			tcpm_ams_finish(port);
 		}
 		break;
-- 
2.32.0


