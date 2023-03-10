Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1113B6B4469
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbjCJOXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:23:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbjCJOXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:23:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EA3119422
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:22:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16CC7B82291
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762F0C433EF;
        Fri, 10 Mar 2023 14:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458161;
        bh=YWCsMAj4Y+Ykmv89GZUoCpQZXgbbx4ta0JnN5VKTQaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=On6KaYNIAeyUV7da3lAJt97eG1RKTQpcoJh7cmhFiWTy7pVL7xDA9npN4RMY0dZFo
         TRdPqAZ2qUiHpsXJASOhgygxvaDGc7J8koikLqLSa8XTy07UQiCFjAbPwInWSTeXA5
         rCSymVXaPh4/tO2NH+lfC7XmW3Dc71kr7mCKpDHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 4.19 183/252] ktest.pl: Give back console on Ctrt^C on monitor
Date:   Fri, 10 Mar 2023 14:39:13 +0100
Message-Id: <20230310133724.448282485@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
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
@@ -4243,6 +4243,9 @@ sub send_email {
 }
 
 sub cancel_test {
+    if ($monitor_cnt) {
+	end_monitor;
+    }
     if ($email_when_canceled) {
         send_email("KTEST: Your [$test_type] test was cancelled",
                 "Your test started at $script_start_time was cancelled: sig int");


