Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A3C24DB02
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 18:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbgHUQc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 12:32:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728451AbgHUQVe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:21:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F4A022D75;
        Fri, 21 Aug 2020 16:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026837;
        bh=FresQJ+8YrzQahGXKniizpkZbx4mcAjvUTHqjSRmheQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRYa7XV6D+HRAUzu5oELpY0QFg75IKNawAx6Y8vLEHrwHKFHg3sIvYsAIBHa8NSg8
         1+O08ChVhxwpPizYicNwvqnQjEX7uiJwb9frNbv8SfIntVQc/LpnCAUkB5qSNDdeun
         Yj3XRibcmUIKfKT0j4Yd9TmBckh36pSLbbXtYTgM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 18/22] locking/lockdep: Fix overflow in presentation of average lock-time
Date:   Fri, 21 Aug 2020 12:20:10 -0400
Message-Id: <20200821162014.349506-18-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821162014.349506-1-sashal@kernel.org>
References: <20200821162014.349506-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit a7ef9b28aa8d72a1656fa6f0a01bbd1493886317 ]

Though the number of lock-acquisitions is tracked as unsigned long, this
is passed as the divisor to div_s64() which interprets it as a s32,
giving nonsense values with more than 2 billion acquisitons. E.g.

  acquisitions   holdtime-min   holdtime-max holdtime-total   holdtime-avg
  -------------------------------------------------------------------------
    2350439395           0.07         353.38   649647067.36          0.-32

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20200725185110.11588-1-chris@chris-wilson.co.uk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep_proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/lockdep_proc.c b/kernel/locking/lockdep_proc.c
index 35b34eccdd109..9484f934aa349 100644
--- a/kernel/locking/lockdep_proc.c
+++ b/kernel/locking/lockdep_proc.c
@@ -423,7 +423,7 @@ static void seq_lock_time(struct seq_file *m, struct lock_time *lt)
 	seq_time(m, lt->min);
 	seq_time(m, lt->max);
 	seq_time(m, lt->total);
-	seq_time(m, lt->nr ? div_s64(lt->total, lt->nr) : 0);
+	seq_time(m, lt->nr ? div64_u64(lt->total, lt->nr) : 0);
 }
 
 static void seq_stats(struct seq_file *m, struct lock_stat_data *data)
-- 
2.25.1

