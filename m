Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B21D6ADB1A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 10:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjCGJyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 04:54:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbjCGJyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 04:54:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81757509BC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 01:54:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BA413CE1B25
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87029C433EF;
        Tue,  7 Mar 2023 09:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678182836;
        bh=3LQWSwPFYBSRFFWGAOagB+pkW/h+sOr17XlqDDtOWJE=;
        h=Subject:To:Cc:From:Date:From;
        b=0gn1SvCfmIGRRhm7pe74ysP82mv/DH1ULcmC/8bZBD1L7zu+wmESpA0SkaqDTjWvx
         A5Txr8pj5vlP3dokQ+/H/0o3xqf0ewOtTsNldAFf8rSPhEIo3f7pvo/85s/xE84bb7
         bTNgVuMJJ94S0Jhs0C1eSQAQOliFZvzpG0O68pyY=
Subject: FAILED: patch "[PATCH] ktest.pl: Add RUN_TIMEOUT option with default unlimited" failed to apply to 4.14-stable tree
To:     rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 10:53:52 +0100
Message-ID: <167818283215417@kroah.com>
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
git cherry-pick -x 4e7d2a8f0b52abf23b1dc13b3d88bc0923383cd5
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167818283215417@kroah.com' --subject-prefix 'PATCH 4.14.y' HEAD^..

Possible dependencies:

4e7d2a8f0b52 ("ktest.pl: Add RUN_TIMEOUT option with default unlimited")
3e1d3678844b ("ktest: Add CONNECT_TIMEOUT to change the connection timeout time")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4e7d2a8f0b52abf23b1dc13b3d88bc0923383cd5 Mon Sep 17 00:00:00 2001
From: Steven Rostedt <rostedt@goodmis.org>
Date: Wed, 18 Jan 2023 16:37:25 -0500
Subject: [PATCH] ktest.pl: Add RUN_TIMEOUT option with default unlimited

There is a disconnect between the run_command function and the
wait_for_input. The wait_for_input has a default timeout of 2 minutes. But
if that happens, the run_command loop will exit out to the waitpid() of
the executing command. This fails in that it no longer monitors the
command, and also, the ssh to the test box can hang when its finished, as
it's waiting for the pipe it's writing to to flush, but the loop that
reads that pipe has already exited, leaving the command stuck, and the
test hangs.

Instead, make the default "wait_for_input" of the run_command infinite,
and allow the user to override it if they want with a default timeout
option "RUN_TIMEOUT".

But this fixes the hang that happens when the pipe is full and the ssh
session never exits.

Cc: stable@vger.kernel.org
Fixes: 6e98d1b4415fe ("ktest: Add timeout to ssh command")
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 74801811372f..822794ca4029 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -178,6 +178,7 @@ my $store_failures;
 my $store_successes;
 my $test_name;
 my $timeout;
+my $run_timeout;
 my $connect_timeout;
 my $config_bisect_exec;
 my $booted_timeout;
@@ -340,6 +341,7 @@ my %option_map = (
     "STORE_SUCCESSES"		=> \$store_successes,
     "TEST_NAME"			=> \$test_name,
     "TIMEOUT"			=> \$timeout,
+    "RUN_TIMEOUT"		=> \$run_timeout,
     "CONNECT_TIMEOUT"		=> \$connect_timeout,
     "CONFIG_BISECT_EXEC"	=> \$config_bisect_exec,
     "BOOTED_TIMEOUT"		=> \$booted_timeout,
@@ -1858,6 +1860,14 @@ sub run_command {
     $command =~ s/\$SSH_USER/$ssh_user/g;
     $command =~ s/\$MACHINE/$machine/g;
 
+    if (!defined($timeout)) {
+	$timeout = $run_timeout;
+    }
+
+    if (!defined($timeout)) {
+	$timeout = -1; # tell wait_for_input to wait indefinitely
+    }
+
     doprint("$command ... ");
     $start_time = time;
 
@@ -1884,13 +1894,10 @@ sub run_command {
 
     while (1) {
 	my $fp = \*CMD;
-	if (defined($timeout)) {
-	    doprint "timeout = $timeout\n";
-	}
 	my $line = wait_for_input($fp, $timeout);
 	if (!defined($line)) {
 	    my $now = time;
-	    if (defined($timeout) && (($now - $start_time) >= $timeout)) {
+	    if ($timeout >= 0 && (($now - $start_time) >= $timeout)) {
 		doprint "Hit timeout of $timeout, killing process\n";
 		$hit_timeout = 1;
 		kill 9, $pid;
@@ -2062,6 +2069,11 @@ sub wait_for_input {
 	$time = $timeout;
     }
 
+    if ($time < 0) {
+	# Negative number means wait indefinitely
+	undef $time;
+    }
+
     $rin = '';
     vec($rin, fileno($fp), 1) = 1;
     vec($rin, fileno(\*STDIN), 1) = 1;
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index 2d0fe15a096d..f43477a9b857 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -817,6 +817,11 @@
 # is issued instead of a reboot.
 # CONNECT_TIMEOUT = 25
 
+# The timeout in seconds for how long to wait for any running command
+# to timeout. If not defined, it will let it go indefinitely.
+# (default undefined)
+#RUN_TIMEOUT = 600
+
 # In between tests, a reboot of the box may occur, and this
 # is the time to wait for the console after it stops producing
 # output. Some machines may not produce a large lag on reboot

