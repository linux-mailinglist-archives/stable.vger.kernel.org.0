Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C55C39B7E3
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 13:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbhFDLaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 07:30:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229958AbhFDLaM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Jun 2021 07:30:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE806613FE;
        Fri,  4 Jun 2021 11:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622806106;
        bh=o0ag+xaQAEf7n9ekOC+Ie1d8xQ/3xVEadVvmSldKbVo=;
        h=Subject:To:From:Date:From;
        b=DIeKeqNMdd1Jwnk1tWgKUl80+6/5sP1YGhefJuBroqNmfnurQoV6+dFiZMa4S1YVy
         qR6lEd36RWPPnlmX9EqycYZhGnWJ2CnD4v4t/O22BPNS/nWTrtZ1UOpNlZdKxFlvPi
         rgZBW96nUh3fP2HCwQ4/YgOIt6Jzd21cBGqk+m/E=
Subject: patch "usb: typec: tcpm: cancel frs hrtimer when unregister tcpm port" added to usb-linus
To:     jun.li@nxp.com, gregkh@linuxfoundation.org, linux@roeck-us.net,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Jun 2021 13:28:15 +0200
Message-ID: <1622806095133183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpm: cancel frs hrtimer when unregister tcpm port

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7ade4805e296c8d1e40c842395bbe478c7210555 Mon Sep 17 00:00:00 2001
From: Li Jun <jun.li@nxp.com>
Date: Wed, 2 Jun 2021 17:57:08 +0800
Subject: usb: typec: tcpm: cancel frs hrtimer when unregister tcpm port

Like the state_machine_timer, we should also cancel possible pending
frs hrtimer when unregister tcpm port.

Fixes: 8dc4bd073663 ("usb: typec: tcpm: Add support for Sink Fast Role SWAP(FRS)")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Li Jun <jun.li@nxp.com>
Link: https://lore.kernel.org/r/1622627829-11070-2-git-send-email-jun.li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 7ca452016e03..a1382e878127 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -6335,6 +6335,7 @@ void tcpm_unregister_port(struct tcpm_port *port)
 {
 	int i;
 
+	hrtimer_cancel(&port->enable_frs_timer);
 	hrtimer_cancel(&port->vdm_state_machine_timer);
 	hrtimer_cancel(&port->state_machine_timer);
 
-- 
2.31.1


