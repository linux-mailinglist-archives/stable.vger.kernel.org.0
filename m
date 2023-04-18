Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E9C6E61AD
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbjDRM0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbjDRM0K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:26:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA064EE8
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:25:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70F5863139
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FC7C433D2;
        Tue, 18 Apr 2023 12:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820719;
        bh=PlWZh9yH36LKEii17ala2z5RS1wEfShnG8uKjRVqVsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+onab7eBlVdqy7mlMcryX6hPr99irRqr4Cr4Myo0c4ceMm7fGp/uzmdxYhrdM6vu
         xUPk0lcaqQB6AJwDShXHDgln95pVqFMPoo3kcNBSHXNVPMwT9Cw0rznmJ71O0qhPck
         9WeLyVo9dAtX2VdX4LdMEIUFZqq658iIBUjdd1RA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Zhengjun Xing <zhengjun.xing@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 13/37] perf/core: Fix the same task check in perf_event_set_output
Date:   Tue, 18 Apr 2023 14:21:23 +0200
Message-Id: <20230418120255.127915377@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120254.687480980@linuxfoundation.org>
References: <20230418120254.687480980@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
index eb67ef4506151..392e48bbba448 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9899,7 +9899,7 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 	/*
 	 * If its not a per-cpu rb, it must be the same task.
 	 */
-	if (output_event->cpu == -1 && output_event->ctx != event->ctx)
+	if (output_event->cpu == -1 && output_event->hw.target != event->hw.target)
 		goto out;
 
 	/*
-- 
2.39.2



