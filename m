Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDA3635877
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237119AbiKWJ6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238306AbiKWJ5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:57:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9B06E541
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:51:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84979B81EF1
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC020C433D6;
        Wed, 23 Nov 2022 09:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197114;
        bh=KMf8Pr326wL+ps9YlSWYE+8gsnC6rCxwWK1Q/m0/9xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/FEK1YStRmU/HCZQJmDKFcLzsXMQWVwnq7GwEdF8Gu/v5CY4IdSe2d3BKxOtIH13
         /kzGEa8nkKD/0D6Hst8Q8McAXdUjudTeyWvTeWq6OXhLBmBSRjJ65iXUNx+zqynRUz
         IGd4cEDAllm9PGI27KBtMYKGr92ouf9BQX7my35I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        Wang Yufen <wangyufen@huawei.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.0 200/314] tracing: Fix memory leak in tracing_read_pipe()
Date:   Wed, 23 Nov 2022 09:50:45 +0100
Message-Id: <20221123084634.620249794@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Yufen <wangyufen@huawei.com>

commit 649e72070cbbb8600eb823833e4748f5a0815116 upstream.

kmemleak reports this issue:

unreferenced object 0xffff888105a18900 (size 128):
  comm "test_progs", pid 18933, jiffies 4336275356 (age 22801.766s)
  hex dump (first 32 bytes):
    25 73 00 90 81 88 ff ff 26 05 00 00 42 01 58 04  %s......&...B.X.
    03 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000560143a1>] __kmalloc_node_track_caller+0x4a/0x140
    [<000000006af00822>] krealloc+0x8d/0xf0
    [<00000000c309be6a>] trace_iter_expand_format+0x99/0x150
    [<000000005a53bdb6>] trace_check_vprintf+0x1e0/0x11d0
    [<0000000065629d9d>] trace_event_printf+0xb6/0xf0
    [<000000009a690dc7>] trace_raw_output_bpf_trace_printk+0x89/0xc0
    [<00000000d22db172>] print_trace_line+0x73c/0x1480
    [<00000000cdba76ba>] tracing_read_pipe+0x45c/0x9f0
    [<0000000015b58459>] vfs_read+0x17b/0x7c0
    [<000000004aeee8ed>] ksys_read+0xed/0x1c0
    [<0000000063d3d898>] do_syscall_64+0x3b/0x90
    [<00000000a06dda7f>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

iter->fmt alloced in
  tracing_read_pipe() -> .. ->trace_iter_expand_format(), but not
freed, to fix, add free in tracing_release_pipe()

Link: https://lkml.kernel.org/r/1667819090-4643-1-git-send-email-wangyufen@huawei.com

Cc: stable@vger.kernel.org
Fixes: efbbdaa22bb7 ("tracing: Show real address for trace event arguments")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6657,6 +6657,7 @@ static int tracing_release_pipe(struct i
 	mutex_unlock(&trace_types_lock);
 
 	free_cpumask_var(iter->started);
+	kfree(iter->fmt);
 	mutex_destroy(&iter->mutex);
 	kfree(iter);
 


