Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562C54FD3ED
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352919AbiDLHdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354958AbiDLH1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:27:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A672381B3;
        Tue, 12 Apr 2022 00:06:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF2C5B81B4E;
        Tue, 12 Apr 2022 07:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBBFC385A6;
        Tue, 12 Apr 2022 07:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747214;
        bh=9mAMX+W24OCA95cx699ZaYW3YeLYJ/bq7p8AxFlJT7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hw4nl2HfAlBGKM3i1Ly0xGOEFTT/OIKs/Fn7RJivbruS6rw7v8k5Nx2IlqV53LP+w
         SP8arTEZumjuGPxfYkkKIV2Dx0hJvmpLXPfWMipH+t+3450oz4jZlX5GOzuQoJVNsm
         v4u49kFyX1EqsxURDwPUOtgRYWRjOerCK53xKZC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.16 247/285] perf/core: Inherit event_caps
Date:   Tue, 12 Apr 2022 08:31:44 +0200
Message-Id: <20220412062950.787962308@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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
@@ -11626,6 +11626,9 @@ perf_event_alloc(struct perf_event_attr
 
 	event->state		= PERF_EVENT_STATE_INACTIVE;
 
+	if (parent_event)
+		event->event_caps = parent_event->event_caps;
+
 	if (event->attr.sigtrap)
 		atomic_set(&event->event_limit, 1);
 


