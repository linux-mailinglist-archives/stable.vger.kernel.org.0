Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D36D69CD1F
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbjBTNql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbjBTNqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:46:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E3C1E1F0;
        Mon, 20 Feb 2023 05:46:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C97F660E9D;
        Mon, 20 Feb 2023 13:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D329DC4339C;
        Mon, 20 Feb 2023 13:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900776;
        bh=IIAZkeSpEKS2KPTxBOcC+lHxfz0OjPj0TExQ7GtJOlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EiwCTSGV9XSZiocjWRMQQ/uVnxP+la+RGFQQptkzP9I+6xa+zayKl1uxcy0GX3cVj
         gPdS27aKzP8ycwDSc6HZLt/H6kCBLMEa33hEk65GbeEDND5OK/U8SM0lC/Go1lqlgT
         fzmVw1Ygp3VI5mPjqhlylZ7TSn4dIecT2bzvZMJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, mhiramat@kernel.org, mchehab@kernel.org,
        linux-edac@vger.kernel.org, Shiju Jose <shiju.jose@huawei.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 063/156] tracing: Fix poll() and select() do not work on per_cpu trace_pipe and trace_pipe_raw
Date:   Mon, 20 Feb 2023 14:35:07 +0100
Message-Id: <20230220133604.973586507@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shiju Jose <shiju.jose@huawei.com>

commit 3e46d910d8acf94e5360126593b68bf4fee4c4a1 upstream.

poll() and select() on per_cpu trace_pipe and trace_pipe_raw do not work
since kernel 6.1-rc6. This issue is seen after the commit
42fb0a1e84ff525ebe560e2baf9451ab69127e2b ("tracing/ring-buffer: Have
polling block on watermark").

This issue is firstly detected and reported, when testing the CXL error
events in the rasdaemon and also erified using the test application for poll()
and select().

This issue occurs for the per_cpu case, when calling the ring_buffer_poll_wait(),
in kernel/trace/ring_buffer.c, with the buffer_percent > 0 and then wait until the
percentage of pages are available. The default value set for the buffer_percent is 50
in the kernel/trace/trace.c.

As a fix, allow userspace application could set buffer_percent as 0 through
the buffer_percent_fops, so that the task will wake up as soon as data is added
to any of the specific cpu buffer.

Link: https://lore.kernel.org/linux-trace-kernel/20230202182309.742-2-shiju.jose@huawei.com

Cc: <mhiramat@kernel.org>
Cc: <mchehab@kernel.org>
Cc: <linux-edac@vger.kernel.org>
Cc: stable@vger.kernel.org
Fixes: 42fb0a1e84ff5 ("tracing/ring-buffer: Have polling block on watermark")
Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8298,9 +8298,6 @@ buffer_percent_write(struct file *filp,
 	if (val > 100)
 		return -EINVAL;
 
-	if (!val)
-		val = 1;
-
 	tr->buffer_percent = val;
 
 	(*ppos)++;


