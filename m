Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E69A366CBED
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234531AbjAPRUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234559AbjAPRTm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:19:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2049B2CFD6
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:58:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA74FB810A0
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09214C43398;
        Mon, 16 Jan 2023 16:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888329;
        bh=gF4UeWqlQiBLetvvdFTEi70FveVwbDGlcCICOqKIc6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FmufY02+5TnHFfGh67A6a2p4Q1+95sFPdVyp6dlj++HSDXI4baLB0spckv3grja1Q
         0TuQlxooermRhSK532Oop4Zu4iO7RKMSWvyboSFcgJmb4+e2SCg8anErIL/CNvWVzH
         gXbnyMA9wGZzkS86hvuX3cigy4aScBAvN1ct6NXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 486/521] ktest: cleanup get_grub_index
Date:   Mon, 16 Jan 2023 16:52:28 +0100
Message-Id: <20230116154908.910971276@linuxfoundation.org>
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

[ Upstream commit 38891392916c42d4ba46f474d553c76d1ed329ca ]

Cleanup get_grub_index().

Link: http://lkml.kernel.org/r/20190509213647.6276-3-msys.mizuma@gmail.com

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Stable-dep-of: 26df05a8c142 ("kest.pl: Fix grub2 menu handling for rebooting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/ktest/ktest.pl | 50 ++++++++++++------------------------
 1 file changed, 17 insertions(+), 33 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 5fa60b3c564f..a1067469ba0e 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1925,46 +1925,30 @@ sub get_grub2_index {
 
 sub get_grub_index {
 
-    if ($reboot_type eq "grub2") {
-	get_grub2_index;
-	return;
-    }
+    my $command;
+    my $target;
+    my $skip;
+    my $grub_menu_qt;
 
-    if ($reboot_type ne "grub") {
+    if ($reboot_type !~ /^grub/) {
 	return;
     }
-    return if (defined($grub_number) && defined($last_grub_menu) &&
-	       $last_grub_menu eq $grub_menu && defined($last_machine) &&
-	       $last_machine eq $machine);
-
-    doprint "Find grub menu ... ";
-    $grub_number = -1;
 
-    my $ssh_grub = $ssh_exec;
-    $ssh_grub =~ s,\$SSH_COMMAND,cat /boot/grub/menu.lst,g;
-
-    open(IN, "$ssh_grub |")
-	or dodie "unable to get menu.lst";
+    $grub_menu_qt = quotemeta($grub_menu);
 
-    my $found = 0;
-    my $grub_menu_qt = quotemeta($grub_menu);
-
-    while (<IN>) {
-	if (/^\s*title\s+$grub_menu_qt\s*$/) {
-	    $grub_number++;
-	    $found = 1;
-	    last;
-	} elsif (/^\s*title\s/) {
-	    $grub_number++;
-	}
+    if ($reboot_type eq "grub") {
+	$command = "cat /boot/grub/menu.lst";
+	$target = '^\s*title\s+' . $grub_menu_qt . '\s*$';
+	$skip = '^\s*title\s';
+    } elsif ($reboot_type eq "grub2") {
+	$command = "cat $grub_file";
+	$target = '^menuentry.*' . $grub_menu_qt;
+	$skip = '^menuentry\s|^submenu\s';
+    } else {
+	return;
     }
-    close(IN);
 
-    dodie "Could not find '$grub_menu' in /boot/grub/menu on $machine"
-	if (!$found);
-    doprint "$grub_number\n";
-    $last_grub_menu = $grub_menu;
-    $last_machine = $machine;
+    _get_grub_index($command, $target, $skip);
 }
 
 sub wait_for_input
-- 
2.35.1



