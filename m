Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991956130B0
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 07:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiJaGss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 02:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiJaGsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 02:48:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDFF9FD1
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 23:48:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E5B7B8114A
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 06:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A92C43140;
        Mon, 31 Oct 2022 06:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667198923;
        bh=VTHU6qtx0p/JnBzYn2D2+Rf0G4Q08XhKIaf1drVMfYM=;
        h=Subject:To:Cc:From:Date:From;
        b=wD0DYfQTmbn0WYwgkPc5sWiL6Opeq/d3YEUhHEeALhDiRre9oQ+/JyWWHaPruF+4g
         +vFe1LYXvi3wMqYDbqIp8vKZ/65gCqX8EnohBq3PZWIF3V3/jLUEEpCnFol0uZywLB
         ChH7y7Ldgbk0iloNRb9G2sCc8ltNmWNghWStx8qw=
Subject: FAILED: patch "[PATCH] perf auxtrace: Fix address filter symbol name match for" failed to apply to 4.14-stable tree
To:     adrian.hunter@intel.com, acme@redhat.com, irogers@google.com,
        jolsa@kernel.org, namhyung@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Oct 2022 07:49:39 +0100
Message-ID: <1667198979160110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

cba04f3136b6 ("perf auxtrace: Fix address filter symbol name match for modules")
e85e0e0ccc60 ("perf tools: Use kallsyms__is_function()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cba04f3136b658583adb191556f99d087589c1cc Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@intel.com>
Date: Wed, 26 Oct 2022 10:27:36 +0300
Subject: [PATCH] perf auxtrace: Fix address filter symbol name match for
 modules

For modules, names from kallsyms__parse() contain the module name which
meant that module symbols did not match exactly by name.

Fix by matching the name string up to the separating tab character.

Fixes: 1b36c03e356936d6 ("perf record: Add support for using symbols in address filters")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221026072736.2982-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/util/auxtrace.c b/tools/perf/util/auxtrace.c
index 60d8beb662aa..46ada5ec3f9a 100644
--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -2325,11 +2325,19 @@ struct sym_args {
 	bool		near;
 };
 
+static bool kern_sym_name_match(const char *kname, const char *name)
+{
+	size_t n = strlen(name);
+
+	return !strcmp(kname, name) ||
+	       (!strncmp(kname, name, n) && kname[n] == '\t');
+}
+
 static bool kern_sym_match(struct sym_args *args, const char *name, char type)
 {
 	/* A function with the same name, and global or the n'th found or any */
 	return kallsyms__is_function(type) &&
-	       !strcmp(name, args->name) &&
+	       kern_sym_name_match(name, args->name) &&
 	       ((args->global && isupper(type)) ||
 		(args->selected && ++(args->cnt) == args->idx) ||
 		(!args->global && !args->selected));

