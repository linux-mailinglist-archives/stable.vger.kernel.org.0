Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19BC266C7EC
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbjAPQfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233389AbjAPQfJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:35:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77E12A99A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:22:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 652CF61027
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B502C433D2;
        Mon, 16 Jan 2023 16:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886166;
        bh=hAGJjBj+YllbPWUwtRRBsl9ezoiQq/SEtOdA5WI/l18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x8vysd92UIsSxuVG8OY0JN6JUdM5sDK0f/PSpX3D8ODrXRf/b64BMJYvfy8IdfbvE
         WyW6Z9w1Ph089tkZrzq1/LFIjOOQZd2VCGdPqzyTusb2EZiQhKt0Nts/g5PflxbQQs
         ysKrydREQwKVup0gmLL0Ri2nenMajFCS3AqYeby0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 328/658] perf trace: Allow associating scnprintf routines with well known arg names
Date:   Mon, 16 Jan 2023 16:46:56 +0100
Message-Id: <20230116154924.558372844@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 5d88099bc00dccddf5da18e25e1223f01644f7a2 ]

For instance 'msr' appears in several tracepoints, so we can associate
it with a single scnprintf() routine auto-generated from kernel headers,
as will be done in followup patches.

Start with an empty array of associations.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lkml.kernel.org/n/tip-89ptht6s5fez82lykuwq1eyb@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 03e9a5d8eb55 ("perf trace: Handle failure when trace point folder is missed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index e01952883cbc..02cf39970ed0 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1455,6 +1455,27 @@ static int syscall__alloc_arg_fmts(struct syscall *sc, int nr_args)
 	return 0;
 }
 
+static struct syscall_arg_fmt syscall_arg_fmts__by_name[] = {
+};
+
+static int syscall_arg_fmt__cmp(const void *name, const void *fmtp)
+{
+       const struct syscall_arg_fmt *fmt = fmtp;
+       return strcmp(name, fmt->name);
+}
+
+static struct syscall_arg_fmt *
+__syscall_arg_fmt__find_by_name(struct syscall_arg_fmt *fmts, const int nmemb, const char *name)
+{
+       return bsearch(name, fmts, nmemb, sizeof(struct syscall_arg_fmt), syscall_arg_fmt__cmp);
+}
+
+static struct syscall_arg_fmt *syscall_arg_fmt__find_by_name(const char *name)
+{
+       const int nmemb = ARRAY_SIZE(syscall_arg_fmts__by_name);
+       return __syscall_arg_fmt__find_by_name(syscall_arg_fmts__by_name, nmemb, name);
+}
+
 static struct tep_format_field *
 syscall_arg_fmt__init_array(struct syscall_arg_fmt *arg, struct tep_format_field *field)
 {
@@ -1491,6 +1512,11 @@ syscall_arg_fmt__init_array(struct syscall_arg_fmt *arg, struct tep_format_field
 			 * 7 unsigned long
 			 */
 			arg->scnprintf = SCA_FD;
+               } else {
+			struct syscall_arg_fmt *fmt = syscall_arg_fmt__find_by_name(field->name);
+
+			if (fmt)
+				arg->scnprintf = fmt->scnprintf;
 		}
 	}
 
-- 
2.35.1



