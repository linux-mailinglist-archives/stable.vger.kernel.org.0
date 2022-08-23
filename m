Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F95359D9B8
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243095AbiHWKA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239339AbiHWJ6z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:58:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE136FA13;
        Tue, 23 Aug 2022 01:48:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81462B81C66;
        Tue, 23 Aug 2022 08:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D575AC433C1;
        Tue, 23 Aug 2022 08:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244184;
        bh=8JdS3sLV+wxFTBujS2gA+PG7URNVNxZCqEuDH7Q+Seo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WXXE8H6fWeXjT3JUtViPlUYBQ3Vew5HkqiDRHzDrKG1byiBVkHoBAwwzh3LeC1LqG
         t7GzAQB0t+bNm2LYUac/dpDijiWuO4xFc1vaHByTx8GSAi25DSPd4TpZ1nRM/Hi8Nl
         yT7a2tKCh7Slhm+daLlNSXJo4Qcc0FVamCmXHBNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 021/244] tracing/eprobes: Do not hardcode $comm as a string
Date:   Tue, 23 Aug 2022 10:23:00 +0200
Message-Id: <20220823080059.775899567@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 02333de90e5945e2fe7fc75b15b4eb9aee187f0a upstream.

The variable $comm is hard coded as a string, which is true for both
kprobes and uprobes, but for event probes (eprobes) it is a field name. In
most cases the "comm" field would be a string, but there's no guarantee of
that fact.

Do not assume that comm is a string. Not to mention, it currently forces
comm fields to fault, as string processing for event probes is currently
broken.

Link: https://lkml.kernel.org/r/20220820134400.756152112@goodmis.org

Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Fixes: 7491e2c44278 ("tracing: Add a probe that attaches to trace events")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -618,9 +618,10 @@ static int traceprobe_parse_probe_arg_bo
 
 	/*
 	 * Since $comm and immediate string can not be dereferenced,
-	 * we can find those by strcmp.
+	 * we can find those by strcmp. But ignore for eprobes.
 	 */
-	if (strcmp(arg, "$comm") == 0 || strncmp(arg, "\\\"", 2) == 0) {
+	if (!(flags & TPARG_FL_TPOINT) &&
+	    (strcmp(arg, "$comm") == 0 || strncmp(arg, "\\\"", 2) == 0)) {
 		/* The type of $comm must be "string", and not an array. */
 		if (parg->count || (t && strcmp(t, "string")))
 			goto out;


