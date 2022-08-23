Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1043759DA5F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352379AbiHWKH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352825AbiHWKGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:06:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69D4319;
        Tue, 23 Aug 2022 01:53:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6779E6150F;
        Tue, 23 Aug 2022 08:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C99C433C1;
        Tue, 23 Aug 2022 08:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244793;
        bh=JJQsM5JWENzuqdyo+/3XXUqAE06ZPzjerTGhvXhu4zE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzewZks/I2xr6oI7vB/N/h7vl5+nBNFIMYzRDFDolsSvZ0vDtP3xzTjzwejQ4O359
         +nFBQX375SvKGs0+iMn5bVz7jrEhpkjIbEr16XU366I8ZgD+GLiC0BLI0GDNRy/nK5
         tYrzeuXcDk8o62bvZGKfrCKKUogEYOImDxY0Z/9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 153/244] tracing/eprobes: Fix reading of string fields
Date:   Tue, 23 Aug 2022 10:25:12 +0200
Message-Id: <20220823080104.290604565@linuxfoundation.org>
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

commit f04dec93466a0481763f3b56cdadf8076e28bfbf upstream.

Currently when an event probe (eprobe) hooks to a string field, it does
not display it as a string, but instead as a number. This makes the field
rather useless. Handle the different kinds of strings, dynamic, static,
relational/dynamic etc.

Now when a string field is used, the ":string" type can be used to display
it:

  echo "e:sw sched/sched_switch comm=$next_comm:string" > dynamic_events

Link: https://lkml.kernel.org/r/20220820134400.959640191@goodmis.org

Cc: stable@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Fixes: 7491e2c44278 ("tracing: Add a probe that attaches to trace events")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_eprobe.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -320,6 +320,24 @@ static unsigned long get_event_field(str
 
 	addr = rec + field->offset;
 
+	if (is_string_field(field)) {
+		switch (field->filter_type) {
+		case FILTER_DYN_STRING:
+			val = (unsigned long)(rec + (*(unsigned int *)addr & 0xffff));
+			break;
+		case FILTER_STATIC_STRING:
+			val = (unsigned long)addr;
+			break;
+		case FILTER_PTR_STRING:
+			val = (unsigned long)(*(char *)addr);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			return 0;
+		}
+		return val;
+	}
+
 	switch (field->size) {
 	case 1:
 		if (field->is_signed)


