Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B475AAFCD
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237371AbiIBMof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237410AbiIBMnf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:43:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DC4E9257;
        Fri,  2 Sep 2022 05:32:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AE87B82A9B;
        Fri,  2 Sep 2022 12:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55ACDC4314B;
        Fri,  2 Sep 2022 12:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121924;
        bh=CIU+DSpGaqtV1Ayuy5qvMGgr20i13hzoq4HyAWpOpEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPdBj4wnxZpQBeV0351CcKSAT5oOsux9Png2Rr9zbxd2vJQbpZzppCbNEakcODK3A
         5wQJzjqWPJwBX401rqKf8F3B8VUYUpZWGDvWuBquGD2DYk/GA6bBgyT8HDbyrNQJLt
         xS468v1wRl6kLAjZKHnvJW/dMAd5oXfq4fKDWUus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 5.15 08/73] Drivers: hv: balloon: Support status report for larger page sizes
Date:   Fri,  2 Sep 2022 14:18:32 +0200
Message-Id: <20220902121404.716677682@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Boqun Feng <boqun.feng@gmail.com>

commit b3d6dd09ff00fdcf4f7c0cb54700ffd5dd343502 upstream.

DM_STATUS_REPORT expects the numbers of pages in the unit of 4k pages
(HV_HYP_PAGE) instead of guest pages, so to make it work when guest page
sizes are larger than 4k, convert the numbers of guest pages into the
numbers of HV_HYP_PAGEs.

Note that the numbers of guest pages are still used for tracing because
tracing is internal to the guest kernel.

Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20220325023212.1570049-2-boqun.feng@gmail.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/hv_balloon.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/kthread.h>
 #include <linux/completion.h>
+#include <linux/count_zeros.h>
 #include <linux/memory_hotplug.h>
 #include <linux/memory.h>
 #include <linux/notifier.h>
@@ -1130,6 +1131,7 @@ static void post_status(struct hv_dynmem
 	struct dm_status status;
 	unsigned long now = jiffies;
 	unsigned long last_post = last_post_time;
+	unsigned long num_pages_avail, num_pages_committed;
 
 	if (pressure_report_delay > 0) {
 		--pressure_report_delay;
@@ -1154,16 +1156,21 @@ static void post_status(struct hv_dynmem
 	 * num_pages_onlined) as committed to the host, otherwise it can try
 	 * asking us to balloon them out.
 	 */
-	status.num_avail = si_mem_available();
-	status.num_committed = vm_memory_committed() +
+	num_pages_avail = si_mem_available();
+	num_pages_committed = vm_memory_committed() +
 		dm->num_pages_ballooned +
 		(dm->num_pages_added > dm->num_pages_onlined ?
 		 dm->num_pages_added - dm->num_pages_onlined : 0) +
 		compute_balloon_floor();
 
-	trace_balloon_status(status.num_avail, status.num_committed,
+	trace_balloon_status(num_pages_avail, num_pages_committed,
 			     vm_memory_committed(), dm->num_pages_ballooned,
 			     dm->num_pages_added, dm->num_pages_onlined);
+
+	/* Convert numbers of pages into numbers of HV_HYP_PAGEs. */
+	status.num_avail = num_pages_avail * NR_HV_HYP_PAGES_IN_PAGE;
+	status.num_committed = num_pages_committed * NR_HV_HYP_PAGES_IN_PAGE;
+
 	/*
 	 * If our transaction ID is no longer current, just don't
 	 * send the status. This can happen if we were interrupted


