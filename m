Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAD0122137
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 02:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbfLQBBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 20:01:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34482 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726383AbfLQAva (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:30 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15D-0003IP-TP; Tue, 17 Dec 2019 00:51:27 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15D-0005RT-2g; Tue, 17 Dec 2019 00:51:27 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Preeti U Murthy" <preeti@linux.vnet.ibm.com>,
        "Andreas Sandberg" <andreas.sandberg@arm.com>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date:   Tue, 17 Dec 2019 00:45:37 +0000
Message-ID: <lsq.1576543535.759354087@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 003/136] tick: hrtimer-broadcast: Prevent endless
 restarting when broadcast device is unused
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Sandberg <andreas.sandberg@arm.com>

commit 38d23a6cc16c02f7b0c920266053f340b5601735 upstream.

The hrtimer callback in the hrtimer's tick broadcast code sometimes
incorrectly ends up scheduling events at the current tick causing the
kernel to hang servicing the same hrtimer forever. This typically
happens when a device is swapped out by
tick_install_broadcast_device(), which replaces the event handler with
clock_events_handle_noop() and sets the device mode to
CLOCK_EVT_MODE_UNUSED. If the timer is scheduled when this happens,
the next_event field will not be updated and the hrtimer ends up being
restarted at the current tick. To prevent this from happening, only
try to restart the hrtimer if the broadcast clock event device is in
one of the active modes and try to cancel the timer when entering the
CLOCK_EVT_MODE_UNUSED mode.

Signed-off-by: Andreas Sandberg <andreas.sandberg@arm.com>
Tested-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1429880765-5558-1-git-send-email-andreas.sandberg@arm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 3.16 as dependency of commit b9023b91dd02
 "tick: broadcast-hrtimer: Fix a race in bc_set_next"]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/time/tick-broadcast-hrtimer.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/kernel/time/tick-broadcast-hrtimer.c
+++ b/kernel/time/tick-broadcast-hrtimer.c
@@ -22,6 +22,7 @@ static void bc_set_mode(enum clock_event
 			struct clock_event_device *bc)
 {
 	switch (mode) {
+	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
 		/*
 		 * Note, we cannot cancel the timer here as we might
@@ -101,10 +102,13 @@ static enum hrtimer_restart bc_handler(s
 {
 	ce_broadcast_hrtimer.event_handler(&ce_broadcast_hrtimer);
 
-	if (ce_broadcast_hrtimer.next_event.tv64 == KTIME_MAX)
+	switch (ce_broadcast_hrtimer.mode) {
+	case CLOCK_EVT_MODE_ONESHOT:
+		if (ce_broadcast_hrtimer.next_event.tv64 != KTIME_MAX)
+			return HRTIMER_RESTART;
+	default:
 		return HRTIMER_NORESTART;
-
-	return HRTIMER_RESTART;
+	}
 }
 
 void tick_setup_hrtimer_broadcast(void)

