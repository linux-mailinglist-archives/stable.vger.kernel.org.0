Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 108BC66774E
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239692AbjALOlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238542AbjALOlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:41:10 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9697B2FF
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:30:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E6033CE1E6B
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5118CC433F0;
        Thu, 12 Jan 2023 14:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533849;
        bh=TLWm45GmaQ1fe/Wc+LU9TEthF+czSjFMpNgT97Jfq4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZKGPWVCcvkiz8EvnQ3DGx6KEPbAISiPFonNxZTZ8Um7DCiWPUDm6VlWiNwpftPFO
         8k0nfogzjEOKbBGc9/wskgvbrIAsV4HTyJdnzZzOrltABSLTw7DWEiA++s58mFBDpj
         Pubu6V09l1yQD8qPr+lnFbc7dma/4DOVCZhS4w3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "John Warthog9 Hawley (VMware)" <warthog9@eaglescrag.net>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.10 612/783] kest.pl: Fix grub2 menu handling for rebooting
Date:   Thu, 12 Jan 2023 14:55:28 +0100
Message-Id: <20230112135552.624496373@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

commit 26df05a8c1420ad3de314fdd407e7fc2058cc7aa upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/ktest/ktest.pl |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1912,7 +1912,7 @@ sub run_scp_mod {
 
 sub _get_grub_index {
 
-    my ($command, $target, $skip) = @_;
+    my ($command, $target, $skip, $submenu) = @_;
 
     return if (defined($grub_number) && defined($last_grub_menu) &&
 	       $last_grub_menu eq $grub_menu && defined($last_machine) &&
@@ -1929,11 +1929,16 @@ sub _get_grub_index {
 
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
@@ -1942,6 +1947,9 @@ sub _get_grub_index {
 
     dodie "Could not find '$grub_menu' through $command on $machine"
 	if (!$found);
+    if ($submenu_number > 0) {
+	$grub_number = "$submenu_number>$grub_number";
+    }
     doprint "$grub_number\n";
     $last_grub_menu = $grub_menu;
     $last_machine = $machine;
@@ -1952,6 +1960,7 @@ sub get_grub_index {
     my $command;
     my $target;
     my $skip;
+    my $submenu;
     my $grub_menu_qt;
 
     if ($reboot_type !~ /^grub/) {
@@ -1966,8 +1975,9 @@ sub get_grub_index {
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
@@ -1976,7 +1986,7 @@ sub get_grub_index {
 	return;
     }
 
-    _get_grub_index($command, $target, $skip);
+    _get_grub_index($command, $target, $skip, $submenu);
 }
 
 sub wait_for_input
@@ -2040,7 +2050,7 @@ sub reboot_to {
     if ($reboot_type eq "grub") {
 	run_ssh "'(echo \"savedefault --default=$grub_number --once\" | grub --batch)'";
     } elsif (($reboot_type eq "grub2") or ($reboot_type eq "grub2bls")) {
-	run_ssh "$grub_reboot $grub_number";
+	run_ssh "$grub_reboot \"'$grub_number'\"";
     } elsif ($reboot_type eq "syslinux") {
 	run_ssh "$syslinux --once \\\"$syslinux_label\\\" $syslinux_path";
     } elsif (defined $reboot_script) {


