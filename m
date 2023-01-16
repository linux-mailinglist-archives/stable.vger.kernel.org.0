Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968C166C7EA
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbjAPQfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbjAPQer (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:34:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5473A2A170
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:22:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED1D5B8107A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502AAC433EF;
        Mon, 16 Jan 2023 16:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886161;
        bh=Ng15TaBixRlQW5447WAz/T25zOUEjnHxJthJsBddTr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=suNiQvIj7I1ZCkVaXmGMeMRCPP5wvdSjnBrUb8fzeOYoDPhmJLmQhoOLZ3wIzJIb4
         lksqzs8Qz9OPyNMNOY7LX8wEuIG6Kh1BcEaZUFx6gUmgFJCfBVGBvZrLYmCY3KMYWp
         ZdHpVv/Zhkp9+L0Q9VuJHdmt8XsnruGUhy3cDM2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        =?UTF-8?q?Luis=20Cl=C3=A1udio=20Gon=C3=A7alves?= 
        <lclaudio@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 326/658] perf trace: Factor out the initialization of syscal_arg_fmt->scnprintf
Date:   Mon, 16 Jan 2023 16:46:54 +0100
Message-Id: <20230116154924.476469224@linuxfoundation.org>
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

[ Upstream commit 8d1d4ff5e239d9ef385444bc0d855127d7b32754 ]

We set the default scnprint routines for the syscall args based on its
type or on heuristics based on its names, now we'll use this for
tracepoints as well, so move it out of syscall__set_arg_fmts() and into
a routine that receive just an array of syscall_arg_fmt entries + the
tracepoint format fields list.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Luis Cláudio Gonçalves <lclaudio@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lkml.kernel.org/n/tip-xs3x0zzyes06c7scdsjn01ty@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 03e9a5d8eb55 ("perf trace: Handle failure when trace point folder is missed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 5dc8b123d3f5..175150e90cdc 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1455,15 +1455,16 @@ static int syscall__alloc_arg_fmts(struct syscall *sc, int nr_args)
 	return 0;
 }
 
-static int syscall__set_arg_fmts(struct syscall *sc)
+static struct tep_format_field *
+syscall_arg_fmt__init_array(struct syscall_arg_fmt *arg, struct tep_format_field *field)
 {
-	struct tep_format_field *field, *last_field = NULL;
-	int idx = 0, len;
+	struct tep_format_field *last_field = NULL;
+	int len;
 
-	for (field = sc->args; field; field = field->next, ++idx) {
+	for (; field; field = field->next, ++arg) {
 		last_field = field;
 
-		if (sc->fmt && sc->fmt->arg[idx].scnprintf)
+		if (arg->scnprintf)
 			continue;
 
 		len = strlen(field->name);
@@ -1471,13 +1472,13 @@ static int syscall__set_arg_fmts(struct syscall *sc)
 		if (strcmp(field->type, "const char *") == 0 &&
 		    ((len >= 4 && strcmp(field->name + len - 4, "name") == 0) ||
 		     strstr(field->name, "path") != NULL))
-			sc->arg_fmt[idx].scnprintf = SCA_FILENAME;
+			arg->scnprintf = SCA_FILENAME;
 		else if ((field->flags & TEP_FIELD_IS_POINTER) || strstr(field->name, "addr"))
-			sc->arg_fmt[idx].scnprintf = SCA_PTR;
+			arg->scnprintf = SCA_PTR;
 		else if (strcmp(field->type, "pid_t") == 0)
-			sc->arg_fmt[idx].scnprintf = SCA_PID;
+			arg->scnprintf = SCA_PID;
 		else if (strcmp(field->type, "umode_t") == 0)
-			sc->arg_fmt[idx].scnprintf = SCA_MODE_T;
+			arg->scnprintf = SCA_MODE_T;
 		else if ((strcmp(field->type, "int") == 0 ||
 			  strcmp(field->type, "unsigned int") == 0 ||
 			  strcmp(field->type, "long") == 0) &&
@@ -1489,10 +1490,17 @@ static int syscall__set_arg_fmts(struct syscall *sc)
 			 * 23 unsigned int
 			 * 7 unsigned long
 			 */
-			sc->arg_fmt[idx].scnprintf = SCA_FD;
+			arg->scnprintf = SCA_FD;
 		}
 	}
 
+	return last_field;
+}
+
+static int syscall__set_arg_fmts(struct syscall *sc)
+{
+	struct tep_format_field *last_field = syscall_arg_fmt__init_array(sc->arg_fmt, sc->args);
+
 	if (last_field)
 		sc->args_size = last_field->offset + last_field->size;
 
-- 
2.35.1



