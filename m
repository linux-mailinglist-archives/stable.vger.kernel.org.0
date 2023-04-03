Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F246D4921
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbjDCOfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233632AbjDCOfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:35:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3F3E44
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:35:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 164E8CE12DD
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:34:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E861C433EF;
        Mon,  3 Apr 2023 14:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532489;
        bh=8fDpWdDJed4wWXQJ1uiE+mQNg9rYkBy9GbITTi0wzBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hywl6dBWSnouvAfjStKemVZeK3aNGngOXNvN8gVbyHQbC969bWzoryZsoRr/tFMdO
         r532uNhRtJK/Soh40ySx3ONDzIWIUJniErdkGRFIoI7Uy4SnWINNzmnSNOrrs6RpQu
         B72RIqJ7eKBDemIvs/7FMhlMx9ykVXruMYkigsik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5.15 84/99] xtensa: fix KASAN report for show_stack
Date:   Mon,  3 Apr 2023 16:09:47 +0200
Message-Id: <20230403140406.558075369@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

commit 1d3b7a788ca7435156809a6bd5b20c95b2370d45 upstream.

show_stack dumps raw stack contents which may trigger an unnecessary
KASAN report. Fix it by copying stack contents to a temporary buffer
with __memcpy and then printing that buffer instead of passing stack
pointer directly to the print_hex_dump.

Cc: stable@vger.kernel.org
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/kernel/traps.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -510,7 +510,7 @@ static size_t kstack_depth_to_print = CO
 
 void show_stack(struct task_struct *task, unsigned long *sp, const char *loglvl)
 {
-	size_t len;
+	size_t len, off = 0;
 
 	if (!sp)
 		sp = stack_pointer(task);
@@ -519,9 +519,17 @@ void show_stack(struct task_struct *task
 		  kstack_depth_to_print * STACK_DUMP_ENTRY_SIZE);
 
 	printk("%sStack:\n", loglvl);
-	print_hex_dump(loglvl, " ", DUMP_PREFIX_NONE,
-		       STACK_DUMP_LINE_SIZE, STACK_DUMP_ENTRY_SIZE,
-		       sp, len, false);
+	while (off < len) {
+		u8 line[STACK_DUMP_LINE_SIZE];
+		size_t line_len = len - off > STACK_DUMP_LINE_SIZE ?
+			STACK_DUMP_LINE_SIZE : len - off;
+
+		__memcpy(line, (u8 *)sp + off, line_len);
+		print_hex_dump(loglvl, " ", DUMP_PREFIX_NONE,
+			       STACK_DUMP_LINE_SIZE, STACK_DUMP_ENTRY_SIZE,
+			       line, line_len, false);
+		off += STACK_DUMP_LINE_SIZE;
+	}
 	show_trace(task, sp, loglvl);
 }
 


