Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89DA246975
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbgHQPWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:22:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729434AbgHQPWR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:22:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA0DF23101;
        Mon, 17 Aug 2020 15:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677736;
        bh=VhMqv89aKVSu2wYlMStOJnpTIrVpsgyXhjWZ+wheO74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bp1VKtTeQzsTo40D6hIU9yB5oU1PAbK9zmH15v38TpBrWLVAsYP+gjEAHOaWV9Pgo
         ajGFwshqyH1vj1xIMxUAdFMafwlTG6uZBHM8Bq5axC16oZ93w31Ynb6nokVm4II6Cc
         EShsIs6jBpd4ps921BmuLZXbiTw0k0ttJEcgEZXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chengming Zhou <zhouchengming@bytedance.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 058/464] iocost: Fix check condition of iocg abs_vdebt
Date:   Mon, 17 Aug 2020 17:10:11 +0200
Message-Id: <20200817143836.543336190@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8ac4aad66ebc3..86ba6fd254e1d 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1370,7 +1370,7 @@ static void ioc_timer_fn(struct timer_list *timer)
 	 * should have woken up in the last period and expire idle iocgs.
 	 */
 	list_for_each_entry_safe(iocg, tiocg, &ioc->active_iocgs, active_list) {
-		if (!waitqueue_active(&iocg->waitq) && iocg->abs_vdebt &&
+		if (!waitqueue_active(&iocg->waitq) && !iocg->abs_vdebt &&
 		    !iocg_is_idle(iocg))
 			continue;
 
-- 
2.25.1



