Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC6D36AF580
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234094AbjCGT0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234066AbjCGTZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:25:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED8E30ED
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:11:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 245E9B817C2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:11:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5767BC4339B;
        Tue,  7 Mar 2023 19:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216309;
        bh=DshPpn0L1dGRWBX6EZiMPn9Szb6FJuV/ILsVqSgJDmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ydPkQUUvUqRWNQg784WiNNAsJyJvAjynm+HH2JyZeIJ82mhJ1PsMGruNX2KIPWsSa
         BsiTA8hJRjbYda5h4vkewSEwVd8e69UBR1Gd6PdXvMHJVM3fNt4h/+lE6yBPQ5eacz
         6gCYojSL5SQDpD+q4tieUBrHTkhovc8DLB0f1i/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.15 535/567] ktest.pl: Add RUN_TIMEOUT option with default unlimited
Date:   Tue,  7 Mar 2023 18:04:31 +0100
Message-Id: <20230307165929.139490582@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

commit 4e7d2a8f0b52abf23b1dc13b3d88bc0923383cd5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/ktest/ktest.pl    |   20 ++++++++++++++++----
 tools/testing/ktest/sample.conf |    5 +++++
 2 files changed, 21 insertions(+), 4 deletions(-)

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
@@ -1851,6 +1853,14 @@ sub run_command {
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
 
@@ -1877,13 +1887,10 @@ sub run_command {
 
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
@@ -2055,6 +2062,11 @@ sub wait_for_input {
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
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -809,6 +809,11 @@
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


