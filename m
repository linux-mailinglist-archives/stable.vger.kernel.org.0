Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F7F5B6928
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 10:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiIMID4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 04:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbiIMIDz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 04:03:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4495A827
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 01:03:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C7C6612DB
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 08:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2240C433C1;
        Tue, 13 Sep 2022 08:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663056231;
        bh=AbnuB8avRqvemZp337TZD0PB12eZhHsFXU9qUCEK8VI=;
        h=From:To:Cc:Subject:Date:From;
        b=owWzNdLzE49SNC0/6DT6VLUPKy9s+J7Tut4ZVMpqSskIEBY2nsKsvizSKanBMg6Ca
         FGsKsnS0fi6Xz7WFB4AWClYL07IUgNT+KuEXGFXpcJQ/iVW1hcIU2BY+gNNws+0Oh2
         HkTmZW8KYkSCGsiTIGodl2UkeR/2dMQXtNSdyh/EWjfuw8iAWfyI/zY/fK+RTf1UfG
         yYK23CWqRrUA6wJCOCJZzrbrWPumPeJUiit3c+J1UNj1Q4Ogs9txL7+AcDNmjefZw1
         xnFIsR5Ei8LZWQUZtk1VaHdDEkiU8+CXi+L8fTp3ED510Qz2Uh6ji+/exDT2m60s95
         nMov7qkadZ/YA==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH linux-5.15.y v3] perf machine: Use path__join() to compose a path instead of snprintf(dir, '/', filename)
Date:   Tue, 13 Sep 2022 15:54:30 +0800
Message-Id: <20220913075430.2164-1-jszhang@kernel.org>
X-Mailer: git-send-email 2.34.1
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 9d5f0c36438eeae7566ca383b2b673179e3cc613 upstream.

Its more intention revealing, and if we're interested in the odd cases
where this may end up truncating we can do debug checks at one
centralized place.

Motivation, of all the container builds, fedora rawhide started
complaining of:

  util/machine.c: In function ‘machine__create_modules’:
  util/machine.c:1419:50: error: ‘%s’ directive output may be truncated writing up to 255 bytes into a region of size between 0 and 4095 [-Werror=format-truncation=]
   1419 |                 snprintf(path, sizeof(path), "%s/%s", dir_name, dent->d_name);
        |                                                  ^~
  In file included from /usr/include/stdio.h:894,
                   from util/branch.h:9,
                   from util/callchain.h:8,
                   from util/machine.c:7:
  In function ‘snprintf’,
      inlined from ‘maps__set_modules_path_dir’ at util/machine.c:1419:3,
      inlined from ‘machine__set_modules_path’ at util/machine.c:1473:9,
      inlined from ‘machine__create_modules’ at util/machine.c:1519:7:
  /usr/include/bits/stdio2.h:71:10: note: ‘__builtin___snprintf_chk’ output between 2 and 4352 bytes into a destination of size 4096

There are other places where we should use path__join(), but lets get rid of
this one first.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Acked-by: Ian Rogers <irogers@google.com>
Link: Link: https://lore.kernel.org/r/YebZKjwgfdOz0lAs@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---

Since v2:
 - add necessary tag as pointed out by Greg.

Since v1:
 - add commit id in upstream.
 - add linux-5.15.y, maybe we also need this for other long term stable
   tree.

 tools/perf/util/machine.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 44e40bad0e33..55a041329990 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -16,6 +16,7 @@
 #include "map_symbol.h"
 #include "branch.h"
 #include "mem-events.h"
+#include "path.h"
 #include "srcline.h"
 #include "symbol.h"
 #include "sort.h"
@@ -1407,7 +1408,7 @@ static int maps__set_modules_path_dir(struct maps *maps, const char *dir_name, i
 		struct stat st;
 
 		/*sshfs might return bad dent->d_type, so we have to stat*/
-		snprintf(path, sizeof(path), "%s/%s", dir_name, dent->d_name);
+		path__join(path, sizeof(path), dir_name, dent->d_name);
 		if (stat(path, &st))
 			continue;
 
-- 
2.34.1

