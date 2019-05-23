Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 189D528861
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391137AbfEWTZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:25:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391130AbfEWTZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:25:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 434EA21851;
        Thu, 23 May 2019 19:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639537;
        bh=gOg6ApEAJe4wnqGZX/rysUCWcIgdXxexgYaNqQLTak4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rVDBcA8hGHsLNvwrshD5xU2p9VJHjP3O+wvM5WR4HfU2lW4k1IxYPQiZJK6hluY0T
         nXimx8HO9QTv63M1NscoSjt4cEgt1MyLiRFvOJDLunrWDTt24yJXUBfJSDLedq4VFj
         KHcKhid0FHQbWiZXo3JzIMXdhK4ZTL8mMKqmVrpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Walker <robert.walker@arm.com>,
        Leo Yan <leo.yan@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Suzuki K Poulouse <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 132/139] perf cs-etm: Always allocate memory for cs_etm_queue::prev_packet
Date:   Thu, 23 May 2019 21:07:00 +0200
Message-Id: <20190523181736.244509976@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 35bb59c10a6d0578806dd500477dae9cb4be344e ]

Robert Walker reported a segmentation fault is observed when process
CoreSight trace data; this issue can be easily reproduced by the command
'perf report --itrace=i1000i' for decoding tracing data.

If neither the 'b' flag (synthesize branches events) nor 'l' flag
(synthesize last branch entries) are specified to option '--itrace',
cs_etm_queue::prev_packet will not been initialised.  After merging the
code to support exception packets and sample flags, there introduced a
number of uses of cs_etm_queue::prev_packet without checking whether it
is valid, for these cases any accessing to uninitialised prev_packet
will cause crash.

As cs_etm_queue::prev_packet is used more widely now and it's already
hard to follow which functions have been called in a context where the
validity of cs_etm_queue::prev_packet has been checked, this patch
always allocates memory for cs_etm_queue::prev_packet.

Reported-by: Robert Walker <robert.walker@arm.com>
Suggested-by: Robert Walker <robert.walker@arm.com>
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Tested-by: Robert Walker <robert.walker@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Suzuki K Poulouse <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Fixes: 7100b12cf474 ("perf cs-etm: Generate branch sample for exception packet")
Fixes: 24fff5eb2b93 ("perf cs-etm: Avoid stale branch samples when flush packet")
Link: http://lkml.kernel.org/r/20190428083228.20246-1-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cs-etm.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index 27a374ddf6615..947f1bb2fbdfb 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -345,11 +345,9 @@ static struct cs_etm_queue *cs_etm__alloc_queue(struct cs_etm_auxtrace *etm,
 	if (!etmq->packet)
 		goto out_free;
 
-	if (etm->synth_opts.last_branch || etm->sample_branches) {
-		etmq->prev_packet = zalloc(szp);
-		if (!etmq->prev_packet)
-			goto out_free;
-	}
+	etmq->prev_packet = zalloc(szp);
+	if (!etmq->prev_packet)
+		goto out_free;
 
 	if (etm->synth_opts.last_branch) {
 		size_t sz = sizeof(struct branch_stack);
-- 
2.20.1



