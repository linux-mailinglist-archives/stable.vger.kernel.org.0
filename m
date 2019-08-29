Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE01A1760
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 12:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfH2KuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 06:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727183AbfH2KuN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 06:50:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEED523405;
        Thu, 29 Aug 2019 10:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567075812;
        bh=tI7BVHUHMKckWqBXe4y7OV4tqVnz9jbrLOH9mlq0l1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aI4s/MbEjcRdNxGnRUYsejtMd2cSOi61dlnPQJT5S49UPv7JR7WfgIKjFjsKH3Oy7
         oar6VbpR/wVoO5hpzHf9AIgtYnzSgLPqkGadlgw7bYadZB4Fh3cLqab49e+S8AtEp2
         pHUtZAfwig5Nfbq+8kQD206JvT0jJfupxG5JOwZo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/29] Revert "dm bufio: fix deadlock with loop device"
Date:   Thu, 29 Aug 2019 06:49:42 -0400
Message-Id: <20190829105009.2265-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829105009.2265-1-sashal@kernel.org>
References: <20190829105009.2265-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit cf3591ef832915892f2499b7e54b51d4c578b28c ]

Revert the commit bd293d071ffe65e645b4d8104f9d8fe15ea13862. The proper
fix has been made available with commit d0a255e795ab ("loop: set
PF_MEMALLOC_NOIO for the worker thread").

Note that the fix offered by commit bd293d071ffe doesn't really prevent
the deadlock from occuring - if we look at the stacktrace reported by
Junxiao Bi, we see that it hangs in bit_wait_io and not on the mutex -
i.e. it has already successfully taken the mutex. Changing the mutex
from mutex_lock to mutex_trylock won't help with deadlocks that happen
afterwards.

PID: 474    TASK: ffff8813e11f4600  CPU: 10  COMMAND: "kswapd0"
   #0 [ffff8813dedfb938] __schedule at ffffffff8173f405
   #1 [ffff8813dedfb990] schedule at ffffffff8173fa27
   #2 [ffff8813dedfb9b0] schedule_timeout at ffffffff81742fec
   #3 [ffff8813dedfba60] io_schedule_timeout at ffffffff8173f186
   #4 [ffff8813dedfbaa0] bit_wait_io at ffffffff8174034f
   #5 [ffff8813dedfbac0] __wait_on_bit at ffffffff8173fec8
   #6 [ffff8813dedfbb10] out_of_line_wait_on_bit at ffffffff8173ff81
   #7 [ffff8813dedfbb90] __make_buffer_clean at ffffffffa038736f [dm_bufio]
   #8 [ffff8813dedfbbb0] __try_evict_buffer at ffffffffa0387bb8 [dm_bufio]
   #9 [ffff8813dedfbbd0] dm_bufio_shrink_scan at ffffffffa0387cc3 [dm_bufio]
  #10 [ffff8813dedfbc40] shrink_slab at ffffffff811a87ce
  #11 [ffff8813dedfbd30] shrink_zone at ffffffff811ad778
  #12 [ffff8813dedfbdc0] kswapd at ffffffff811ae92f
  #13 [ffff8813dedfbec0] kthread at ffffffff810a8428
  #14 [ffff8813dedfbf50] ret_from_fork at ffffffff81745242

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Fixes: bd293d071ffe ("dm bufio: fix deadlock with loop device")
Depends-on: d0a255e795ab ("loop: set PF_MEMALLOC_NOIO for the worker thread")
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-bufio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index b1d0ae2dbd3dd..dc385b70e4c33 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1602,7 +1602,9 @@ dm_bufio_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 	unsigned long freed;
 
 	c = container_of(shrink, struct dm_bufio_client, shrinker);
-	if (!dm_bufio_trylock(c))
+	if (sc->gfp_mask & __GFP_FS)
+		dm_bufio_lock(c);
+	else if (!dm_bufio_trylock(c))
 		return SHRINK_STOP;
 
 	freed  = __scan(c, sc->nr_to_scan, sc->gfp_mask);
-- 
2.20.1

