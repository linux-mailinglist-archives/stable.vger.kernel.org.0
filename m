Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE746B49AB
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbjCJPOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234015AbjCJPOV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:14:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D9E856B6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:05:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24B6C61A81
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2908EC433EF;
        Fri, 10 Mar 2023 15:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460655;
        bh=nc7JkrhSCyWhyYeRYgscxZ/n38adIn35egzYd/INvgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x7i/5IfuhC1aG9xhVEgu3vtei3zUEJWfgovzk3Ay7QgoiNYmrjd8ptnwChDNgKosS
         gso8pBnlxzC9piH5FK6buOnDEPQP35037AwsZn+RcGAZzrUMstfIk1vZFKO3yau4o+
         ep3qR3MxgubsbErh6Mo50g6q8iljdoxbWJzUm9yI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.10 406/529] ktest.pl: Give back console on Ctrt^C on monitor
Date:   Fri, 10 Mar 2023 14:39:09 +0100
Message-Id: <20230310133823.803920621@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

commit 83d29d439cd3ef23041570d55841f814af2ecac0 upstream.

When monitoring the console output, the stdout is being redirected to do
so. If Ctrl^C is hit during this mode, the stdout is not back to the
console, the user does not see anything they type (no echo).

Add "end_monitor" to the SIGINT interrupt handler to give back the console
on Ctrl^C.

Cc: stable@vger.kernel.org
Fixes: 9f2cdcbbb90e7 ("ktest: Give console process a dedicated tty")
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/ktest/ktest.pl |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -4283,6 +4283,9 @@ sub send_email {
 }
 
 sub cancel_test {
+    if ($monitor_cnt) {
+	end_monitor;
+    }
     if ($email_when_canceled) {
 	my $name = get_test_name;
         send_email("KTEST: Your [$name] test was cancelled",


