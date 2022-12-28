Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75850658235
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbiL1Qdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234792AbiL1QdP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:33:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5461B7AC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:30:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A19F7B8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE04C433EF;
        Wed, 28 Dec 2022 16:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245036;
        bh=ixDZxU/fEWImfhu8/btyqy3WKqizzgjiw6cz764ALec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UnKorRr5zxWAwb3j+74+Pa43kEr8NaX03bay0d7K1KggMYHTImzt8tp9LLf2bWZQ4
         jza1viUyzxtsCMSOgvR/qAk3pAC2t1tMZLlRKo7yHsjhha7FFvuqf77fP8TrTiD+gT
         hozRxuPyPoHw9PHhNtPMsNoQaD49EIRlRwolo4bk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        James Clark <james.clark@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sandipan Das <sandipan.das@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0782/1146] perf branch: Fix interpretation of branch records
Date:   Wed, 28 Dec 2022 15:38:41 +0100
Message-Id: <20221228144351.387516311@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: James Clark <james.clark@arm.com>

[ Upstream commit 20ed9fa4965875fdde5bfd65d838465e38d46b22 ]

Commit 93315e46b000fc80 ("perf/core: Add speculation info to branch
entries") added a new field in between type and new_type. Perf has its
own copy of this struct so update it to match the kernel side.

This doesn't currently cause any issues because new_type is only used by
the Arm BRBE driver which isn't merged yet.

Committer notes:

Is this really an ABI? How are we supposed to deal with old perf.data
files with new tools and vice versa? :-\

Fixes: 93315e46b000fc80 ("perf/core: Add speculation info to branch entries")
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: James Clark <james.clark@arm.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sandipan Das <sandipan.das@amd.com>
Link: https://lore.kernel.org/r/20221130165158.517385-1-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/branch.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/branch.h b/tools/perf/util/branch.h
index f838b23db180..dca75cad96f6 100644
--- a/tools/perf/util/branch.h
+++ b/tools/perf/util/branch.h
@@ -24,9 +24,10 @@ struct branch_flags {
 			u64 abort:1;
 			u64 cycles:16;
 			u64 type:4;
+			u64 spec:2;
 			u64 new_type:4;
 			u64 priv:3;
-			u64 reserved:33;
+			u64 reserved:31;
 		};
 	};
 };
-- 
2.35.1



