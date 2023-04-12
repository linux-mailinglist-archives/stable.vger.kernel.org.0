Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E91236DEEF9
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbjDLIqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbjDLIqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:46:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9292B7EC5
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:46:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BB8E630D8
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D403C433EF;
        Wed, 12 Apr 2023 08:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289135;
        bh=aPr2HDddyWFuIhSKSV8/6IN3abAJcUmZu3tXAMtxe08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MHgjWD909LQUf/QiQMqrIRCiNZn1P2fQHLwgfp3Z+xTMs4NyaazHxShAoX1hpue+A
         K3Doz+vDKbY9OPFNzzwjaGWc/GLXw8kpxjWedm39giiIlhU1pxJjHMwXmjDmKKgLly
         pkk2Oeh3IqlWyZ3XIkUPiKZtSe3io1W2dE+ljQN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Zhengjun Xing <zhengjun.xing@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/164] perf/core: Fix the same task check in perf_event_set_output
Date:   Wed, 12 Apr 2023 10:33:52 +0200
Message-Id: <20230412082841.292488848@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 24d3ae2f37d8bc3c14b31d353c5d27baf582b6a6 ]

The same task check in perf_event_set_output has some potential issues
for some usages.

For the current perf code, there is a problem if using of
perf_event_open() to have multiple samples getting into the same mmap’d
memory when they are both attached to the same process.
https://lore.kernel.org/all/92645262-D319-4068-9C44-2409EF44888E@gmail.com/
Because the event->ctx is not ready when the perf_event_set_output() is
invoked in the perf_event_open().

Besides the above issue, before the commit bd2756811766 ("perf: Rewrite
core context handling"), perf record can errors out when sampling with
a hardware event and a software event as below.
 $ perf record -e cycles,dummy --per-thread ls
 failed to mmap with 22 (Invalid argument)
That's because that prior to the commit a hardware event and a software
event are from different task context.

The problem should be a long time issue since commit c3f00c70276d
("perk: Separate find_get_context() from event initialization").

The task struct is stored in the event->hw.target for each per-thread
event. It is a more reliable way to determine whether two events are
attached to the same task.

The event->hw.target was also introduced several years ago by the
commit 50f16a8bf9d7 ("perf: Remove type specific target pointers"). It
can not only be used to fix the issue with the current code, but also
back port to fix the issues with an older kernel.

Note: The event->hw.target was introduced later than commit
c3f00c70276d. The patch may cannot be applied between the commit
c3f00c70276d and commit 50f16a8bf9d7. Anybody that wants to back-port
this at that period may have to find other solutions.

Fixes: c3f00c70276d ("perf: Separate find_get_context() from event initialization")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Zhengjun Xing <zhengjun.xing@linux.intel.com>
Link: https://lkml.kernel.org/r/20230322202449.512091-1-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2aa286b4151b3..7699b99706ad4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12040,7 +12040,7 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 	/*
 	 * If its not a per-cpu rb, it must be the same task.
 	 */
-	if (output_event->cpu == -1 && output_event->ctx != event->ctx)
+	if (output_event->cpu == -1 && output_event->hw.target != event->hw.target)
 		goto out;
 
 	/*
-- 
2.39.2



