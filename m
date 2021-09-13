Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFBF1408E60
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241279AbhIMNd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:33:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242769AbhIMNaB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:30:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 587CB61056;
        Mon, 13 Sep 2021 13:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539481;
        bh=xJm/14y2ypvancYZsIrjqdLMdAXw9P1YUbfsY5TqiIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EbuuZa/jrha8R95OI63/wCl6H+iHaVvYdJZPsMni2Byby5+OGKz8lV5bT0LbPFUO5
         UeTl+RP1KJruk9zRnN425q0eDUYNhMNtIzO6jipzr6IBljw7uQh8CypRTuFH813D3e
         xu6sgg3IVY5YHDl9KhbV6zuDBKGzYFeuqMxeTTu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Mika=20Penttil=C3=A4?= <mika.penttila@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Pankaj Gupta <pankaj.gupta@ionos.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/236] sched/numa: Fix is_core_idle()
Date:   Mon, 13 Sep 2021 15:12:27 +0200
Message-Id: <20210913131101.787942982@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Penttilä <mika.penttila@gmail.com>

[ Upstream commit 1c6829cfd3d5124b125e6df41158665aea413b35 ]

Use the loop variable instead of the function argument to test the
other SMT siblings for idle.

Fixes: ff7db0bf24db ("sched/numa: Prefer using an idle CPU as a migration target instead of comparing tasks")
Signed-off-by: Mika Penttilä <mika.penttila@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Pankaj Gupta <pankaj.gupta@ionos.com>
Link: https://lkml.kernel.org/r/20210722063946.28951-1-mika.penttila@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bad97d35684d..c004e3b89c32 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1533,7 +1533,7 @@ static inline bool is_core_idle(int cpu)
 		if (cpu == sibling)
 			continue;
 
-		if (!idle_cpu(cpu))
+		if (!idle_cpu(sibling))
 			return false;
 	}
 #endif
-- 
2.30.2



