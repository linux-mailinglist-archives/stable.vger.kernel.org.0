Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836E666CBEB
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbjAPRUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234481AbjAPRTj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:19:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F2E227BC
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:58:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B562761055
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A64C433D2;
        Mon, 16 Jan 2023 16:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888324;
        bh=YAaj60acJgjzz9buMAgiCaEPsopzcQz9asq4E4GL4MU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QzXd0RU6WW7WQ3sNDP+GXrSHsQ85ikYqHz1PollykMJ2SV8WAK7D2gPHToGPcBCnS
         3EY7nYRQ9ddUbrbyJWZOxCNZ8KSyFJXb0QL6dQu0Z0jALjhktmjD7GoeOp8vUBNpkM
         YxEkTdM89a8J0JTFhSHfLW3F6JQ9y8gZuM8tDpFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 484/521] ktest: Add support for meta characters in GRUB_MENU
Date:   Mon, 16 Jan 2023 16:52:26 +0100
Message-Id: <20230116154908.831292268@linuxfoundation.org>
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

[ Upstream commit 68911069f509ba3bf0f513d9af00309e07932906 ]

ktest fails if meta characters are in GRUB_MENU, for example
GRUB_MENU = 'Fedora (test)'

The failure happens because the meta characters are not escaped,
so the menu doesn't match in any entries in GRUB_FILE.

Use quotemeta() to escape the meta characters.

Link: http://lkml.kernel.org/r/20190417235823.18176-1-msys.mizuma@gmail.com

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Stable-dep-of: 26df05a8c142 ("kest.pl: Fix grub2 menu handling for rebooting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/ktest/ktest.pl | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 92663d123be1..635121ecf543 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1866,9 +1866,10 @@ sub get_grub2_index {
 	or dodie "unable to get $grub_file";
 
     my $found = 0;
+    my $grub_menu_qt = quotemeta($grub_menu);
 
     while (<IN>) {
-	if (/^menuentry.*$grub_menu/) {
+	if (/^menuentry.*$grub_menu_qt/) {
 	    $grub_number++;
 	    $found = 1;
 	    last;
@@ -1909,9 +1910,10 @@ sub get_grub_index {
 	or dodie "unable to get menu.lst";
 
     my $found = 0;
+    my $grub_menu_qt = quotemeta($grub_menu);
 
     while (<IN>) {
-	if (/^\s*title\s+$grub_menu\s*$/) {
+	if (/^\s*title\s+$grub_menu_qt\s*$/) {
 	    $grub_number++;
 	    $found = 1;
 	    last;
-- 
2.35.1



