Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562BB6BB148
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbjCOM0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232419AbjCOMZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:25:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A26995E1E
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:25:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CE4BB81E00
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D19FC4339B;
        Wed, 15 Mar 2023 12:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883063;
        bh=aVML3pMDl4ESDl+Gwg36VjcT1n2pphXNmuxRN3eqICA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G3zD18YsN2M4SIOsaK4vP3wJuPD+REkT/NgvtF9n3Jl7M2DKlajoLVf+7o1jtX+A1
         h270xE6TyuLj90Sszhm/pD1SN8oBXYagK/lr/kT6WR59UiZ7xPADe3Z/H6zQpKCJQQ
         MKCr7H0JRsLlcaKTTXImoYZEO2kJrcQlAYOvxNak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yejune Deng <yejune.deng@gmail.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 5.10 077/104] ipmi/watchdog: replace atomic_add() and atomic_sub()
Date:   Wed, 15 Mar 2023 13:12:48 +0100
Message-Id: <20230315115735.142991661@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
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
@@ -503,7 +503,7 @@ static void panic_halt_ipmi_heartbeat(vo
 	msg.cmd = IPMI_WDOG_RESET_TIMER;
 	msg.data = NULL;
 	msg.data_len = 0;
-	atomic_add(1, &panic_done_count);
+	atomic_inc(&panic_done_count);
 	rv = ipmi_request_supply_msgs(watchdog_user,
 				      (struct ipmi_addr *) &addr,
 				      0,
@@ -513,7 +513,7 @@ static void panic_halt_ipmi_heartbeat(vo
 				      &panic_halt_heartbeat_recv_msg,
 				      1);
 	if (rv)
-		atomic_sub(1, &panic_done_count);
+		atomic_dec(&panic_done_count);
 }
 
 static struct ipmi_smi_msg panic_halt_smi_msg = {
@@ -537,12 +537,12 @@ static void panic_halt_ipmi_set_timeout(
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


