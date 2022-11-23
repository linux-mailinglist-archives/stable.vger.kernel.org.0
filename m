Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45DBA63593D
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236565AbiKWKIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236879AbiKWKGq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:06:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED79413CEE
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:57:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B7FA61B29
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A3DC433C1;
        Wed, 23 Nov 2022 09:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197443;
        bh=MFevkjK4Km5E5MgdatlZan6/En6MRZnPBJO5ogmUvr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YWmsYsxU5nEOkcBFN1LXrg6qHvvqF64O4Aw/cle1QWdZ9euU7iioflSczLBiMMnCZ
         NGcnXBxI/85HjXcGc4ymSXppmcON3kaiMIwqF1GiHivIt2RA4nbmxGjryXheqhyWLB
         Zo4l+9AiIgkwJj+dfOe5ZCbg47lli8P+TT/OvoCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zheng Yejian <zhengyejian1@huawei.com>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 295/314] tracing: Fix potential null-pointer-access of entry in list tr->err_log
Date:   Wed, 23 Nov 2022 09:52:20 +0100
Message-Id: <20221123084638.893376943@linuxfoundation.org>
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

From: Zheng Yejian <zhengyejian1@huawei.com>

[ Upstream commit 067df9e0ad48a97382ab2179bbe773a13a846028 ]

Entries in list 'tr->err_log' will be reused after entry number
exceed TRACING_LOG_ERRS_MAX.

The cmd string of the to be reused entry will be freed first then
allocated a new one. If the allocation failed, then the entry will
still be in list 'tr->err_log' but its 'cmd' field is set to be NULL,
later access of 'cmd' is risky.

Currently above problem can cause the loss of 'cmd' information of first
entry in 'tr->err_log'. When execute `cat /sys/kernel/tracing/error_log`,
reproduce logs like:
  [   37.495100] trace_kprobe: error: Maxactive is not for kprobe(null) ^
  [   38.412517] trace_kprobe: error: Maxactive is not for kprobe
    Command: p4:myprobe2 do_sys_openat2
            ^

Link: https://lore.kernel.org/linux-trace-kernel/20221114104632.3547266-1-zhengyejian1@huawei.com

Fixes: 1581a884b7ca ("tracing: Remove size restriction on tracing_log_err cmd strings")
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 87d2f04152f9..7132e21e90d6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -7803,6 +7803,7 @@ static struct tracing_log_err *get_tracing_log_err(struct trace_array *tr,
 						   int len)
 {
 	struct tracing_log_err *err;
+	char *cmd;
 
 	if (tr->n_err_log_entries < TRACING_LOG_ERRS_MAX) {
 		err = alloc_tracing_log_err(len);
@@ -7811,12 +7812,12 @@ static struct tracing_log_err *get_tracing_log_err(struct trace_array *tr,
 
 		return err;
 	}
-
+	cmd = kzalloc(len, GFP_KERNEL);
+	if (!cmd)
+		return ERR_PTR(-ENOMEM);
 	err = list_first_entry(&tr->err_log, struct tracing_log_err, list);
 	kfree(err->cmd);
-	err->cmd = kzalloc(len, GFP_KERNEL);
-	if (!err->cmd)
-		return ERR_PTR(-ENOMEM);
+	err->cmd = cmd;
 	list_del(&err->list);
 
 	return err;
-- 
2.35.1



