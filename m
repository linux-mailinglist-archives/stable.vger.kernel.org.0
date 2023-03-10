Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42046B4605
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbjCJOjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232744AbjCJOjO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:39:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC77FCF8E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:39:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F44BB822DC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83CDC4339E;
        Fri, 10 Mar 2023 14:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459148;
        bh=Tc6CTfEQ0DQjAj8i0YMzN7GJ8aKJVVBA4hVfR5wTpws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gaHVq/66v2MdF38ZlYnLSnvY1OjpL9FXcyVBLmCvUns32v1Mk8jkyMcWiGmRZRFw4
         zUYSOEWszyLpERXfEYKyUFQJffWWi+/VKt3JoqtyDy9ZoX7rrL0Bqml4tBqv5XeYyd
         QFTz8eGS6jxQ9adRJ47xra+SvqBZJp+SFDelc2JI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.4 265/357] ktest.pl: Give back console on Ctrt^C on monitor
Date:   Fri, 10 Mar 2023 14:39:14 +0100
Message-Id: <20230310133746.428838343@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

commit 83d29d439cd3ef23041570d55841f814af2ecac0 upstream.

When monitoring the console output, the stdout is being redirected to do
so. If Ctrl^C is hit during this mode, the stdout is not back to the
console, the user does not see anything they type (no echo).

Add "end_monitor" to the SIGINT interrupt handler to give back the console
on Ctrl^C.

Cc: stable@vger.kernel.org
Fixes: 9f2cdcbbb90e7 ("ktest: Give console process a dedicated tty")
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/ktest/ktest.pl |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -4228,6 +4228,9 @@ sub send_email {
 }
 
 sub cancel_test {
+    if ($monitor_cnt) {
+	end_monitor;
+    }
     if ($email_when_canceled) {
 	my $name = get_test_name;
         send_email("KTEST: Your [$name] test was cancelled",


