Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB8F23FAD6
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgHHXi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:38:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbgHHXi2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:38:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B973C207BB;
        Sat,  8 Aug 2020 23:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929908;
        bh=zAUNWZzCI8ukKqTvNlnlscIEQVsbnvlQ1UoOIQ2chNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uS04zpqMqOn6EkiZANN3AMoNVsEZ4EyKA7mZt2hgMiZBwxoz01K2Lez4JHF7GWO0d
         XILuDlfzeLGB2j7V9ZZZ3Vt3p4wuW8q1+SLoPDpKgRmenGkHDixFRiJZg40LXI40md
         RIBNgdcl2Zmr4nyL+KX2BYrOTmUF3KPHuDxsHN+Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chengming Zhou <zhouchengming@bytedance.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 46/58] iocost: Fix check condition of iocg abs_vdebt
Date:   Sat,  8 Aug 2020 19:37:12 -0400
Message-Id: <20200808233724.3618168-46-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233724.3618168-1-sashal@kernel.org>
References: <20200808233724.3618168-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengming Zhou <zhouchengming@bytedance.com>

[ Upstream commit d9012a59db54442d5b2fcfdfcded35cf566397d3 ]

We shouldn't skip iocg when its abs_vdebt is not zero.

Fixes: 0b80f9866e6b ("iocost: protect iocg->abs_vdebt with iocg->waitq.lock")
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index ef193389fffe9..b5a9cfcd75e9d 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1374,7 +1374,7 @@ static void ioc_timer_fn(struct timer_list *timer)
 	 * should have woken up in the last period and expire idle iocgs.
 	 */
 	list_for_each_entry_safe(iocg, tiocg, &ioc->active_iocgs, active_list) {
-		if (!waitqueue_active(&iocg->waitq) && iocg->abs_vdebt &&
+		if (!waitqueue_active(&iocg->waitq) && !iocg->abs_vdebt &&
 		    !iocg_is_idle(iocg))
 			continue;
 
-- 
2.25.1

