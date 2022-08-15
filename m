Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD2B593B95
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345773AbiHOUER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345780AbiHOUD0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:03:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF107E022;
        Mon, 15 Aug 2022 11:54:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91102611D6;
        Mon, 15 Aug 2022 18:54:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16186C433D6;
        Mon, 15 Aug 2022 18:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589655;
        bh=0dG4uuL291nO1aV8Tjx0Cq3qOuuLfuwV842Ght+TL5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mac2T1PVCxmOtUJ1WiFKMJVHTVvUKAvZGGMWgQAEsJspn6v0L/LcO94ps8y4mGpFi
         DhwRpf6kYrCWZg40NCyxmpWJAleQNVUDCRXzZAjd4i5ORE2XVqCIK26ZSsVLxL+RI8
         0eb3oWG9oS0P+TvSMrEC1yGU4wkoX7diWgPVKl3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.15 770/779] tracing/perf: Avoid -Warray-bounds warning for __rel_loc macro
Date:   Mon, 15 Aug 2022 20:06:54 +0200
Message-Id: <20220815180410.302077206@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

commit c6d777acdf8f62d4ebaef0e5c6cd8fedbd6e8546 upstream.

As done for trace_events.h, also fix the __rel_loc macro in perf.h,
which silences the -Warray-bounds warning:

In file included from ./include/linux/string.h:253,
                 from ./include/linux/bitmap.h:11,
                 from ./include/linux/cpumask.h:12,
                 from ./include/linux/mm_types_task.h:14,
                 from ./include/linux/mm_types.h:5,
                 from ./include/linux/buildid.h:5,
                 from ./include/linux/module.h:14,
                 from samples/trace_events/trace-events-sample.c:2:
In function '__fortify_strcpy',
    inlined from 'perf_trace_foo_rel_loc' at samples/trace_events/./trace-events-sample.h:519:1:
./include/linux/fortify-string.h:47:33: warning: '__builtin_strcpy' offset 12 is out of the bounds [
0, 4] [-Warray-bounds]
   47 | #define __underlying_strcpy     __builtin_strcpy
      |                                 ^
./include/linux/fortify-string.h:445:24: note: in expansion of macro '__underlying_strcpy'
  445 |                 return __underlying_strcpy(p, q);
      |                        ^~~~~~~~~~~~~~~~~~~

Also make __data struct member a proper flexible array to avoid future
problems.

Link: https://lkml.kernel.org/r/20220125220037.2738923-1-keescook@chromium.org

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Fixes: 55de2c0b5610c ("tracing: Add '__rel_loc' using trace event macros")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/perf.h         |    5 +++--
 include/trace/trace_events.h |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/include/trace/perf.h
+++ b/include/trace/perf.h
@@ -23,8 +23,9 @@
 
 #undef __get_rel_dynamic_array
 #define __get_rel_dynamic_array(field)	\
-		((void *)(&__entry->__rel_loc_##field) +	\
-		 sizeof(__entry->__rel_loc_##field) +		\
+		((void *)__entry +					\
+		 offsetof(typeof(*__entry), __rel_loc_##field) +	\
+		 sizeof(__entry->__rel_loc_##field) +			\
 		 (__entry->__rel_loc_##field & 0xffff))
 
 #undef __get_rel_dynamic_array_len
--- a/include/trace/trace_events.h
+++ b/include/trace/trace_events.h
@@ -128,7 +128,7 @@ TRACE_MAKE_SYSTEM_STR();
 	struct trace_event_raw_##name {					\
 		struct trace_entry	ent;				\
 		tstruct							\
-		char			__data[0];			\
+		char			__data[];			\
 	};								\
 									\
 	static struct trace_event_class event_class_##name;


