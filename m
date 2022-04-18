Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32996505113
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238950AbiDRMaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238932AbiDRM1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:27:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D681DA45;
        Mon, 18 Apr 2022 05:20:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0C31B80EDC;
        Mon, 18 Apr 2022 12:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB9EC385A7;
        Mon, 18 Apr 2022 12:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284455;
        bh=K5RdTTCq8kAUQ0QefNrXg318RXOD+fZs/EpmbwyeWJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RqJULqx367HtI6cfPF6IXBFAFRwOC0OBve4rAUl3NpRbRmb9TWGX/0GCJBP+S0ANo
         h0obq1EW/jEmnQj2MhwJRfAaLKFocoKsco9bjk1xWv1MrtydPciI6bk/5aV0q2q2eT
         ET4abcP32s+FBo2GldsrJS2223DSrdyg+qu2dnqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Khazhismel Kumykov <khazhy@google.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 121/219] dm mpath: only use ktime_get_ns() in historical selector
Date:   Mon, 18 Apr 2022 14:11:30 +0200
Message-Id: <20220418121210.285415471@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Khazhismel Kumykov <khazhy@google.com>

[ Upstream commit ce40426fdc3c92acdba6b5ca74bc7277ffaa6a3d ]

Mixing sched_clock() and ktime_get_ns() usage will give bad results.

Switch hst_select_path() from using sched_clock() to ktime_get_ns().
Also rename path_service_time()'s 'sched_now' variable to 'now'.

Fixes: 2613eab11996 ("dm mpath: add Historical Service Time Path Selector")
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-ps-historical-service-time.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-ps-historical-service-time.c b/drivers/md/dm-ps-historical-service-time.c
index 875bca30a0dd..82f2a06153dc 100644
--- a/drivers/md/dm-ps-historical-service-time.c
+++ b/drivers/md/dm-ps-historical-service-time.c
@@ -27,7 +27,6 @@
 #include <linux/blkdev.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/sched/clock.h>
 
 
 #define DM_MSG_PREFIX	"multipath historical-service-time"
@@ -433,7 +432,7 @@ static struct dm_path *hst_select_path(struct path_selector *ps,
 {
 	struct selector *s = ps->context;
 	struct path_info *pi = NULL, *best = NULL;
-	u64 time_now = sched_clock();
+	u64 time_now = ktime_get_ns();
 	struct dm_path *ret = NULL;
 	unsigned long flags;
 
@@ -474,7 +473,7 @@ static int hst_start_io(struct path_selector *ps, struct dm_path *path,
 
 static u64 path_service_time(struct path_info *pi, u64 start_time)
 {
-	u64 sched_now = ktime_get_ns();
+	u64 now = ktime_get_ns();
 
 	/* if a previous disk request has finished after this IO was
 	 * sent to the hardware, pretend the submission happened
@@ -483,11 +482,11 @@ static u64 path_service_time(struct path_info *pi, u64 start_time)
 	if (time_after64(pi->last_finish, start_time))
 		start_time = pi->last_finish;
 
-	pi->last_finish = sched_now;
-	if (time_before64(sched_now, start_time))
+	pi->last_finish = now;
+	if (time_before64(now, start_time))
 		return 0;
 
-	return sched_now - start_time;
+	return now - start_time;
 }
 
 static int hst_end_io(struct path_selector *ps, struct dm_path *path,
-- 
2.35.1



