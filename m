Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE046EF91E
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 19:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbjDZRRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 13:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234756AbjDZRRy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 13:17:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21883525D;
        Wed, 26 Apr 2023 10:17:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5352F63706;
        Wed, 26 Apr 2023 17:17:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D009C4339B;
        Wed, 26 Apr 2023 17:17:52 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1prim7-005Kcf-0k;
        Wed, 26 Apr 2023 13:17:51 -0400
Message-ID: <20230426171751.044554153@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 26 Apr 2023 13:17:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, npiggin@gmail.com,
        Cheng-Jui Wang <cheng-jui.wang@mediatek.com>,
        Tze-nan Wu <Tze-nan.Wu@mediatek.com>
Subject: [for-next][PATCH 10/11] ring-buffer: Ensure proper resetting of atomic variables in
 ring_buffer_reset_online_cpus
References: <20230426171703.202523909@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tze-nan Wu <Tze-nan.Wu@mediatek.com>

In ring_buffer_reset_online_cpus, the buffer_size_kb write operation
may permanently fail if the cpu_online_mask changes between two
for_each_online_buffer_cpu loops. The number of increases and decreases
on both cpu_buffer->resize_disabled and cpu_buffer->record_disabled may be
inconsistent, causing some CPUs to have non-zero values for these atomic
variables after the function returns.

This issue can be reproduced by "echo 0 > trace" while hotplugging cpu.
After reproducing success, we can find out buffer_size_kb will not be
functional anymore.

To prevent leaving 'resize_disabled' and 'record_disabled' non-zero after
ring_buffer_reset_online_cpus returns, we ensure that each atomic variable
has been set up before atomic_sub() to it.

Link: https://lore.kernel.org/linux-trace-kernel/20230426062027.17451-1-Tze-nan.Wu@mediatek.com

Cc: stable@vger.kernel.org
Cc: <mhiramat@kernel.org>
Cc: npiggin@gmail.com
Fixes: b23d7a5f4a07 ("ring-buffer: speed up buffer resets by avoiding synchronize_rcu for each CPU")
Reviewed-by: Cheng-Jui Wang <cheng-jui.wang@mediatek.com>
Signed-off-by: Tze-nan Wu <Tze-nan.Wu@mediatek.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 58be5b409f72..9a0cb94c3972 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5326,6 +5326,9 @@ void ring_buffer_reset_cpu(struct trace_buffer *buffer, int cpu)
 }
 EXPORT_SYMBOL_GPL(ring_buffer_reset_cpu);
 
+/* Flag to ensure proper resetting of atomic variables */
+#define RESET_BIT	(1 << 30)
+
 /**
  * ring_buffer_reset_online_cpus - reset a ring buffer per CPU buffer
  * @buffer: The ring buffer to reset a per cpu buffer of
@@ -5342,20 +5345,27 @@ void ring_buffer_reset_online_cpus(struct trace_buffer *buffer)
 	for_each_online_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
 
-		atomic_inc(&cpu_buffer->resize_disabled);
+		atomic_add(RESET_BIT, &cpu_buffer->resize_disabled);
 		atomic_inc(&cpu_buffer->record_disabled);
 	}
 
 	/* Make sure all commits have finished */
 	synchronize_rcu();
 
-	for_each_online_buffer_cpu(buffer, cpu) {
+	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
 
+		/*
+		 * If a CPU came online during the synchronize_rcu(), then
+		 * ignore it.
+		 */
+		if (!(atomic_read(&cpu_buffer->resize_disabled) & RESET_BIT))
+			continue;
+
 		reset_disabled_cpu_buffer(cpu_buffer);
 
 		atomic_dec(&cpu_buffer->record_disabled);
-		atomic_dec(&cpu_buffer->resize_disabled);
+		atomic_sub(RESET_BIT, &cpu_buffer->resize_disabled);
 	}
 
 	mutex_unlock(&buffer->mutex);
-- 
2.39.2
