Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA08A66C466
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbjAPPyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbjAPPyh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:54:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB5A1D905
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:54:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44F43B81059
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E30CC433EF;
        Mon, 16 Jan 2023 15:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884469;
        bh=XjiJ66Bs32M0q+PI3MfloScCWXIyIblEk6B0Va5Mj54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJBVR/nwA65UaRAbriY8w6xbGN8kY5ePTnhZ2E4k0XCwlle6MtUUqttHL/dRnpkEe
         L3MiJ5etuAvhjxJ5p9e2dHfca4r8AFy03d1zKJpLJN2fHgE9KcgB8TvesoUG1vHzyv
         MP6nkLDFqOZy2BM2eKyDLVMwR7siSuD5+OBJOzME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dmitrii Dolgov <9erthalion6@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6.1 018/183] perf auxtrace: Fix address filter duplicate symbol selection
Date:   Mon, 16 Jan 2023 16:49:01 +0100
Message-Id: <20230116154804.175861780@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

commit cf129830ee820f7fc90b98df193cd49d49344d09 upstream.

When a match has been made to the nth duplicate symbol, return
success not error.

Example:

  Before:

    $ cat file.c
    cat: file.c: No such file or directory
    $ cat file1.c
    #include <stdio.h>

    static void func(void)
    {
            printf("First func\n");
    }

    void other(void);

    int main()
    {
            func();
            other();
            return 0;
    }
    $ cat file2.c
    #include <stdio.h>

    static void func(void)
    {
            printf("Second func\n");
    }

    void other(void)
    {
            func();
    }

    $ gcc -Wall -Wextra -o test file1.c file2.c
    $ perf record -e intel_pt//u --filter 'filter func @ ./test' -- ./test
    Multiple symbols with name 'func'
    #1      0x1149  l       func
                    which is near           main
    #2      0x1179  l       func
                    which is near           other
    Disambiguate symbol name by inserting #n after the name e.g. func #2
    Or select a global symbol by inserting #0 or #g or #G
    Failed to parse address filter: 'filter func @ ./test'
    Filter format is: filter|start|stop|tracestop <start symbol or address> [/ <end symbol or size>] [@<file name>]
    Where multiple filters are separated by space or comma.
    $ perf record -e intel_pt//u --filter 'filter func #2 @ ./test' -- ./test
    Failed to parse address filter: 'filter func #2 @ ./test'
    Filter format is: filter|start|stop|tracestop <start symbol or address> [/ <end symbol or size>] [@<file name>]
    Where multiple filters are separated by space or comma.

  After:

    $ perf record -e intel_pt//u --filter 'filter func #2 @ ./test' -- ./test
    First func
    Second func
    [ perf record: Woken up 1 times to write data ]
    [ perf record: Captured and wrote 0.016 MB perf.data ]
    $ perf script --itrace=b -Ftime,flags,ip,sym,addr --ns
    1231062.526977619:   tr strt                               0 [unknown] =>     558495708179 func
    1231062.526977619:   tr end  call               558495708188 func =>     558495708050 _init
    1231062.526979286:   tr strt                               0 [unknown] =>     55849570818d func
    1231062.526979286:   tr end  return             55849570818f func =>     55849570819d other

Fixes: 1b36c03e356936d6 ("perf record: Add support for using symbols in address filters")
Reported-by: Dmitrii Dolgov <9erthalion6@gmail.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Dmitry Dolgov <9erthalion6@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230110185659.15979-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/auxtrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -2610,7 +2610,7 @@ static int find_dso_sym(struct dso *dso,
 				*size = sym->start - *start;
 			if (idx > 0) {
 				if (*size)
-					return 1;
+					return 0;
 			} else if (dso_sym_match(sym, sym_name, &cnt, idx)) {
 				print_duplicate_syms(dso, sym_name);
 				return -EINVAL;


