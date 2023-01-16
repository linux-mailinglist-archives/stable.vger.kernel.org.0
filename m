Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4F1B66CC34
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234610AbjAPRXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234411AbjAPRWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:22:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E01636FD9
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:00:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 197CF60F61
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:00:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30AA3C433F0;
        Mon, 16 Jan 2023 17:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888434;
        bh=Faf3x/eeUECjRwIHC0HoCzbo23zaaEKmorulEU1/OYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wn5ZdfewXMVRwXGUvDkCFwH3inrEximThmKSsOdoowQvt740Lc+BRsf28cJ27MCaS
         /fF0aJoQV3vSj+ShapBTvu7DRr2fnnKWxIaFoSZj4THVeJZevKcX4qMqqvlwk+J0tJ
         w7pvAQGOBXpyijxO2AyFob9EXbcrap1lRIT61EIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 487/521] ktest: introduce grub2bls REBOOT_TYPE option
Date:   Mon, 16 Jan 2023 16:52:29 +0100
Message-Id: <20230116154908.952621696@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

[ Upstream commit ac2466456eaa0ff9b8cf647c4c52832024bc929f ]

Fedora 30 introduces Boot Loader Specification (BLS),
it changes around grub entry configuration.

kernel entries aren't in grub.cfg. We can get the entries
by "grubby --info=ALL" command.

Introduce grub2bls as REBOOT_TYPE option for BLS.

Link: http://lkml.kernel.org/r/20190509213647.6276-4-msys.mizuma@gmail.com

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Stable-dep-of: 26df05a8c142 ("kest.pl: Fix grub2 menu handling for rebooting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/ktest/ktest.pl | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index a1067469ba0e..76468e2d619f 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -63,6 +63,7 @@ my %default = (
     "STOP_TEST_AFTER"		=> 600,
     "MAX_MONITOR_WAIT"		=> 1800,
     "GRUB_REBOOT"		=> "grub2-reboot",
+    "GRUB_BLS_GET"		=> "grubby --info=ALL",
     "SYSLINUX"			=> "extlinux",
     "SYSLINUX_PATH"		=> "/boot/extlinux",
     "CONNECT_TIMEOUT"		=> 25,
@@ -123,6 +124,7 @@ my $last_grub_menu;
 my $grub_file;
 my $grub_number;
 my $grub_reboot;
+my $grub_bls_get;
 my $syslinux;
 my $syslinux_path;
 my $syslinux_label;
@@ -292,6 +294,7 @@ my %option_map = (
     "GRUB_MENU"			=> \$grub_menu,
     "GRUB_FILE"			=> \$grub_file,
     "GRUB_REBOOT"		=> \$grub_reboot,
+    "GRUB_BLS_GET"		=> \$grub_bls_get,
     "SYSLINUX"			=> \$syslinux,
     "SYSLINUX_PATH"		=> \$syslinux_path,
     "SYSLINUX_LABEL"		=> \$syslinux_label,
@@ -437,7 +440,7 @@ EOF
     ;
 $config_help{"REBOOT_TYPE"} = << "EOF"
  Way to reboot the box to the test kernel.
- Only valid options so far are "grub", "grub2", "syslinux", and "script".
+ Only valid options so far are "grub", "grub2", "grub2bls", "syslinux", and "script".
 
  If you specify grub, it will assume grub version 1
  and will search in /boot/grub/menu.lst for the title \$GRUB_MENU
@@ -451,6 +454,8 @@ $config_help{"REBOOT_TYPE"} = << "EOF"
  If you specify grub2, then you also need to specify both \$GRUB_MENU
  and \$GRUB_FILE.
 
+ If you specify grub2bls, then you also need to specify \$GRUB_MENU.
+
  If you specify syslinux, then you may use SYSLINUX to define the syslinux
  command (defaults to extlinux), and SYSLINUX_PATH to specify the path to
  the syslinux install (defaults to /boot/extlinux). But you have to specify
@@ -476,6 +481,9 @@ $config_help{"GRUB_MENU"} = << "EOF"
  menu must be a non-nested menu. Add the quotes used in the menu
  to guarantee your selection, as the first menuentry with the content
  of \$GRUB_MENU that is found will be used.
+
+ For grub2bls, \$GRUB_MENU is searched on the result of \$GRUB_BLS_GET
+ command for the lines that begin with "title".
 EOF
     ;
 $config_help{"GRUB_FILE"} = << "EOF"
@@ -692,7 +700,7 @@ sub get_mandatory_configs {
 	}
     }
 
-    if ($rtype eq "grub") {
+    if (($rtype eq "grub") or ($rtype eq "grub2bls")) {
 	get_mandatory_config("GRUB_MENU");
     }
 
@@ -1944,6 +1952,10 @@ sub get_grub_index {
 	$command = "cat $grub_file";
 	$target = '^menuentry.*' . $grub_menu_qt;
 	$skip = '^menuentry\s|^submenu\s';
+    } elsif ($reboot_type eq "grub2bls") {
+        $command = $grub_bls_get;
+        $target = '^title=.*' . $grub_menu_qt;
+        $skip = '^title=';
     } else {
 	return;
     }
@@ -4307,7 +4319,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
 
     if (!$buildonly) {
 	$target = "$ssh_user\@$machine";
-	if ($reboot_type eq "grub") {
+	if (($reboot_type eq "grub") or ($reboot_type eq "grub2bls")) {
 	    dodie "GRUB_MENU not defined" if (!defined($grub_menu));
 	} elsif ($reboot_type eq "grub2") {
 	    dodie "GRUB_MENU not defined" if (!defined($grub_menu));
-- 
2.35.1



