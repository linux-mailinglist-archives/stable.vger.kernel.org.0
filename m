Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4195523FAD2
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgHHXp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728393AbgHHXit (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:38:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3926E20716;
        Sat,  8 Aug 2020 23:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929929;
        bh=1Oa/cdJIHN1hAGIODgcRkLPdFTelsOY1qaCvCXkRJgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yD4huRQCkWcNZqPDOEYScRIl/mHD86qDqcrw5584UsruZgRr/eiPxbmTuByiWowMi
         iKYfZzTGq+p1Xk1hh3A/s0ULQ51BPrr5aGsl2D4brF8oD4cx1Ftw03Q5n3oPddGPnN
         jcPehWkbCUP5/2cY9fxml7TTSxa2IkvaSMr6H42c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peng Liu <iwtbavbm@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 03/40] sched: correct SD_flags returned by tl->sd_flags()
Date:   Sat,  8 Aug 2020 19:38:07 -0400
Message-Id: <20200808233844.3618823-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233844.3618823-1-sashal@kernel.org>
References: <20200808233844.3618823-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Liu <iwtbavbm@gmail.com>

[ Upstream commit 9b1b234bb86bcdcdb142e900d39b599185465dbb ]

During sched domain init, we check whether non-topological SD_flags are
returned by tl->sd_flags(), if found, fire a waning and correct the
violation, but the code failed to correct the violation. Correct this.

Fixes: 143e1e28cb40 ("sched: Rework sched_domain topology definition")
Signed-off-by: Peng Liu <iwtbavbm@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Link: https://lkml.kernel.org/r/20200609150936.GA13060@iZj6chx1xj0e0buvshuecpZ
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 1fa1e13a59446..ffaa97a8d4051 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1333,7 +1333,7 @@ sd_init(struct sched_domain_topology_level *tl,
 		sd_flags = (*tl->sd_flags)();
 	if (WARN_ONCE(sd_flags & ~TOPOLOGY_SD_FLAGS,
 			"wrong sd_flags in topology description\n"))
-		sd_flags &= ~TOPOLOGY_SD_FLAGS;
+		sd_flags &= TOPOLOGY_SD_FLAGS;
 
 	/* Apply detected topology flags */
 	sd_flags |= dflags;
-- 
2.25.1

