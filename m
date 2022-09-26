Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337E95EA25E
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237289AbiIZLGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237370AbiIZLFw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:05:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B765FAD8;
        Mon, 26 Sep 2022 03:33:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3475060C79;
        Mon, 26 Sep 2022 10:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27799C433D6;
        Mon, 26 Sep 2022 10:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188316;
        bh=04SZM3opspa5chlZax00mts7tPj+RkmvBiQOqcE8sr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jh/LVxlYUG9AsvSgfvpTvqtNFdpQAFi4iw01LKor8XUIDQjl95bG9zYSt280Z6tXZ
         Nq7qVG/oji6iGRW3eOrtO5p7n4QmxkaY/xHG12YQj1CKHyzavbXpaHH8C8OrV7HIw2
         7LwEQPpIU+4a1EhI1Sjk7ZAvH3Mj5I5P7p8823gA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Dao <dqminh@cloudflare.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/141] perf kcore_copy: Do not check /proc/modules is unchanged
Date:   Mon, 26 Sep 2022 12:12:16 +0200
Message-Id: <20220926100758.427411664@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 5b427df27b94aec1312cace48a746782a0925c53 ]

/proc/kallsyms and /proc/modules are compared before and after the copy
in order to ensure no changes during the copy.

However /proc/modules also might change due to reference counts changing
even though that does not make any difference.

Any modules loaded or unloaded should be visible in changes to kallsyms,
so it is not necessary to check /proc/modules also anyway.

Remove the comparison checking that /proc/modules is unchanged.

Fixes: fc1b691d7651d949 ("perf buildid-cache: Add ability to add kcore to the cache")
Reported-by: Daniel Dao <dqminh@cloudflare.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Daniel Dao <dqminh@cloudflare.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20220914122429.8770-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-elf.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index d8d79a9ec775..3e423a920015 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -2002,8 +2002,8 @@ static int kcore_copy__compare_file(const char *from_dir, const char *to_dir,
  * unusual.  One significant peculiarity is that the mapping (start -> pgoff)
  * is not the same for the kernel map and the modules map.  That happens because
  * the data is copied adjacently whereas the original kcore has gaps.  Finally,
- * kallsyms and modules files are compared with their copies to check that
- * modules have not been loaded or unloaded while the copies were taking place.
+ * kallsyms file is compared with its copy to check that modules have not been
+ * loaded or unloaded while the copies were taking place.
  *
  * Return: %0 on success, %-1 on failure.
  */
@@ -2066,9 +2066,6 @@ int kcore_copy(const char *from_dir, const char *to_dir)
 			goto out_extract_close;
 	}
 
-	if (kcore_copy__compare_file(from_dir, to_dir, "modules"))
-		goto out_extract_close;
-
 	if (kcore_copy__compare_file(from_dir, to_dir, "kallsyms"))
 		goto out_extract_close;
 
-- 
2.35.1



