Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A51504F095B
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 14:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240845AbiDCMdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 08:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238694AbiDCMds (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 08:33:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A6D35256
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 05:31:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83FA9B80D32
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 12:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE46C340ED;
        Sun,  3 Apr 2022 12:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648989112;
        bh=bAbskheimy5ULgpDACMPSeUlwXQpf6tKcXIYw5aMT+g=;
        h=Subject:To:Cc:From:Date:From;
        b=c3M5n/eUjM+7b3iZLsPhxlCJzswNhL4phwhRRB5whGISZpCl4vv61XRGbN4xuPCnj
         ncDuN/MU4JtmYZL9bD+3zJoT6ECbeckQGRjvMvWeAzx/NW5Ie1C8F76gLXV/HTfQuH
         OCu8/jEM+2vpC62SxEULcvL8OE34r+bKmt/tgnr8=
Subject: FAILED: patch "[PATCH] rtc: check if __rtc_read_time was successful" failed to apply to 4.9-stable tree
To:     trix@redhat.com, alexandre.belloni@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Apr 2022 14:31:49 +0200
Message-ID: <164898910923771@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 915593a7a663b2ad08b895a5f3ba8b19d89d4ebf Mon Sep 17 00:00:00 2001
From: Tom Rix <trix@redhat.com>
Date: Sat, 26 Mar 2022 12:42:36 -0700
Subject: [PATCH] rtc: check if __rtc_read_time was successful

Clang static analysis reports this issue
interface.c:810:8: warning: Passed-by-value struct
  argument contains uninitialized data
  now = rtc_tm_to_ktime(tm);
      ^~~~~~~~~~~~~~~~~~~

tm is set by a successful call to __rtc_read_time()
but its return status is not checked.  Check if
it was successful before setting the enabled flag.
Move the decl of err to function scope.

Fixes: 2b2f5ff00f63 ("rtc: interface: ignore expired timers when enqueuing new timers")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220326194236.2916310-1-trix@redhat.com

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index d8e835798153..9edd662c69ac 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -804,9 +804,13 @@ static int rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
 	struct timerqueue_node *next = timerqueue_getnext(&rtc->timerqueue);
 	struct rtc_time tm;
 	ktime_t now;
+	int err;
+
+	err = __rtc_read_time(rtc, &tm);
+	if (err)
+		return err;
 
 	timer->enabled = 1;
-	__rtc_read_time(rtc, &tm);
 	now = rtc_tm_to_ktime(tm);
 
 	/* Skip over expired timers */
@@ -820,7 +824,6 @@ static int rtc_timer_enqueue(struct rtc_device *rtc, struct rtc_timer *timer)
 	trace_rtc_timer_enqueue(timer);
 	if (!next || ktime_before(timer->node.expires, next->expires)) {
 		struct rtc_wkalrm alarm;
-		int err;
 
 		alarm.time = rtc_ktime_to_tm(timer->node.expires);
 		alarm.enabled = 1;

