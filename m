Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD206159FC
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbiKBDWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbiKBDWE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:22:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A107425C63
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:22:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 550B1B82055
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E292C433C1;
        Wed,  2 Nov 2022 03:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359320;
        bh=tQdjKm4ojZcsbAZOZK9/30erAtIUTlELupJPIcQn34o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wXuWVmNWLHurN6fJif43FYbFw6whHh5zZvtI7qHvI4RZk9MGaDq4Ea9YKp6bqj5Go
         7pRgjh2QqJUab1hXwyjWGWeq0yZN5FZINhtyK6u/Y0+HQoV3/sSV6Uy3KconnN8CAJ
         BYpKVW9vxkN2zOyLSEl1ivpxY3G6kFPCo7qgfZ10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.4 20/64] perf auxtrace: Fix address filter symbol name match for modules
Date:   Wed,  2 Nov 2022 03:33:46 +0100
Message-Id: <20221102022052.461513538@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.821538553@linuxfoundation.org>
References: <20221102022051.821538553@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit cba04f3136b658583adb191556f99d087589c1cc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/auxtrace.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -1710,11 +1710,19 @@ struct sym_args {
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


