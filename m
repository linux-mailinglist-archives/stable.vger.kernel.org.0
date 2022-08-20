Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4325359AE85
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 15:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347573AbiHTNoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 09:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347007AbiHTNny (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 09:43:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F028D252BE;
        Sat, 20 Aug 2022 06:43:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B0C9B80CE5;
        Sat, 20 Aug 2022 13:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7601CC43150;
        Sat, 20 Aug 2022 13:43:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1oPOld-005AOb-2C;
        Sat, 20 Aug 2022 09:44:01 -0400
Message-ID: <20220820134401.513062765@goodmis.org>
User-Agent: quilt/0.66
Date:   Sat, 20 Aug 2022 09:43:22 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2 6/6] tracing: Have filter accept "common_cpu" to be consistent
References: <20220820134316.156058831@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Make filtering consistent with histograms. As "cpu" can be a field of an
event, allow for "common_cpu" to keep it from being confused with the
"cpu" field of the event.

Link: https://lore.kernel.org/all/20220820220920.e42fa32b70505b1904f0a0ad@kernel.org/

Cc: stable@vger.kernel.org
Fixes: 1e3bac71c5053 ("tracing/histogram: Rename "cpu" to "common_cpu"")
Suggested-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 181f08186d32..0356cae0cf74 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -176,6 +176,7 @@ static int trace_define_generic_fields(void)
 
 	__generic_field(int, CPU, FILTER_CPU);
 	__generic_field(int, cpu, FILTER_CPU);
+	__generic_field(int, common_cpu, FILTER_CPU);
 	__generic_field(char *, COMM, FILTER_COMM);
 	__generic_field(char *, comm, FILTER_COMM);
 
-- 
2.35.1
