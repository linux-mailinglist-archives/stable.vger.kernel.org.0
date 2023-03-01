Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA57A6A70FE
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjCAQaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjCAQaD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:30:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E8248E02;
        Wed,  1 Mar 2023 08:29:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9ECB61425;
        Wed,  1 Mar 2023 16:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADF5C433D2;
        Wed,  1 Mar 2023 16:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677688191;
        bh=mnYwX2pD2eYqdyxjNDp9neXHJaavCed9XVMd5+o6YfY=;
        h=From:To:Cc:Subject:Date:From;
        b=t4bWEwvn3ERNbwnE/O9Y2xLy2Y41BohRIfEmXyBwsznrr4o54xysrv1hsXm5YQQW1
         aOi+Kyb276n8hB+D6bsDnx0kkdmOLuGjEVy3kagqkBZx76NIMNj42rk0YfeLQHyEBb
         77aS9iW+j8p/TL9QsAOoMGbXPTmnVkzvGIZkGEuCp4fIsTezMGvGJw+e3ya9lawAva
         oCCjbNBbLeZUvNzghtZ9m+vdq9kaQ1cg+PWajLdkZEbjQzw1RjPFWg6ru8XqhiOwWa
         B/yDBLeT7PiqGPDkEhNLabmH/bkplxfN/JNQuv+6izdQAVbGobYCVF3NGVZJ+apjdx
         hAs1lpjYCuwaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, mhiramat@kernel.org,
        linux-trace-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 1/6] tracing: Add NULL checks for buffer in ring_buffer_free_read_page()
Date:   Wed,  1 Mar 2023 11:29:43 -0500
Message-Id: <20230301162948.1302994-1-sashal@kernel.org>
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
index ffc8696e67467..41ed07e2cbc05 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5568,11 +5568,16 @@ EXPORT_SYMBOL_GPL(ring_buffer_alloc_read_page);
  */
 void ring_buffer_free_read_page(struct trace_buffer *buffer, int cpu, void *data)
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

