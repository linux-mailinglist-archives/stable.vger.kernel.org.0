Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDBDE63586E
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237094AbiKWJ5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238286AbiKWJ5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:57:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ADD21173D0
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:51:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB440619EB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4114C433D7;
        Wed, 23 Nov 2022 09:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197106;
        bh=42fREDXtixX5TmXMaOKDZj/4zOqal5lcLcf3aWuZGjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UuJDJ5vIFlCkEdaqkAMaUpN7opOF/9ZhakfB2FAFhjyN4VvMOJem4xcOKBW1wdHnB
         ziYebBLP/b/x+AYP17m5DPdLMWuse5b/zo8FDfSxl8roLZN2aHjoR3fnsu7K4QaN9B
         m1Mh/o4InqNckIohnQpfKbIFwZtBDFSDIjhdC3i4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiu Jianfeng <xiujianfeng@huawei.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.0 198/314] ftrace: Fix null pointer dereference in ftrace_add_mod()
Date:   Wed, 23 Nov 2022 09:50:43 +0100
Message-Id: <20221123084634.525363408@linuxfoundation.org>
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

From: Xiu Jianfeng <xiujianfeng@huawei.com>

commit 19ba6c8af9382c4c05dc6a0a79af3013b9a35cd0 upstream.

The @ftrace_mod is allocated by kzalloc(), so both the members {prev,next}
of @ftrace_mode->list are NULL, it's not a valid state to call list_del().
If kstrdup() for @ftrace_mod->{func|module} fails, it goes to @out_free
tag and calls free_ftrace_mod() to destroy @ftrace_mod, then list_del()
will write prev->next and next->prev, where null pointer dereference
happens.

BUG: kernel NULL pointer dereference, address: 0000000000000008
Oops: 0002 [#1] PREEMPT SMP NOPTI
Call Trace:
 <TASK>
 ftrace_mod_callback+0x20d/0x220
 ? do_filp_open+0xd9/0x140
 ftrace_process_regex.isra.51+0xbf/0x130
 ftrace_regex_write.isra.52.part.53+0x6e/0x90
 vfs_write+0xee/0x3a0
 ? __audit_filter_op+0xb1/0x100
 ? auditd_test_task+0x38/0x50
 ksys_write+0xa5/0xe0
 do_syscall_64+0x3a/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
Kernel panic - not syncing: Fatal exception

So call INIT_LIST_HEAD() to initialize the list member to fix this issue.

Link: https://lkml.kernel.org/r/20221116015207.30858-1-xiujianfeng@huawei.com

Cc: stable@vger.kernel.org
Fixes: 673feb9d76ab ("ftrace: Add :mod: caching infrastructure to trace_array")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1289,6 +1289,7 @@ static int ftrace_add_mod(struct trace_a
 	if (!ftrace_mod)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&ftrace_mod->list);
 	ftrace_mod->func = kstrdup(func, GFP_KERNEL);
 	ftrace_mod->module = kstrdup(module, GFP_KERNEL);
 	ftrace_mod->enable = enable;


