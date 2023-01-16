Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9ACE66C7F2
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbjAPQft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233396AbjAPQfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:35:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6362A9A9
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:22:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07B1660FE0
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E995C433D2;
        Mon, 16 Jan 2023 16:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886169;
        bh=X/4xiLLiHkCLmbuMYIyRjuRK9tHSboBotirw74B7WM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oKBtNK0olkKNNhuOllLBF/Vgm2zH/3llVjflUcSvTeP2FS928Dj4L/B59Ckgqe1u9
         xTGy01g3EzFH4pT8q7t/0odPxY25qPiEpXTCaSfN1uG6Dma5KFNv7RoEl63T5dTKWT
         ezGYwvjvQ9GjgzkXTB5GK0e4Dckx1a4Ty8P0bCE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adrian Hunter <adrian.hunter@intel.com>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        =?UTF-8?q?Luis=20Cl=C3=A1udio=20Gon=C3=A7alves?= 
        <lclaudio@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 329/658] perf trace: Add a strtoul() method to struct syscall_arg_fmt
Date:   Mon, 16 Jan 2023 16:46:57 +0100
Message-Id: <20230116154924.608433452@linuxfoundation.org>
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

[ Upstream commit 3f41b77843b338e836f52cc2d486be689d6cb9c1 ]

This will go from a string to a number, so that filter expressions can
be constructed with strings and then, before applying the tracepoint
filters (or eBPF, in the future) we can map those strings to numbers.

The first one will be for 'msr' tracepoint arguments, but real quickly
we will be able to reuse all strarrays for that.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Brendan Gregg <brendan.d.gregg@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Luis Cláudio Gonçalves <lclaudio@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lkml.kernel.org/n/tip-wgqq48agcgr95b8dmn6fygtr@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 03e9a5d8eb55 ("perf trace: Handle failure when trace point folder is missed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 02cf39970ed0..4cb3252623f5 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -86,8 +86,12 @@
 # define F_LINUX_SPECIFIC_BASE	1024
 #endif
 
+/*
+ * strtoul: Go from a string to a value, i.e. for msr: MSR_FS_BASE to 0xc0000100
+ */
 struct syscall_arg_fmt {
 	size_t	   (*scnprintf)(char *bf, size_t size, struct syscall_arg *arg);
+	bool	   (*strtoul)(char *bf, size_t size, struct syscall_arg *arg, u64 *val);
 	unsigned long (*mask_val)(struct syscall_arg *arg, unsigned long val);
 	void	   *parm;
 	const char *name;
@@ -1515,8 +1519,10 @@ syscall_arg_fmt__init_array(struct syscall_arg_fmt *arg, struct tep_format_field
                } else {
 			struct syscall_arg_fmt *fmt = syscall_arg_fmt__find_by_name(field->name);
 
-			if (fmt)
+			if (fmt) {
 				arg->scnprintf = fmt->scnprintf;
+				arg->strtoul   = fmt->strtoul;
+			}
 		}
 	}
 
-- 
2.35.1



