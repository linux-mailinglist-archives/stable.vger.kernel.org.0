Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B9261DE0F
	for <lists+stable@lfdr.de>; Sat,  5 Nov 2022 21:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiKEUvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Nov 2022 16:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiKEUvK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Nov 2022 16:51:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B366EE2A;
        Sat,  5 Nov 2022 13:51:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E7E860B83;
        Sat,  5 Nov 2022 20:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C6BC43144;
        Sat,  5 Nov 2022 20:51:08 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1orQ8g-007k8n-0C;
        Sat, 05 Nov 2022 16:51:38 -0400
Message-ID: <20221105205137.904415773@goodmis.org>
User-Agent: quilt/0.66
Date:   Sat, 05 Nov 2022 16:50:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Rafael Mendonca <rafaelmendsr@gmail.com>
Subject: [for-linus][PATCH 4/6] fprobe: Check rethook_alloc() return in rethook initialization
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

From: Rafael Mendonca <rafaelmendsr@gmail.com>

Check if fp->rethook succeeded to be allocated. Otherwise, if
rethook_alloc() fails, then we end up dereferencing a NULL pointer in
rethook_add_node().

Link: https://lore.kernel.org/all/20221025031209.954836-1-rafaelmendsr@gmail.com/

Fixes: 5b0ab78998e3 ("fprobe: Add exit_handler support")
Cc: stable@vger.kernel.org
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
---
 kernel/trace/fprobe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index aac63ca9c3d1..71614b2a67ff 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -141,6 +141,8 @@ static int fprobe_init_rethook(struct fprobe *fp, int num)
 		return -E2BIG;
 
 	fp->rethook = rethook_alloc((void *)fp, fprobe_exit_handler);
+	if (!fp->rethook)
+		return -ENOMEM;
 	for (i = 0; i < size; i++) {
 		struct fprobe_rethook_node *node;
 
-- 
2.35.1
