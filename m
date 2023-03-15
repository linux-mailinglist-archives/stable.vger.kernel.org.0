Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F356BB138
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbjCOMZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbjCOMZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:25:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842F920062
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:24:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34A3E61D40
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498DEC433D2;
        Wed, 15 Mar 2023 12:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883066;
        bh=fofk8WbNwivuE0yeM3/KGpRswEl75MIfJGBz0O1B1Q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BsFhCeolE1DpGhh8pGylmG0e34A5AyuIpAuVWeQxP5K99y3tOAglECztFzIZLnCYx
         51n9+6hMKAU7sChsYPOhQSyjl9x+jUgQ5SrIYEqhR2S16CPMY2mVunF+ZWMabcIDBv
         WeOC6qTi8AnJjERj76WHaE6QySFx+B3f7PlEK6OA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anton Lundin <glance@acc.umu.se>,
        Corey Minyard <cminyard@mvista.com>, Stable@vger.kernel.org
Subject: [PATCH 5.10 078/104] ipmi:watchdog: Set panic count to proper value on a panic
Date:   Wed, 15 Mar 2023 13:12:49 +0100
Message-Id: <20230315115735.181500106@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
@@ -503,7 +503,7 @@ static void panic_halt_ipmi_heartbeat(vo
 	msg.cmd = IPMI_WDOG_RESET_TIMER;
 	msg.data = NULL;
 	msg.data_len = 0;
-	atomic_inc(&panic_done_count);
+	atomic_add(2, &panic_done_count);
 	rv = ipmi_request_supply_msgs(watchdog_user,
 				      (struct ipmi_addr *) &addr,
 				      0,
@@ -513,7 +513,7 @@ static void panic_halt_ipmi_heartbeat(vo
 				      &panic_halt_heartbeat_recv_msg,
 				      1);
 	if (rv)
-		atomic_dec(&panic_done_count);
+		atomic_sub(2, &panic_done_count);
 }
 
 static struct ipmi_smi_msg panic_halt_smi_msg = {
@@ -537,12 +537,12 @@ static void panic_halt_ipmi_set_timeout(
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


