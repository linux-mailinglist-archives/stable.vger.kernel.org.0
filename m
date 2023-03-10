Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543E66B44C7
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbjCJO2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:28:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbjCJO14 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:27:56 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BF317CE1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:26:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 122E6CE2918
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9861EC433EF;
        Fri, 10 Mar 2023 14:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458380;
        bh=Lc2wLEVZ5PqZSCE2Szx1C7DEymrnO5bWyJZC6R2SqL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FqnXa1uNtIFxjnncPxqONyzNxx7ZVfKTkwJHNKNrHJ5U0x5C+U92R4HXfB8cBJTiX
         Sl9am8wM5kFEIACZA3rVNs8w0apYWYbSVdiHIUF2wZr/V1fN+Cscb+cSf/YYTYPLdf
         kumMeZWZZxwhDwYs/kpWZTgQ4uWgcd7QVtPHDLPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 230/252] tracing: Add NULL checks for buffer in ring_buffer_free_read_page()
Date:   Fri, 10 Mar 2023 14:40:00 +0100
Message-Id: <20230310133726.273102865@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
index 5e5b0c067f611..bef3d01b8ff61 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -4685,11 +4685,16 @@ EXPORT_SYMBOL_GPL(ring_buffer_alloc_read_page);
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



