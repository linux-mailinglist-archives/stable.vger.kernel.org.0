Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D45345251F
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344492AbhKPBqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:46:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:36924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241936AbhKOSZx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:25:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B83E96332F;
        Mon, 15 Nov 2021 17:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999000;
        bh=vsF4fAH+G17NUr2Ci7d8v21vjL/lDVS3kInc5+yF8v0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FxNXgpKCnlGwYacI1bgzH/fRkFbmBl62dh0fGT9AMDY8KarDRD8mOgzQiKxdrmJ3y
         TN56adC/ZZIwo+nU9tXKfLoycZ4/eAvMNp/YRyi8Cps+3CwEz3kqVeIXDMkITnL3Rr
         BElTjEOWHM/+KZzbQTIq3bQJZ6DnSMpcBDeBS1W0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Lundin <glance@acc.umu.se>,
        Corey Minyard <cminyard@mvista.com>, Stable@vger.kernel.org
Subject: [PATCH 5.14 106/849] ipmi:watchdog: Set panic count to proper value on a panic
Date:   Mon, 15 Nov 2021 17:53:09 +0100
Message-Id: <20211115165423.663364312@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

commit db05ddf7f321634c5659a0cf7ea56594e22365f7 upstream.

You will get two decrements when the messages on a panic are sent, not
one, since commit 2033f6858970 ("ipmi: Free receive messages when in an
oops") was added, but the watchdog code had a bug where it didn't set
the value properly.

Reported-by: Anton Lundin <glance@acc.umu.se>
Cc: <Stable@vger.kernel.org> # v5.4+
Fixes: 2033f6858970 ("ipmi: Free receive messages when in an oops")
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_watchdog.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -497,7 +497,7 @@ static void panic_halt_ipmi_heartbeat(vo
 	msg.cmd = IPMI_WDOG_RESET_TIMER;
 	msg.data = NULL;
 	msg.data_len = 0;
-	atomic_inc(&panic_done_count);
+	atomic_add(2, &panic_done_count);
 	rv = ipmi_request_supply_msgs(watchdog_user,
 				      (struct ipmi_addr *) &addr,
 				      0,
@@ -507,7 +507,7 @@ static void panic_halt_ipmi_heartbeat(vo
 				      &panic_halt_heartbeat_recv_msg,
 				      1);
 	if (rv)
-		atomic_dec(&panic_done_count);
+		atomic_sub(2, &panic_done_count);
 }
 
 static struct ipmi_smi_msg panic_halt_smi_msg = {
@@ -531,12 +531,12 @@ static void panic_halt_ipmi_set_timeout(
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


