Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D446ADAF8
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 10:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbjCGJwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 04:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjCGJwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 04:52:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510D561A6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 01:52:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E58EDB815B4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C836C4339C;
        Tue,  7 Mar 2023 09:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678182748;
        bh=VkexTXCphGj6Gzwi9lI5GPFIY919YMBUTuqAzZ0gJ/g=;
        h=Subject:To:Cc:From:Date:From;
        b=zpqAMt/zCW8mFhPJLBz1nC6Rnr4zNJpKUF6IPeqxZ83S0V20zs5epsyIeBrY0ZdU3
         LvwtUealaST/pPw+4ns5aPRx0DbNpqcbC4w7w9lyWRgRLHtbPINxXHb2EBZatyBzga
         wsmdzTCWH/pY8KI62q1J7MlJPipH2YhBvMy0dThU=
Subject: FAILED: patch "[PATCH] ktest.pl: Give back console on Ctrt^C on monitor" failed to apply to 4.14-stable tree
To:     rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 10:52:25 +0100
Message-ID: <167818274565224@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.14.y
git checkout FETCH_HEAD
git cherry-pick -x 83d29d439cd3ef23041570d55841f814af2ecac0
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167818274565224@kroah.com' --subject-prefix 'PATCH 4.14.y' HEAD^..

Possible dependencies:

83d29d439cd3 ("ktest.pl: Give back console on Ctrt^C on monitor")
c2d84ddb338c ("ktest.pl: Add MAIL_COMMAND option to define how to send email")
59f89eb1e3dd ("ktest.pl: Use run_command to execute sending mail")
8604b0c4bc9a ("ktest.pl: Kill test if mailer is not supported")
be1546b87f3b ("ktest.pl: Add MAIL_PATH option to define where to find the mailer")
f5ef48855733 ("ktest.pl: No need to print no mailer is specified when mailto is not")
eaaa1e283ada ("Ktest: add email options to sample.config")
92db453e7eeb ("Ktest: Add SigInt handling")
2ceb2d85b669 ("Ktest: Add email support")
40667fb5fda0 ("ktest.pl: Make finding config-bisect.pl dynamic")
133087f0623e ("ktest.pl: Have ktest.pl pass -r to config-bisect.pl to reset bisect")
b337f9790a0c ("ktest.pl: Allow for the config-bisect.pl output to display to console")
a9adc261e978 ("ktest: Use config-bisect.pl in ktest.pl")
0f0db065999c ("ktest: Add standalone config-bisect.pl program")
3e1d3678844b ("ktest: Add CONNECT_TIMEOUT to change the connection timeout time")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 83d29d439cd3ef23041570d55841f814af2ecac0 Mon Sep 17 00:00:00 2001
From: Steven Rostedt <rostedt@goodmis.org>
Date: Wed, 18 Jan 2023 16:32:13 -0500
Subject: [PATCH] ktest.pl: Give back console on Ctrt^C on monitor

When monitoring the console output, the stdout is being redirected to do
so. If Ctrl^C is hit during this mode, the stdout is not back to the
console, the user does not see anything they type (no echo).

Add "end_monitor" to the SIGINT interrupt handler to give back the console
on Ctrl^C.

Cc: stable@vger.kernel.org
Fixes: 9f2cdcbbb90e7 ("ktest: Give console process a dedicated tty")
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 62823a4232ab..74801811372f 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -4201,6 +4201,9 @@ sub send_email {
 }
 
 sub cancel_test {
+    if ($monitor_cnt) {
+	end_monitor;
+    }
     if ($email_when_canceled) {
 	my $name = get_test_name;
 	send_email("KTEST: Your [$name] test was cancelled",

