Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8263553A789
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354171AbiFAOCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354273AbiFAOAM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:00:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9E4A33B4;
        Wed,  1 Jun 2022 06:56:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21FC5B81AF5;
        Wed,  1 Jun 2022 13:55:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81122C385B8;
        Wed,  1 Jun 2022 13:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091746;
        bh=LImhD1m0CFwRrcWMz/ZR7U4mvdtc1+1szO7EiyU0VfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NrfNOeeASLyxkccgo2Fv4OgBE+AwOsSZO7OYkjGXxTjn4VJKg73SFdu/9RNdAMx/a
         Izs95n/EJa2Erpe6dtNBzph9t27QDUIKE4dKztiFSaHwqCULoRhzHc2DraoBNkDSW9
         +kcZzA8MRsxJGBBrGPIfeeF8kgRdAFgaMPwTNzL45i/Krh13cRY+3MvPjgK0BQKnjp
         xVvcAuZ9N8jWlzbF/TZWmb/23MoCEk5PqOTBXUc0qg+XRf/8ybhJNndEjn+WQdtmXv
         2JvWopTzkEzp2+SJPTfeUDPagXsgODyvGM3k1NMxlQc8x/FdiKEX2jQq1Q9EKMITUT
         idH5d4WvaESkA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@openvz.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        mgorman@techsingularity.net, vbabka@suse.cz,
        vasily.averin@linux.dev, vincent.whitchurch@axis.com,
        yuzhao@google.com, willy@infradead.org
Subject: [PATCH AUTOSEL 5.17 36/48] tracing: incorrect isolate_mote_t cast in mm_vmscan_lru_isolate
Date:   Wed,  1 Jun 2022 09:54:09 -0400
Message-Id: <20220601135421.2003328-36-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135421.2003328-1-sashal@kernel.org>
References: <20220601135421.2003328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@openvz.org>

[ Upstream commit 2b132903de7124dd9a758be0c27562e91a510848 ]

Fixes following sparse warnings:

  CHECK   mm/vmscan.c
mm/vmscan.c: note: in included file (through
include/trace/trace_events.h, include/trace/define_trace.h,
include/trace/events/vmscan.h):
./include/trace/events/vmscan.h:281:1: sparse: warning:
 cast to restricted isolate_mode_t
./include/trace/events/vmscan.h:281:1: sparse: warning:
 restricted isolate_mode_t degrades to integer

Link: https://lkml.kernel.org/r/e85d7ff2-fd10-53f8-c24e-ba0458439c1b@openvz.org
Signed-off-by: Vasily Averin <vvs@openvz.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/vmscan.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index ca2e9009a651..beb128046089 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -297,7 +297,7 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__field(unsigned long, nr_scanned)
 		__field(unsigned long, nr_skipped)
 		__field(unsigned long, nr_taken)
-		__field(isolate_mode_t, isolate_mode)
+		__field(unsigned int, isolate_mode)
 		__field(int, lru)
 	),
 
@@ -308,7 +308,7 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__entry->nr_scanned = nr_scanned;
 		__entry->nr_skipped = nr_skipped;
 		__entry->nr_taken = nr_taken;
-		__entry->isolate_mode = isolate_mode;
+		__entry->isolate_mode = (__force unsigned int)isolate_mode;
 		__entry->lru = lru;
 	),
 
-- 
2.35.1

