Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811474521EF
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376908AbhKPBHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:07:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:44604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245291AbhKOTT6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1591363531;
        Mon, 15 Nov 2021 18:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001121;
        bh=vsF4fAH+G17NUr2Ci7d8v21vjL/lDVS3kInc5+yF8v0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ibOq8CCHePWDBHhhWSBDhvArj8ViJibJ43NeT5zAjdaMAl0XZ2OxMWx9/ZFv4BihH
         iC6yrk1ZvlYsQzU8GRqzOLY5SSyK5JbW0BfwoFxPae7PDwbBs63sSLVt1UI6Eo/Tjm
         +Cu6PaOUEwagGkgKUaFHV7J8xO6ZXVt9V9iyvK1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Lundin <glance@acc.umu.se>,
        Corey Minyard <cminyard@mvista.com>, Stable@vger.kernel.org
Subject: [PATCH 5.15 070/917] ipmi:watchdog: Set panic count to proper value on a panic
Date:   Mon, 15 Nov 2021 17:52:45 +0100
Message-Id: <20211115165431.138824918@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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


