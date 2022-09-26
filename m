Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 055B35E9EF2
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbiIZKQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234765AbiIZKQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:16:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF87BEF;
        Mon, 26 Sep 2022 03:14:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 768E3B8091F;
        Mon, 26 Sep 2022 10:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87663C433C1;
        Mon, 26 Sep 2022 10:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187269;
        bh=k30dhzOXh/WvOGmj0fRUhjCe8YK/x2ffhyWiqnPNpkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LvBMs8ED4LpCqszC0fE0i9zIUsMAZMJoqgfkw31UNGx8gvyG+oJSCI0KvhRXN/d7i
         yjn148ay+DNgbnMk0cr35/N9jvDlcQ9PlnwVfYnmWtBspLuTFU6r5tLjDczJ2h8hBH
         hhjj62w+1eAWTx/IzCQHHhlEn/nyzLsT9AIYx1gQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Dao <dqminh@cloudflare.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 24/30] perf kcore_copy: Do not check /proc/modules is unchanged
Date:   Mon, 26 Sep 2022 12:11:55 +0200
Message-Id: <20220926100737.011675623@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100736.153157100@linuxfoundation.org>
References: <20220926100736.153157100@linuxfoundation.org>
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
index e155783c601a..0a7e1543ce8f 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1694,8 +1694,8 @@ static int kcore_copy__compare_file(const char *from_dir, const char *to_dir,
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
@@ -1758,9 +1758,6 @@ int kcore_copy(const char *from_dir, const char *to_dir)
 					 kci.modules_map.len))
 		goto out_extract_close;
 
-	if (kcore_copy__compare_file(from_dir, to_dir, "modules"))
-		goto out_extract_close;
-
 	if (kcore_copy__compare_file(from_dir, to_dir, "kallsyms"))
 		goto out_extract_close;
 
-- 
2.35.1



