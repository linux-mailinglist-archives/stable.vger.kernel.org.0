Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16EC66CC1E
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234416AbjAPRWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234511AbjAPRVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:21:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F04827493
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:59:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8AAFB8108E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A5BC433F0;
        Mon, 16 Jan 2023 16:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888380;
        bh=Cvt+OCLgYwNAZEp2AI2UlDmq7bMBP3/4BRIXWo7GMYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L3hPAojnIgez+F0VZ02Rm0BN792qVyC1xzSpK0foG/iLGDPqM/bFRrW/2K8l/FMF8
         LL8ICeWsI3YN30R7DLDLckrLv2E3TSsNdGnpwFb8zfjMJX4wce1If3l4bJL4ch9TTW
         kn4xZIaa+BytOKTbdW9qu9EOFtHQJDsCf6iaO19o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "John Warthog9 Hawley (VMware)" <warthog9@eaglescrag.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 489/521] kest.pl: Fix grub2 menu handling for rebooting
Date:   Mon, 16 Jan 2023 16:52:31 +0100
Message-Id: <20230116154909.048069836@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 26df05a8c1420ad3de314fdd407e7fc2058cc7aa ]

grub2 has submenus where to use grub-reboot, it requires:

  grub-reboot X>Y

where X is the main index and Y is the submenu. Thus if you have:

menuentry 'Debian GNU/Linux' --class debian --class gnu-linux ...
	[...]
}
submenu 'Advanced options for Debian GNU/Linux' $menuentry_id_option ...
        menuentry 'Debian GNU/Linux, with Linux 6.0.0-4-amd64' --class debian --class gnu-linux ...
                [...]
        }
        menuentry 'Debian GNU/Linux, with Linux 6.0.0-4-amd64 (recovery mode)' --class debian --class gnu-linux ...
		[...]
        }
        menuentry 'Debian GNU/Linux, with Linux test' --class debian --class gnu-linux ...
                [...]
        }

And wanted to boot to the "Linux test" kernel, you need to run:

 # grub-reboot 1>2

As 1 is the second top menu (the submenu) and 2 is the third of the sub
menu entries.

Have the grub.cfg parsing for grub2 handle such cases.

Cc: stable@vger.kernel.org
Fixes: a15ba91361d46 ("ktest: Add support for grub2")
Reviewed-by: John 'Warthog9' Hawley (VMware) <warthog9@eaglescrag.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/ktest/ktest.pl | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 689fa4fd3d76..a0b53309c5d8 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1860,7 +1860,7 @@ sub run_scp_mod {
 
 sub _get_grub_index {
 
-    my ($command, $target, $skip) = @_;
+    my ($command, $target, $skip, $submenu) = @_;
 
     return if (defined($grub_number) && defined($last_grub_menu) &&
 	       $last_grub_menu eq $grub_menu && defined($last_machine) &&
@@ -1877,11 +1877,16 @@ sub _get_grub_index {
 
     my $found = 0;
 
+    my $submenu_number = 0;
+
     while (<IN>) {
 	if (/$target/) {
 	    $grub_number++;
 	    $found = 1;
 	    last;
+	} elsif (defined($submenu) && /$submenu/) {
+		$submenu_number++;
+		$grub_number = -1;
 	} elsif (/$skip/) {
 	    $grub_number++;
 	}
@@ -1890,6 +1895,9 @@ sub _get_grub_index {
 
     dodie "Could not find '$grub_menu' through $command on $machine"
 	if (!$found);
+    if ($submenu_number > 0) {
+	$grub_number = "$submenu_number>$grub_number";
+    }
     doprint "$grub_number\n";
     $last_grub_menu = $grub_menu;
     $last_machine = $machine;
@@ -1936,6 +1944,7 @@ sub get_grub_index {
     my $command;
     my $target;
     my $skip;
+    my $submenu;
     my $grub_menu_qt;
 
     if ($reboot_type !~ /^grub/) {
@@ -1950,8 +1959,9 @@ sub get_grub_index {
 	$skip = '^\s*title\s';
     } elsif ($reboot_type eq "grub2") {
 	$command = "cat $grub_file";
-	$target = '^menuentry.*' . $grub_menu_qt;
-	$skip = '^menuentry\s|^submenu\s';
+	$target = '^\s*menuentry.*' . $grub_menu_qt;
+	$skip = '^\s*menuentry';
+	$submenu = '^\s*submenu\s';
     } elsif ($reboot_type eq "grub2bls") {
         $command = $grub_bls_get;
         $target = '^title=.*' . $grub_menu_qt;
@@ -1960,7 +1970,7 @@ sub get_grub_index {
 	return;
     }
 
-    _get_grub_index($command, $target, $skip);
+    _get_grub_index($command, $target, $skip, $submenu);
 }
 
 sub wait_for_input
@@ -2024,7 +2034,7 @@ sub reboot_to {
     if ($reboot_type eq "grub") {
 	run_ssh "'(echo \"savedefault --default=$grub_number --once\" | grub --batch)'";
     } elsif (($reboot_type eq "grub2") or ($reboot_type eq "grub2bls")) {
-	run_ssh "$grub_reboot $grub_number";
+	run_ssh "$grub_reboot \"'$grub_number'\"";
     } elsif ($reboot_type eq "syslinux") {
 	run_ssh "$syslinux --once \\\"$syslinux_label\\\" $syslinux_path";
     } elsif (defined $reboot_script) {
-- 
2.35.1



