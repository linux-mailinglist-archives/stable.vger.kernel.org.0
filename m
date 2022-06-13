Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956AC5492C3
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383695AbiFMO1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384019AbiFMOY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:24:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C29BC0A;
        Mon, 13 Jun 2022 04:46:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA74D612A8;
        Mon, 13 Jun 2022 11:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F31C34114;
        Mon, 13 Jun 2022 11:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120788;
        bh=O0/tWyjSGTu6G0J37ooYuiNFAnqvqQ2I6bdZCgaSRK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jGoQd6pgfdNKIPUE9kDHFTTM19P0YxsPJNbpLthA4efb/rw6cJYqXrnmkV6dKfeh2
         8tCcx7Zu4yib24KEG2tcCJevSYcxt8mXf8cqv3YzTx/whhQg0JZGNB/j5oKQ7XlT8g
         sHN4h+TcxxHtK0x0iDrwD4I92pYBIt+vJMplqWSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 140/298] tracing: Avoid adding tracer option before update_tracer_options
Date:   Mon, 13 Jun 2022 12:10:34 +0200
Message-Id: <20220613094929.190055753@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark-PK Tsai <mark-pk.tsai@mediatek.com>

[ Upstream commit ef9188bcc6ca1d8a2ad83e826b548e6820721061 ]

To prepare for support asynchronous tracer_init_tracefs initcall,
avoid calling create_trace_option_files before __update_tracer_options.
Otherwise, create_trace_option_files will show warning because
some tracers in trace_types list are already in tr->topts.

For example, hwlat_tracer call register_tracer in late_initcall,
and global_trace.dir is already created in tracing_init_dentry,
hwlat_tracer will be put into tr->topts.
Then if the __update_tracer_options is executed after hwlat_tracer
registered, create_trace_option_files find that hwlat_tracer is
already in tr->topts.

Link: https://lkml.kernel.org/r/20220426122407.17042-2-mark-pk.tsai@mediatek.com

Link: https://lore.kernel.org/lkml/20220322133339.GA32582@xsang-OptiPlex-9020/
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b741704dcd46..7ebf42607505 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6324,12 +6324,18 @@ static void tracing_set_nop(struct trace_array *tr)
 	tr->current_trace = &nop_trace;
 }
 
+static bool tracer_options_updated;
+
 static void add_tracer_options(struct trace_array *tr, struct tracer *t)
 {
 	/* Only enable if the directory has been created already. */
 	if (!tr->dir)
 		return;
 
+	/* Only create trace option files after update_tracer_options finish */
+	if (!tracer_options_updated)
+		return;
+
 	create_trace_option_files(tr, t);
 }
 
@@ -9139,6 +9145,7 @@ static void __update_tracer_options(struct trace_array *tr)
 static void update_tracer_options(struct trace_array *tr)
 {
 	mutex_lock(&trace_types_lock);
+	tracer_options_updated = true;
 	__update_tracer_options(tr);
 	mutex_unlock(&trace_types_lock);
 }
-- 
2.35.1



