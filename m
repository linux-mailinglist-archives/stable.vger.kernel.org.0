Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8F95B7396
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235572AbiIMPLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235800AbiIMPJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:09:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AEC877544;
        Tue, 13 Sep 2022 07:32:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D623B80EF8;
        Tue, 13 Sep 2022 14:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C027FC433C1;
        Tue, 13 Sep 2022 14:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078886;
        bh=DCbveamGbgtaYN1SY5j/jewkUNGShxwvdYSd92uBLLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mBk7lqiScNrAMFE6LQQAeko8Ff2m7+tJhI9mdR8njL94i9aq1Ci/l8SrwCyVsVOmK
         sF/Ly2vnN2TZa/J9C/pYpBwBIsHd8jbhpSBSQiqgDZM88hGq/C3QZ2rAifGfXh+z+o
         zur6UB9Di1qL8m94D5MtzwZOmbHbtUed3H85qXaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jisheng Zhang <jszhang@kernel.org>
Subject: [PATCH 5.15 120/121] perf machine: Use path__join() to compose a path instead of snprintf(dir, /, filename)
Date:   Tue, 13 Sep 2022 16:05:11 +0200
Message-Id: <20220913140402.519862310@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/machine.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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
@@ -1407,7 +1408,7 @@ static int maps__set_modules_path_dir(st
 		struct stat st;
 
 		/*sshfs might return bad dent->d_type, so we have to stat*/
-		snprintf(path, sizeof(path), "%s/%s", dir_name, dent->d_name);
+		path__join(path, sizeof(path), dir_name, dent->d_name);
 		if (stat(path, &st))
 			continue;
 


