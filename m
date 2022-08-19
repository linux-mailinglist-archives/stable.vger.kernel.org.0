Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4508559A24B
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353157AbiHSQdh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353681AbiHSQcX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:32:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972FA104460;
        Fri, 19 Aug 2022 09:06:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EC976177D;
        Fri, 19 Aug 2022 16:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB635C433D6;
        Fri, 19 Aug 2022 16:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925171;
        bh=OaTRRyi9soEAGUwezZ6afXq9Tx652YqDV8+1EJl6L4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BzJ+lKqkLRGMwYgDDEmlMRiSngmrIIeiWiXNwWoZ1mpYRMbWwVH4cXQ6Wo91M6132
         9n+LVAxQeVQUVswCFolUf+VXATx7DHL5iI7hVH3n/EuYe5x6jDqDduYB4/+hWKQS9S
         GDTYCrXxUnaa7xwYqwONCNPwftNtkq+Pos3i1MbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        kvm@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 405/545] perf tools: Fix dso_id inode generation comparison
Date:   Fri, 19 Aug 2022 17:42:55 +0200
Message-Id: <20220819153847.564947709@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 68566a7cf56bf3148797c218ed45a9de078ef47c ]

Synthesized MMAP events have zero ino_generation, so do not compare
them to DSOs with a real ino_generation otherwise we end up with a DSO
without a build id.

Fixes: 0e3149f86b99ddab ("perf dso: Move dso_id from 'struct map' to 'struct dso'")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: kvm@vger.kernel.org
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20220711093218.10967-2-adrian.hunter@intel.com
[ Added clarification to the comment from Ian + more detailed explanation from Adrian ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dsos.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/dsos.c b/tools/perf/util/dsos.c
index 183a81d5b2f9..2db91121bdaf 100644
--- a/tools/perf/util/dsos.c
+++ b/tools/perf/util/dsos.c
@@ -20,8 +20,19 @@ static int __dso_id__cmp(struct dso_id *a, struct dso_id *b)
 	if (a->ino > b->ino) return -1;
 	if (a->ino < b->ino) return 1;
 
-	if (a->ino_generation > b->ino_generation) return -1;
-	if (a->ino_generation < b->ino_generation) return 1;
+	/*
+	 * Synthesized MMAP events have zero ino_generation, avoid comparing
+	 * them with MMAP events with actual ino_generation.
+	 *
+	 * I found it harmful because the mismatch resulted in a new
+	 * dso that did not have a build ID whereas the original dso did have a
+	 * build ID. The build ID was essential because the object was not found
+	 * otherwise. - Adrian
+	 */
+	if (a->ino_generation && b->ino_generation) {
+		if (a->ino_generation > b->ino_generation) return -1;
+		if (a->ino_generation < b->ino_generation) return 1;
+	}
 
 	return 0;
 }
-- 
2.35.1



