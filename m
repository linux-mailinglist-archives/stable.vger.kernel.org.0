Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D53D4FD9F5
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351396AbiDLHUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351696AbiDLHMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DAC15A30;
        Mon, 11 Apr 2022 23:51:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1EC56146F;
        Tue, 12 Apr 2022 06:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0303C385A1;
        Tue, 12 Apr 2022 06:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746306;
        bh=TtMFs0H5NU5r4p+2u4nzwSmLe/Zr4CUSnystOjjsI00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fkm23S0TsXgpmCsaJHJNMsISfj8s5TcySbXcCKQ8l9uw+YVHJf2mxzYmqTil42KW5
         QaZmDPpwH7knTvtLyaZeZ3n8T1cOhNGGtjd8zwJqL8v6J3fP+/9QWzcINP1L92Cg5R
         alOgflK1iHJGnlXb3Ep2t1O/IXxaB7YOyaudsTLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.15 236/277] perf/core: Inherit event_caps
Date:   Tue, 12 Apr 2022 08:30:39 +0200
Message-Id: <20220412062948.874087725@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Namhyung Kim <namhyung@kernel.org>

commit e3265a4386428d3d157d9565bb520aabff8b4bf0 upstream.

It was reported that some perf event setup can make fork failed on
ARM64.  It was the case of a group of mixed hw and sw events and it
failed in perf_event_init_task() due to armpmu_event_init().

The ARM PMU code checks if all the events in a group belong to the
same PMU except for software events.  But it didn't set the event_caps
of inherited events and no longer identify them as software events.
Therefore the test failed in a child process.

A simple reproducer is:

  $ perf stat -e '{cycles,cs,instructions}' perf bench sched messaging
  # Running 'sched/messaging' benchmark:
  perf: fork(): Invalid argument

The perf stat was fine but the perf bench failed in fork().  Let's
inherit the event caps from the parent.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20220328200112.457740-1-namhyung@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11596,6 +11596,9 @@ perf_event_alloc(struct perf_event_attr
 
 	event->state		= PERF_EVENT_STATE_INACTIVE;
 
+	if (parent_event)
+		event->event_caps = parent_event->event_caps;
+
 	if (event->attr.sigtrap)
 		atomic_set(&event->event_limit, 1);
 


