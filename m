Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF6054897D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243988AbiFMKnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244711AbiFMKlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:41:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A5C22B01;
        Mon, 13 Jun 2022 03:23:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A054B80E95;
        Mon, 13 Jun 2022 10:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C415C3411F;
        Mon, 13 Jun 2022 10:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115822;
        bh=FQzVNMnLYI5uHT3rQ0PmNawNLjc6hqdIBzkgK+v51q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Np/Oo1icdMVgU2PREMTktP5nKC5fyi3/FjHl6HNCQyTeUFBCDB2hUpA96OX723G77
         IpWJrJ2/o/PwMwzlC+jY7AMzmZ3kb22IZ7JIKjxey8IqnL0r1XpMduDidelT+3sW66
         V4lb4ksShCKO54UpwGKHfbBOKQMTDXKyh+5AAixk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@openvz.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 043/218] tracing: incorrect isolate_mote_t cast in mm_vmscan_lru_isolate
Date:   Mon, 13 Jun 2022 12:08:21 +0200
Message-Id: <20220613094918.603430980@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index dc23cf032403..9553f6167e51 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -290,7 +290,7 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__field(unsigned long, nr_scanned)
 		__field(unsigned long, nr_skipped)
 		__field(unsigned long, nr_taken)
-		__field(isolate_mode_t, isolate_mode)
+		__field(unsigned int, isolate_mode)
 		__field(int, lru)
 	),
 
@@ -301,7 +301,7 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__entry->nr_scanned = nr_scanned;
 		__entry->nr_skipped = nr_skipped;
 		__entry->nr_taken = nr_taken;
-		__entry->isolate_mode = isolate_mode;
+		__entry->isolate_mode = (__force unsigned int)isolate_mode;
 		__entry->lru = lru;
 	),
 
-- 
2.35.1



