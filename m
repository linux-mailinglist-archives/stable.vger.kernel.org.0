Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEDD6D4AD3
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbjDCOul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234062AbjDCOu0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:50:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1AD42907B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:49:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1831FB81D81
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841C5C4339C;
        Mon,  3 Apr 2023 14:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533380;
        bh=E8EKGrOPhXFeGSAwRim+M3EsgJ+IqLRYZPoa3CKU9l0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MIhntu1e13zLsLIUesLLtVVurl6Y4otHzF5UPLL5Y4bR5UxcrGYsoEVAnBpSLh/10
         A8Dk/z1RjkXmg20jhETXfCK8CoMIn7aZa9fdsVZQ2v/s+qCXh8NmmgbGlBGEeqlhHA
         ZepyhpMuPUgmOOoWuhOhiusxM7OXKgEbaQXaUhUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 6.2 162/187] xtensa: fix KASAN report for show_stack
Date:   Mon,  3 Apr 2023 16:10:07 +0200
Message-Id: <20230403140421.468796896@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
@@ -539,7 +539,7 @@ static size_t kstack_depth_to_print = CO
 
 void show_stack(struct task_struct *task, unsigned long *sp, const char *loglvl)
 {
-	size_t len;
+	size_t len, off = 0;
 
 	if (!sp)
 		sp = stack_pointer(task);
@@ -548,9 +548,17 @@ void show_stack(struct task_struct *task
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
 


