Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35486B9246
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390990AbfITObG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:31:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36914 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388402AbfITOZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:16 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqT-0004y6-Fl; Fri, 20 Sep 2019 15:25:13 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqF-0007u8-0k; Fri, 20 Sep 2019 15:24:59 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Romain Izard" <romain.izard.pro@gmail.com>,
        "Oliver Neukum" <oneukum@suse.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.480153938@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 069/132] usb: cdc-acm: fix race during wakeup
 blocking TX traffic
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Romain Izard <romain.izard.pro@gmail.com>

commit 93e1c8a638308980309e009cc40b5a57ef87caf1 upstream.

When the kernel is compiled with preemption enabled, the URB completion
handler can run in parallel with the work responsible for waking up the
tty layer. If the URB handler sets the EVENT_TTY_WAKEUP bit during the
call to tty_port_tty_wakeup() to signal that there is room for additional
input, it will be cleared at the end of this call. As a result, TX traffic
on the upper layer will be blocked.

This can be seen with a kernel configured with CONFIG_PREEMPT, and a fast
modem connected with PPP running over a USB CDC-ACM port.

Use test_and_clear_bit() instead, which ensures that each wakeup requested
by the URB completion code will trigger a call to tty_port_tty_wakeup().

Fixes: 1aba579f3cf5 cdc-acm: handle read pipe errors
Signed-off-by: Romain Izard <romain.izard.pro@gmail.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-acm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -510,10 +510,8 @@ static void acm_softint(struct work_stru
 		clear_bit(EVENT_RX_STALL, &acm->flags);
 	}
 
-	if (test_bit(EVENT_TTY_WAKEUP, &acm->flags)) {
+	if (test_and_clear_bit(EVENT_TTY_WAKEUP, &acm->flags))
 		tty_port_tty_wakeup(&acm->port);
-		clear_bit(EVENT_TTY_WAKEUP, &acm->flags);
-	}
 }
 
 /*

