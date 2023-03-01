Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9706B6A7116
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjCAQbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjCAQaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:30:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA5E49891;
        Wed,  1 Mar 2023 08:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E93461411;
        Wed,  1 Mar 2023 16:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E9DC433EF;
        Wed,  1 Mar 2023 16:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677688210;
        bh=uCECDDvtpiSYIrsHG/STdok+YOIBt6dmLdPwrNFmHSc=;
        h=From:To:Cc:Subject:Date:From;
        b=VtmqY8fy5xPZ63BMvtTNW8kkKfyKuT+DHdclAfOtPUNDNvn0GotIbWGVSUSyDwI/B
         JoSIhTj7b9Ucx0tYK0KBA0UmRzRblyCToSf7bczZT/P9FuMhMgKeYMigswEOEaBTvL
         v+273bkIAalOtVdpoLDdNawfg2RiGbXFKC7w1o0a10X3R88T91zod5oyy2QXFaTBmt
         EfFlkSLf2RPy8kRvlABWPb/ARoxTaUWO4vYEAQso93hFgGva1/8TEKfl80MW8rI2Mx
         h6haEHTEAVXQCQTcBPNEXTI6rZgyHQw7bokPaWN98Z6rqWDV44LeCFysTqn6RXLy+Q
         CYeDO+gz5Koxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, mhiramat@kernel.org,
        linux-trace-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 1/4] tracing: Add NULL checks for buffer in ring_buffer_free_read_page()
Date:   Wed,  1 Mar 2023 11:30:04 -0500
Message-Id: <20230301163007.1303162-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 3e4272b9954094907f16861199728f14002fcaf6 ]

In a previous commit 7433632c9ff6, buffer, buffer->buffers and
buffer->buffers[cpu] in ring_buffer_wake_waiters() can be NULL,
and thus the related checks are added.

However, in the same call stack, these variables are also used in
ring_buffer_free_read_page():

tracing_buffers_release()
  ring_buffer_wake_waiters(iter->array_buffer->buffer)
    cpu_buffer = buffer->buffers[cpu] -> Add checks by previous commit
  ring_buffer_free_read_page(iter->array_buffer->buffer)
    cpu_buffer = buffer->buffers[cpu] -> No check

Thus, to avod possible null-pointer derefernces, the related checks
should be added.

These results are reported by a static tool designed by myself.

Link: https://lkml.kernel.org/r/20230113125501.760324-1-baijiaju1990@gmail.com

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 11e8189dd8ae9..58809fffc8171 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -4769,11 +4769,16 @@ EXPORT_SYMBOL_GPL(ring_buffer_alloc_read_page);
  */
 void ring_buffer_free_read_page(struct ring_buffer *buffer, int cpu, void *data)
 {
-	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
+	struct ring_buffer_per_cpu *cpu_buffer;
 	struct buffer_data_page *bpage = data;
 	struct page *page = virt_to_page(bpage);
 	unsigned long flags;
 
+	if (!buffer || !buffer->buffers || !buffer->buffers[cpu])
+		return;
+
+	cpu_buffer = buffer->buffers[cpu];
+
 	/* If the page is still in use someplace else, we can't reuse it */
 	if (page_ref_count(page) > 1)
 		goto out;
-- 
2.39.2

