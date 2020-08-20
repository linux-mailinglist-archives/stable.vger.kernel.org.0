Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4829B24BA0C
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729680AbgHTL7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:59:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730470AbgHTKAa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:00:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA85D2067C;
        Thu, 20 Aug 2020 10:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917629;
        bh=Ufv5Fx44hDnuVdzftqL2oVkVK3AeNeJDQaw3U2xVTXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jfYye3vZGXJHVqY3VizcsjylHwwsVnulwtORk0JfYiWYLTl4DSYVuSXZhzpL3kvC1
         Tw0ibp6qJNZqYl71bx4nHv0P21vSsp/A1aw/QlfYfOgn3GYJ/KEtHfUEgQCKs/i0oH
         RbPXqY9YWE52V96fBekNgOzeafewZZKiW0+vqnWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Philippe Duplessis-Guindon <pduplessis@efficios.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 069/212] tools lib traceevent: Fix memory leak in process_dynamic_array_len
Date:   Thu, 20 Aug 2020 11:20:42 +0200
Message-Id: <20200820091605.848342296@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philippe Duplessis-Guindon <pduplessis@efficios.com>

[ Upstream commit e24c6447ccb7b1a01f9bf0aec94939e6450c0b4d ]

I compiled with AddressSanitizer and I had these memory leaks while I
was using the tep_parse_format function:

    Direct leak of 28 byte(s) in 4 object(s) allocated from:
        #0 0x7fb07db49ffe in __interceptor_realloc (/lib/x86_64-linux-gnu/libasan.so.5+0x10dffe)
        #1 0x7fb07a724228 in extend_token /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:985
        #2 0x7fb07a724c21 in __read_token /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:1140
        #3 0x7fb07a724f78 in read_token /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:1206
        #4 0x7fb07a725191 in __read_expect_type /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:1291
        #5 0x7fb07a7251df in read_expect_type /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:1299
        #6 0x7fb07a72e6c8 in process_dynamic_array_len /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:2849
        #7 0x7fb07a7304b8 in process_function /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:3161
        #8 0x7fb07a730900 in process_arg_token /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:3207
        #9 0x7fb07a727c0b in process_arg /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:1786
        #10 0x7fb07a731080 in event_read_print_args /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:3285
        #11 0x7fb07a731722 in event_read_print /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:3369
        #12 0x7fb07a740054 in __tep_parse_format /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:6335
        #13 0x7fb07a74047a in __parse_event /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:6389
        #14 0x7fb07a740536 in tep_parse_format /home/pduplessis/repo/linux/tools/lib/traceevent/event-parse.c:6431
        #15 0x7fb07a785acf in parse_event ../../../src/fs-src/fs.c:251
        #16 0x7fb07a785ccd in parse_systems ../../../src/fs-src/fs.c:284
        #17 0x7fb07a786fb3 in read_metadata ../../../src/fs-src/fs.c:593
        #18 0x7fb07a78760e in ftrace_fs_source_init ../../../src/fs-src/fs.c:727
        #19 0x7fb07d90c19c in add_component_with_init_method_data ../../../../src/lib/graph/graph.c:1048
        #20 0x7fb07d90c87b in add_source_component_with_initialize_method_data ../../../../src/lib/graph/graph.c:1127
        #21 0x7fb07d90c92a in bt_graph_add_source_component ../../../../src/lib/graph/graph.c:1152
        #22 0x55db11aa632e in cmd_run_ctx_create_components_from_config_components ../../../src/cli/babeltrace2.c:2252
        #23 0x55db11aa6fda in cmd_run_ctx_create_components ../../../src/cli/babeltrace2.c:2347
        #24 0x55db11aa780c in cmd_run ../../../src/cli/babeltrace2.c:2461
        #25 0x55db11aa8a7d in main ../../../src/cli/babeltrace2.c:2673
        #26 0x7fb07d5460b2 in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x270b2)

The token variable in the process_dynamic_array_len function is
allocated in the read_expect_type function, but is not freed before
calling the read_token function.

Free the token variable before calling read_token in order to plug the
leak.

Signed-off-by: Philippe Duplessis-Guindon <pduplessis@efficios.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Link: https://lore.kernel.org/linux-trace-devel/20200730150236.5392-1-pduplessis@efficios.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/traceevent/event-parse.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 62f4cacf253ab..b9db8739487dc 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2764,6 +2764,7 @@ process_dynamic_array_len(struct event_format *event, struct print_arg *arg,
 	if (read_expected(EVENT_DELIM, ")") < 0)
 		goto out_err;
 
+	free_token(token);
 	type = read_token(&token);
 	*tok = token;
 
-- 
2.25.1



