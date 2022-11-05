Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C672461DE13
	for <lists+stable@lfdr.de>; Sat,  5 Nov 2022 21:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiKEUvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Nov 2022 16:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiKEUvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Nov 2022 16:51:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BCF12AB6;
        Sat,  5 Nov 2022 13:51:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB079B808CE;
        Sat,  5 Nov 2022 20:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FB4C43148;
        Sat,  5 Nov 2022 20:51:09 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1orQ8g-007k9L-0l;
        Sat, 05 Nov 2022 16:51:38 -0400
Message-ID: <20221105205138.075774025@goodmis.org>
User-Agent: quilt/0.66
Date:   Sat, 05 Nov 2022 16:50:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [for-linus][PATCH 5/6] tracing/fprobe: Fix to check whether fprobe is registered correctly
References: <20221105205049.462806482@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>

Since commit ab51e15d535e ("fprobe: Introduce FPROBE_FL_KPROBE_SHARED flag
for fprobe") introduced fprobe_kprobe_handler() for fprobe::ops::func,
unregister_fprobe() fails to unregister the registered if user specifies
FPROBE_FL_KPROBE_SHARED flag.
Moreover, __register_ftrace_function() is possible to change the
ftrace_ops::func, thus we have to check fprobe::ops::saved_func instead.

To check it correctly, it should confirm the fprobe::ops::saved_func is
either fprobe_handler() or fprobe_kprobe_handler().

Link: https://lore.kernel.org/all/166677683946.1459107.15997653945538644683.stgit@devnote3/

Fixes: cad9931f64dc ("fprobe: Add ftrace based probe APIs")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
---
 kernel/trace/fprobe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index 71614b2a67ff..e8143e368074 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -303,7 +303,8 @@ int unregister_fprobe(struct fprobe *fp)
 {
 	int ret;
 
-	if (!fp || fp->ops.func != fprobe_handler)
+	if (!fp || (fp->ops.saved_func != fprobe_handler &&
+		    fp->ops.saved_func != fprobe_kprobe_handler))
 		return -EINVAL;
 
 	/*
-- 
2.35.1
