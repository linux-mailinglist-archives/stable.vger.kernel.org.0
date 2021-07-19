Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765023CD9A8
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244860AbhGSObM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:31:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244999AbhGSOaM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:30:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D165E6008E;
        Mon, 19 Jul 2021 15:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707451;
        bh=DicTgpPqhZr/i6spxuOj5ERWvvj9fiLdAcdUwi3iu88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ApHZTcK4MWrKtWq84BDWAQpzQw/KK8CsozOIzDEHk8I5byB6QyIVUJCM9Kdi/Kxuo
         TIDN75DKxmGf5iKSR5QRgU3UF9tpjetujaEGdBJBbccoDRa/Yuh9rB3G1hxHyJqd/3
         HrdFB0Fw9MZyKl/s6shA+8y8ITgS144Vabyl/il0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Pavlu <petr.pavlu@suse.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 4.9 168/245] ipmi/watchdog: Stop watchdog timer when the current action is none
Date:   Mon, 19 Jul 2021 16:51:50 +0200
Message-Id: <20210719144945.836083769@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Pavlu <petr.pavlu@suse.com>

commit 2253042d86f57d90a621ac2513a7a7a13afcf809 upstream.

When an IPMI watchdog timer is being stopped in ipmi_close() or
ipmi_ioctl(WDIOS_DISABLECARD), the current watchdog action is updated to
WDOG_TIMEOUT_NONE and _ipmi_set_timeout(IPMI_SET_TIMEOUT_NO_HB) is called
to install this action. The latter function ends up invoking
__ipmi_set_timeout() which makes the actual 'Set Watchdog Timer' IPMI
request.

For IPMI 1.0, this operation results in fully stopping the watchdog timer.
For IPMI >= 1.5, function __ipmi_set_timeout() always specifies the "don't
stop" flag in the prepared 'Set Watchdog Timer' IPMI request. This causes
that the watchdog timer has its action correctly updated to 'none' but the
timer continues to run. A problem is that IPMI firmware can then still log
an expiration event when the configured timeout is reached, which is
unexpected because the watchdog timer was requested to be stopped.

The patch fixes this problem by not setting the "don't stop" flag in
__ipmi_set_timeout() when the current action is WDOG_TIMEOUT_NONE which
results in stopping the watchdog timer. This makes the behaviour for
IPMI >= 1.5 consistent with IPMI 1.0. It also matches the logic in
__ipmi_heartbeat() which does not allow to reset the watchdog if the
current action is WDOG_TIMEOUT_NONE as that would start the timer.

Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Message-Id: <10a41bdc-9c99-089c-8d89-fa98ce5ea080@suse.com>
Cc: stable@vger.kernel.org
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/ipmi/ipmi_watchdog.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -393,16 +393,18 @@ static int i_ipmi_set_timeout(struct ipm
 	data[0] = 0;
 	WDOG_SET_TIMER_USE(data[0], WDOG_TIMER_USE_SMS_OS);
 
-	if ((ipmi_version_major > 1)
-	    || ((ipmi_version_major == 1) && (ipmi_version_minor >= 5))) {
-		/* This is an IPMI 1.5-only feature. */
-		data[0] |= WDOG_DONT_STOP_ON_SET;
-	} else if (ipmi_watchdog_state != WDOG_TIMEOUT_NONE) {
-		/*
-		 * In ipmi 1.0, setting the timer stops the watchdog, we
-		 * need to start it back up again.
-		 */
-		hbnow = 1;
+	if (ipmi_watchdog_state != WDOG_TIMEOUT_NONE) {
+		if ((ipmi_version_major > 1) ||
+		    ((ipmi_version_major == 1) && (ipmi_version_minor >= 5))) {
+			/* This is an IPMI 1.5-only feature. */
+			data[0] |= WDOG_DONT_STOP_ON_SET;
+		} else {
+			/*
+			 * In ipmi 1.0, setting the timer stops the watchdog, we
+			 * need to start it back up again.
+			 */
+			hbnow = 1;
+		}
 	}
 
 	data[1] = 0;


