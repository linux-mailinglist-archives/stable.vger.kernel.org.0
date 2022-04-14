Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995F6501381
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345705AbiDNODn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346205AbiDNN4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:56:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D1159A57;
        Thu, 14 Apr 2022 06:46:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2C7A61D7E;
        Thu, 14 Apr 2022 13:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1029DC385A5;
        Thu, 14 Apr 2022 13:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943956;
        bh=BBGt+GgEpJktuRha/6PB6GGM4VbMgSz88KLc5ZHLTZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J3MfoDfI9MfdrpE0IWEaiZofwk0mleFqJ7Kf0T/AdJLFPbH8lj0+JHo2INola+E0m
         3PjAnpORiLwzsBgE85NoIc77YH8Bf5HZRJ/H1tbuYQyUJ/dGE3+AikAvf0w6h9V8wT
         DNGXRGYb0ZMUGMvApoWCinPwCYwchClcY+pakngE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.4 341/475] rtc: check if __rtc_read_time was successful
Date:   Thu, 14 Apr 2022 15:12:06 +0200
Message-Id: <20220414110904.626066723@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Tom Rix <trix@redhat.com>

commit 915593a7a663b2ad08b895a5f3ba8b19d89d4ebf upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/interface.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -793,9 +793,13 @@ static int rtc_timer_enqueue(struct rtc_
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
@@ -809,7 +813,6 @@ static int rtc_timer_enqueue(struct rtc_
 	trace_rtc_timer_enqueue(timer);
 	if (!next || ktime_before(timer->node.expires, next->expires)) {
 		struct rtc_wkalrm alarm;
-		int err;
 
 		alarm.time = rtc_ktime_to_tm(timer->node.expires);
 		alarm.enabled = 1;


