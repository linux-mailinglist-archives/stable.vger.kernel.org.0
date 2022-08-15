Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17215950D6
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbiHPEq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbiHPEpp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:45:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6F5AF0D9;
        Mon, 15 Aug 2022 13:42:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20098B80EAD;
        Mon, 15 Aug 2022 20:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694BFC433C1;
        Mon, 15 Aug 2022 20:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596155;
        bh=1nxUEJqdGrmDbqMzj+vb/mQeqj5KZSqrH9pIU4WSL2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UUWrEzwLcSz8QKeA3xG+KWWkXTXzLhxcBFwOGIeIVydEuX9xt/2cQbpVUBbPYXvYJ
         hBEdNWuQbA2Z3iUPEoMvr4JaLLwnLOMwbtFbXylgLx15rRkjzm3dTx4u8GjUWFELtZ
         uLnAXh9t714vYLac9LgJteRFpcNIlT3cNDx5riuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        kvm@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0973/1157] perf tools: Fix dso_id inode generation comparison
Date:   Mon, 15 Aug 2022 20:05:29 +0200
Message-Id: <20220815180518.640417587@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index b97366f77bbf..2bd23e4cf19e 100644
--- a/tools/perf/util/dsos.c
+++ b/tools/perf/util/dsos.c
@@ -23,8 +23,19 @@ static int __dso_id__cmp(struct dso_id *a, struct dso_id *b)
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



