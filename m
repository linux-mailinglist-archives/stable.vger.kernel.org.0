Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCDF16E61C5
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbjDRM1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbjDRM1k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:27:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8671C468D
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:27:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 492AB63170
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D518C433EF;
        Tue, 18 Apr 2023 12:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820775;
        bh=H7ETroV+sNXrBMadLUCC9OA6FHDGu0nLlXhuWSqHFHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vdhSVVJ1Wwl68IKjJxDYRtPsBfSiHUQlpDvEvteRSDDQFqunkKBhDTmdRuC7YqfeX
         e9k5tiQs5Bjo5gaK/oHqKahu9YDHnifG8uG8QHYZjTFmRJ5TbvXpcKHU+0zLA/jdzZ
         QtQa16Gaj2eQUDmgOMK2nVJIicbVtmcYvhd4kHTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Zheng Yejian <zhengyejian1@huawei.com>
Subject: [PATCH 4.19 26/57] ring-buffer: Fix race while reader and writer are on the same page
Date:   Tue, 18 Apr 2023 14:21:26 +0200
Message-Id: <20230418120259.659093236@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
References: <20230418120258.713853188@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yejian <zhengyejian1@huawei.com>

commit 6455b6163d8c680366663cdb8c679514d55fc30c upstream.

When user reads file 'trace_pipe', kernel keeps printing following logs
that warn at "cpu_buffer->reader_page->read > rb_page_size(reader)" in
rb_get_reader_page(). It just looks like there's an infinite loop in
tracing_read_pipe(). This problem occurs several times on arm64 platform
when testing v5.10 and below.

  Call trace:
   rb_get_reader_page+0x248/0x1300
   rb_buffer_peek+0x34/0x160
   ring_buffer_peek+0xbc/0x224
   peek_next_entry+0x98/0xbc
   __find_next_entry+0xc4/0x1c0
   trace_find_next_entry_inc+0x30/0x94
   tracing_read_pipe+0x198/0x304
   vfs_read+0xb4/0x1e0
   ksys_read+0x74/0x100
   __arm64_sys_read+0x24/0x30
   el0_svc_common.constprop.0+0x7c/0x1bc
   do_el0_svc+0x2c/0x94
   el0_svc+0x20/0x30
   el0_sync_handler+0xb0/0xb4
   el0_sync+0x160/0x180

Then I dump the vmcore and look into the problematic per_cpu ring_buffer,
I found that tail_page/commit_page/reader_page are on the same page while
reader_page->read is obviously abnormal:
  tail_page == commit_page == reader_page == {
    .write = 0x100d20,
    .read = 0x8f9f4805,  // Far greater than 0xd20, obviously abnormal!!!
    .entries = 0x10004c,
    .real_end = 0x0,
    .page = {
      .time_stamp = 0x857257416af0,
      .commit = 0xd20,  // This page hasn't been full filled.
      // .data[0...0xd20] seems normal.
    }
 }

The root cause is most likely the race that reader and writer are on the
same page while reader saw an event that not fully committed by writer.

To fix this, add memory barriers to make sure the reader can see the
content of what is committed. Since commit a0fcaaed0c46 ("ring-buffer: Fix
race between reset page and reading page") has added the read barrier in
rb_get_reader_page(), here we just need to add the write barrier.

Link: https://lore.kernel.org/linux-trace-kernel/20230325021247.2923907-1-zhengyejian1@huawei.com

Cc: stable@vger.kernel.org
Fixes: 77ae365eca89 ("ring-buffer: make lockless")
Suggested-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2463,6 +2463,10 @@ rb_set_commit_to_write(struct ring_buffe
 		if (RB_WARN_ON(cpu_buffer,
 			       rb_is_reader_page(cpu_buffer->tail_page)))
 			return;
+		/*
+		 * No need for a memory barrier here, as the update
+		 * of the tail_page did it for this page.
+		 */
 		local_set(&cpu_buffer->commit_page->page->commit,
 			  rb_page_write(cpu_buffer->commit_page));
 		rb_inc_page(cpu_buffer, &cpu_buffer->commit_page);
@@ -2476,6 +2480,8 @@ rb_set_commit_to_write(struct ring_buffe
 	while (rb_commit_index(cpu_buffer) !=
 	       rb_page_write(cpu_buffer->commit_page)) {
 
+		/* Make sure the readers see the content of what is committed. */
+		smp_wmb();
 		local_set(&cpu_buffer->commit_page->page->commit,
 			  rb_page_write(cpu_buffer->commit_page));
 		RB_WARN_ON(cpu_buffer,
@@ -3841,7 +3847,12 @@ rb_get_reader_page(struct ring_buffer_pe
 
 	/*
 	 * Make sure we see any padding after the write update
-	 * (see rb_reset_tail())
+	 * (see rb_reset_tail()).
+	 *
+	 * In addition, a writer may be writing on the reader page
+	 * if the page has not been fully filled, so the read barrier
+	 * is also needed to make sure we see the content of what is
+	 * committed by the writer (see rb_set_commit_to_write()).
 	 */
 	smp_rmb();
 


