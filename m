Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F111548ACC
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349381AbiFMLAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350904AbiFMK7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:59:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7EB25EB7;
        Mon, 13 Jun 2022 03:32:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6505FB80EAA;
        Mon, 13 Jun 2022 10:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC926C34114;
        Mon, 13 Jun 2022 10:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116359;
        bh=Q01MA/xE19LFBgpdqYkg0EJBDx4BvOaJ2SbB90FT5Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZfPRCIWc/qjbYbanx4jHhxZwiO7yR0B9xsQsqrfTEckqbNzJI6CrQl4TPn8AQjy1/
         iRyNNtbCmGS2xM6u3L3bffDv4y5LLkOicYdZLtRqMGe20Otg1Pe4p68gElKkVqyCke
         /jDoV9CaowIgp5oHxz0O7VD22QwX6lTXtmHWVauk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 167/218] tracing: Avoid adding tracer option before update_tracer_options
Date:   Mon, 13 Jun 2022 12:10:25 +0200
Message-Id: <20220613094925.667541682@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
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
index aaf1194be551..60a1733abbb7 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5363,12 +5363,18 @@ static void tracing_set_nop(struct trace_array *tr)
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
 
@@ -7733,6 +7739,7 @@ static void __update_tracer_options(struct trace_array *tr)
 static void update_tracer_options(struct trace_array *tr)
 {
 	mutex_lock(&trace_types_lock);
+	tracer_options_updated = true;
 	__update_tracer_options(tr);
 	mutex_unlock(&trace_types_lock);
 }
-- 
2.35.1



