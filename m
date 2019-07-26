Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E19376A2A
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbfGZN4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:56:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387776AbfGZNls (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:41:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C31222CD8;
        Fri, 26 Jul 2019 13:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148508;
        bh=eiIvl15TE1PQR+e0/L2NdQWQqKyuwo1UD+t1FaRlF7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ln+bA9NqHtxeWGr2N9wP2kstyETWXdDaAdpClG/0yLbE0+m4fj8xRvcGe9Y0h10v2
         HzO3kkcMnwzVPBmInr1UJpDm5q4t4qrpRO3qprgT1d99b3rIPwIFow8im4YTsW+vqN
         ecfYInvWTwNIvWVORtXNeJtJDgVhZ3/YT3tWf10I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 74/85] xen: let alloc_xenballooned_pages() fail if not enough memory free
Date:   Fri, 26 Jul 2019 09:39:24 -0400
Message-Id: <20190726133936.11177-74-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit a1078e821b605813b63bf6bca414a85f804d5c66 ]

Instead of trying to allocate pages with GFP_USER in
add_ballooned_pages() check the available free memory via
si_mem_available(). GFP_USER is far less limiting memory exhaustion
than the test via si_mem_available().

This will avoid dom0 running out of memory due to excessive foreign
page mappings especially on ARM and on x86 in PVH mode, as those don't
have a pre-ballooned area which can be used for foreign mappings.

As the normal ballooning suffers from the same problem don't balloon
down more than si_mem_available() pages in one iteration. At the same
time limit the default maximum number of retries.

This is part of XSA-300.

Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/balloon.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index d37dd5bb7a8f..559768dc2567 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -538,8 +538,15 @@ static void balloon_process(struct work_struct *work)
 				state = reserve_additional_memory();
 		}
 
-		if (credit < 0)
-			state = decrease_reservation(-credit, GFP_BALLOON);
+		if (credit < 0) {
+			long n_pages;
+
+			n_pages = min(-credit, si_mem_available());
+			state = decrease_reservation(n_pages, GFP_BALLOON);
+			if (state == BP_DONE && n_pages != -credit &&
+			    n_pages < totalreserve_pages)
+				state = BP_EAGAIN;
+		}
 
 		state = update_schedule(state);
 
@@ -578,6 +585,9 @@ static int add_ballooned_pages(int nr_pages)
 		}
 	}
 
+	if (si_mem_available() < nr_pages)
+		return -ENOMEM;
+
 	st = decrease_reservation(nr_pages, GFP_USER);
 	if (st != BP_DONE)
 		return -ENOMEM;
@@ -710,7 +720,7 @@ static int __init balloon_init(void)
 	balloon_stats.schedule_delay = 1;
 	balloon_stats.max_schedule_delay = 32;
 	balloon_stats.retry_count = 1;
-	balloon_stats.max_retry_count = RETRY_UNLIMITED;
+	balloon_stats.max_retry_count = 4;
 
 #ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
 	set_online_page_callback(&xen_online_page);
-- 
2.20.1

