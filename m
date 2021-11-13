Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E69244F39A
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 15:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbhKMOTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 09:19:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:42184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232965AbhKMOTi (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sat, 13 Nov 2021 09:19:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2639611AD;
        Sat, 13 Nov 2021 14:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636813006;
        bh=eYGkODpwyB9G6CW/V++h1CJPIOBGZHnoIU1Y9BdAOrM=;
        h=Subject:To:Cc:From:Date:From;
        b=P0IdfpNzW7cuCnXHtfOamdIehlwmWfjBATEmxIEqVU3FSYiWchz9Q+39vPsncok1s
         KvF0x6mTwMpv3kpoUSLtkX764YVOqK344NBZuGt5TKsFX9wkuPdZhiCqwUtny678T9
         B/1xftORITTovO+fbfC/2HnXQoC3uVwNdbELTQE4=
Subject: FAILED: patch "[PATCH] ipmi:watchdog: Set panic count to proper value on a panic" failed to apply to 5.10-stable tree
To:     cminyard@mvista.com, Stable@vger.kernel.org, glance@acc.umu.se
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Nov 2021 15:16:35 +0100
Message-ID: <1636812995166153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From db05ddf7f321634c5659a0cf7ea56594e22365f7 Mon Sep 17 00:00:00 2001
From: Corey Minyard <cminyard@mvista.com>
Date: Mon, 20 Sep 2021 06:25:37 -0500
Subject: [PATCH] ipmi:watchdog: Set panic count to proper value on a panic

You will get two decrements when the messages on a panic are sent, not
one, since commit 2033f6858970 ("ipmi: Free receive messages when in an
oops") was added, but the watchdog code had a bug where it didn't set
the value properly.

Reported-by: Anton Lundin <glance@acc.umu.se>
Cc: <Stable@vger.kernel.org> # v5.4+
Fixes: 2033f6858970 ("ipmi: Free receive messages when in an oops")
Signed-off-by: Corey Minyard <cminyard@mvista.com>

diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index e4ff3b50de7f..f855a9665c28 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -497,7 +497,7 @@ static void panic_halt_ipmi_heartbeat(void)
 	msg.cmd = IPMI_WDOG_RESET_TIMER;
 	msg.data = NULL;
 	msg.data_len = 0;
-	atomic_inc(&panic_done_count);
+	atomic_add(2, &panic_done_count);
 	rv = ipmi_request_supply_msgs(watchdog_user,
 				      (struct ipmi_addr *) &addr,
 				      0,
@@ -507,7 +507,7 @@ static void panic_halt_ipmi_heartbeat(void)
 				      &panic_halt_heartbeat_recv_msg,
 				      1);
 	if (rv)
-		atomic_dec(&panic_done_count);
+		atomic_sub(2, &panic_done_count);
 }
 
 static struct ipmi_smi_msg panic_halt_smi_msg = {
@@ -531,12 +531,12 @@ static void panic_halt_ipmi_set_timeout(void)
 	/* Wait for the messages to be free. */
 	while (atomic_read(&panic_done_count) != 0)
 		ipmi_poll_interface(watchdog_user);
-	atomic_inc(&panic_done_count);
+	atomic_add(2, &panic_done_count);
 	rv = __ipmi_set_timeout(&panic_halt_smi_msg,
 				&panic_halt_recv_msg,
 				&send_heartbeat_now);
 	if (rv) {
-		atomic_dec(&panic_done_count);
+		atomic_sub(2, &panic_done_count);
 		pr_warn("Unable to extend the watchdog timeout\n");
 	} else {
 		if (send_heartbeat_now)

