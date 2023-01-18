Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B455672AFE
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 23:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjARWCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 17:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjARWBu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 17:01:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E41410A8F;
        Wed, 18 Jan 2023 14:01:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ABEB61A73;
        Wed, 18 Jan 2023 22:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947E7C433F2;
        Wed, 18 Jan 2023 22:01:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1pIGV8-002H9N-1U;
        Wed, 18 Jan 2023 17:01:46 -0500
Message-ID: <20230118220146.327085542@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 18 Jan 2023 16:54:36 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     "John Warthog9 Hawley" <warthog9@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org
Subject: [for-linus][PATCH 1/3] ktest.pl: Fix missing "end_monitor" when machine check fails
References: <20230118215435.016435760@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

In the "reboot" command, it does a check of the machine to see if it is
still alive with a simple "ssh echo" command. If it fails, it will assume
that a normal "ssh reboot" is not possible and force a power cycle.

In this case, the "start_monitor" is executed, but the "end_monitor" is
not, and this causes the screen will not be given back to the console. That
is, after the test, a "reset" command needs to be performed, as "echo" is
turned off.

Cc: stable@vger.kernel.org
Fixes: 6474ace999edd ("ktest.pl: Powercycle the box on reboot if no connection can be made")
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 6f9fff88cedf..f2f48ce6ac4d 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1499,7 +1499,8 @@ sub reboot {
 
 	# Still need to wait for the reboot to finish
 	wait_for_monitor($time, $reboot_success_line);
-
+    }
+    if ($powercycle || $time) {
 	end_monitor;
     }
 }
-- 
2.39.0


