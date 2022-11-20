Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76323631643
	for <lists+stable@lfdr.de>; Sun, 20 Nov 2022 21:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiKTUMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Nov 2022 15:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiKTUMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Nov 2022 15:12:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96D0E8A;
        Sun, 20 Nov 2022 12:12:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D865B80B87;
        Sun, 20 Nov 2022 20:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE4CC433D7;
        Sun, 20 Nov 2022 20:12:23 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1owqfu-00DiXZ-1X;
        Sun, 20 Nov 2022 15:12:22 -0500
Message-ID: <20221120201222.349027009@goodmis.org>
User-Agent: quilt/0.66
Date:   Sun, 20 Nov 2022 15:12:00 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Yi Yang <yiyang13@huawei.com>
Subject: [for-linus][PATCH 4/7] rethook: fix a potential memleak in rethook_alloc()
References: <20221120201156.868430827@goodmis.org>
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

From: Yi Yang <yiyang13@huawei.com>

In rethook_alloc(), the variable rh is not freed or passed out
if handler is NULL, which could lead to a memleak, fix it.

Link: https://lore.kernel.org/all/20221110104438.88099-1-yiyang13@huawei.com/
[Masami: Add "rethook:" tag to the title.]

Fixes: 54ecbe6f1ed5 ("rethook: Add a generic return hook")
Cc: stable@vger.kernel.org
Signed-off-by: Yi Yang <yiyang13@huawei.com>
Acke-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
---
 kernel/trace/rethook.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/rethook.c b/kernel/trace/rethook.c
index c69d82273ce7..32c3dfdb4d6a 100644
--- a/kernel/trace/rethook.c
+++ b/kernel/trace/rethook.c
@@ -83,8 +83,10 @@ struct rethook *rethook_alloc(void *data, rethook_handler_t handler)
 {
 	struct rethook *rh = kzalloc(sizeof(struct rethook), GFP_KERNEL);
 
-	if (!rh || !handler)
+	if (!rh || !handler) {
+		kfree(rh);
 		return NULL;
+	}
 
 	rh->data = data;
 	rh->handler = handler;
-- 
2.35.1


