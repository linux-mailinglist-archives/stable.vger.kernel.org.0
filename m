Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B110E6BB09B
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbjCOMT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbjCOMTY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:19:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E87F8537D
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:19:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD66E61D49
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE01EC4339E;
        Wed, 15 Mar 2023 12:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882754;
        bh=UNqsdVMuA2k1tXuQreZiMBgpJvqQNmQocmfGl698lms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dv10O/CN6esfOTRJ8lnWmKappwCISLf8ztDmhzelrgvFii1WPw1MRtcvvCfI0mDq3
         4VkQohQpOXQ7R4+X77hZiKt7JeQVD0THf4UcfLokEDGcOlM3FRCfNfY+ZwE+aKMKFc
         liVF+MqZYxs1cee3ZAG0CoVnSdutXhy/HnW0kEaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yejune Deng <yejune.deng@gmail.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 5.4 58/68] ipmi/watchdog: replace atomic_add() and atomic_sub()
Date:   Wed, 15 Mar 2023 13:12:52 +0100
Message-Id: <20230315115728.377553139@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yejune Deng <yejune.deng@gmail.com>

commit a01a89b1db1066a6af23ae08b9a0c345b7966f0b upstream.

atomic_inc() and atomic_dec() looks better

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
Message-Id: <1605511807-7135-1-git-send-email-yejune.deng@gmail.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_watchdog.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -498,7 +498,7 @@ static void panic_halt_ipmi_heartbeat(vo
 	msg.cmd = IPMI_WDOG_RESET_TIMER;
 	msg.data = NULL;
 	msg.data_len = 0;
-	atomic_add(1, &panic_done_count);
+	atomic_inc(&panic_done_count);
 	rv = ipmi_request_supply_msgs(watchdog_user,
 				      (struct ipmi_addr *) &addr,
 				      0,
@@ -508,7 +508,7 @@ static void panic_halt_ipmi_heartbeat(vo
 				      &panic_halt_heartbeat_recv_msg,
 				      1);
 	if (rv)
-		atomic_sub(1, &panic_done_count);
+		atomic_dec(&panic_done_count);
 }
 
 static struct ipmi_smi_msg panic_halt_smi_msg = {
@@ -532,12 +532,12 @@ static void panic_halt_ipmi_set_timeout(
 	/* Wait for the messages to be free. */
 	while (atomic_read(&panic_done_count) != 0)
 		ipmi_poll_interface(watchdog_user);
-	atomic_add(1, &panic_done_count);
+	atomic_inc(&panic_done_count);
 	rv = __ipmi_set_timeout(&panic_halt_smi_msg,
 				&panic_halt_recv_msg,
 				&send_heartbeat_now);
 	if (rv) {
-		atomic_sub(1, &panic_done_count);
+		atomic_dec(&panic_done_count);
 		pr_warn("Unable to extend the watchdog timeout\n");
 	} else {
 		if (send_heartbeat_now)


