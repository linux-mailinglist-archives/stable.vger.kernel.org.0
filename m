Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F61166CBEC
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbjAPRUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:20:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234334AbjAPRTk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:19:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFFC23846
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:58:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 098BFB80E95
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBBEC433D2;
        Mon, 16 Jan 2023 16:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888326;
        bh=kGND5xNN3yhK60X3dNDwAoBpExafk0jgENUohVPj964=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OLu8x6lfmZjsYnRMovB7euEKS7QwlRHzpw67YNpJb+rWgp3MWOLA9ExwSX3KeI9x5
         /XdKT9Fznqd5MAG2CXpYIZoFec85KO1qKtxLx28DsQodo1aPdvAYlw+2jrqWQZKU8e
         JggXTkwKMJ4COnLxH5SzCj0c4nORG5gxv6yJ4iew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 485/521] ktest: introduce _get_grub_index
Date:   Mon, 16 Jan 2023 16:52:27 +0100
Message-Id: <20230116154908.871466489@linuxfoundation.org>
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

[ Upstream commit f824b6866835bc5051c44ffd289134974f214e98 ]

Introduce _get_grub_index() to deal with Boot Loader
Specification (BLS) and cleanup.

Link: http://lkml.kernel.org/r/20190509213647.6276-2-msys.mizuma@gmail.com

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Stable-dep-of: 26df05a8c142 ("kest.pl: Fix grub2 menu handling for rebooting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/ktest/ktest.pl | 37 ++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 635121ecf543..5fa60b3c564f 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1850,6 +1850,43 @@ sub run_scp_mod {
     return run_scp($src, $dst, $cp_scp);
 }
 
+sub _get_grub_index {
+
+    my ($command, $target, $skip) = @_;
+
+    return if (defined($grub_number) && defined($last_grub_menu) &&
+	       $last_grub_menu eq $grub_menu && defined($last_machine) &&
+	       $last_machine eq $machine);
+
+    doprint "Find $reboot_type menu ... ";
+    $grub_number = -1;
+
+    my $ssh_grub = $ssh_exec;
+    $ssh_grub =~ s,\$SSH_COMMAND,$command,g;
+
+    open(IN, "$ssh_grub |")
+	or dodie "unable to execute $command";
+
+    my $found = 0;
+
+    while (<IN>) {
+	if (/$target/) {
+	    $grub_number++;
+	    $found = 1;
+	    last;
+	} elsif (/$skip/) {
+	    $grub_number++;
+	}
+    }
+    close(IN);
+
+    dodie "Could not find '$grub_menu' through $command on $machine"
+	if (!$found);
+    doprint "$grub_number\n";
+    $last_grub_menu = $grub_menu;
+    $last_machine = $machine;
+}
+
 sub get_grub2_index {
 
     return if (defined($grub_number) && defined($last_grub_menu) &&
-- 
2.35.1



