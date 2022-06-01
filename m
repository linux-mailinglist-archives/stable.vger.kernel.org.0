Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364D753A850
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354512AbiFAOGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355130AbiFAOFk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:05:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F62EAE475;
        Wed,  1 Jun 2022 06:59:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D20DD615BF;
        Wed,  1 Jun 2022 13:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54DCC385B8;
        Wed,  1 Jun 2022 13:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091971;
        bh=cKRrTbnI+d4+LE1Ydfu6A33V3P+MWNPCyFbzbhkVuKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fO/MyFwK+MPUP2CpmFo6Ge7cHzXhcmWvkvzeu/V33WotfQsGZdf2itsfhI/ExwmLM
         Gi+n/7EHO0bBXOhMtzc4JCikyVFqezNeke8YvZVFyj8mVvUYuJIk2E3idI5BATdv+t
         Dm/knXZ/hR3w2uUq8Ub4A4QLYuBILg0fRbLYjHsiIjokDXQqYHZFhS8FN4WRUDWJ2I
         jFeA4na5+jq1ElTaG1eID6sd9daP+1gvpsvFrU/nc2qBLb45WD+C8ecjlDObpjSjRQ
         KfcT72q5HvS9gQlWhQZsO8TBcuLAamRJhnEyYIlLayIBis2qtblMf2GI8RbsLw7/2k
         tzXB/HVborIkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@openvz.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        mgorman@techsingularity.net, vbabka@suse.cz,
        vasily.averin@linux.dev, hannes@cmpxchg.org, yuzhao@google.com,
        willy@infradead.org, vincent.whitchurch@axis.com
Subject: [PATCH AUTOSEL 5.4 14/20] tracing: incorrect isolate_mote_t cast in mm_vmscan_lru_isolate
Date:   Wed,  1 Jun 2022 09:58:56 -0400
Message-Id: <20220601135902.2004823-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135902.2004823-1-sashal@kernel.org>
References: <20220601135902.2004823-1-sashal@kernel.org>
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
index a5ab2973e8dc..57184c02e3b9 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -283,7 +283,7 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__field(unsigned long, nr_scanned)
 		__field(unsigned long, nr_skipped)
 		__field(unsigned long, nr_taken)
-		__field(isolate_mode_t, isolate_mode)
+		__field(unsigned int, isolate_mode)
 		__field(int, lru)
 	),
 
@@ -294,7 +294,7 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__entry->nr_scanned = nr_scanned;
 		__entry->nr_skipped = nr_skipped;
 		__entry->nr_taken = nr_taken;
-		__entry->isolate_mode = isolate_mode;
+		__entry->isolate_mode = (__force unsigned int)isolate_mode;
 		__entry->lru = lru;
 	),
 
-- 
2.35.1

