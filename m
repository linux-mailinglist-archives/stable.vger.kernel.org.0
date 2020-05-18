Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DDA1D85E1
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729686AbgERSVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:21:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730879AbgERRvf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:51:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 285D720826;
        Mon, 18 May 2020 17:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824294;
        bh=Yci84up+VDf4LFh3i5lZgGmVwgZzDWVjnLjyFZsAH0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CusfaS9ShRPaZyD9vTpGkRC8IUROSW/baMDfZmZdk1VfQHaKJF2HNSkWqZqELvCHF
         krUcUzEnEbyPgI2YLyU1wbndTgj7PDyE0FPl1W4tnFbrpf/0+9oj1+b44MNNB4EdnX
         SIARkLqk5poqiwe9HQKZi9s0renhjKNc78ZPL74s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 35/80] mmc: block: Fix request completion in the CQE timeout path
Date:   Mon, 18 May 2020 19:36:53 +0200
Message-Id: <20200518173457.510515989@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
References: <20200518173450.097837707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit c077dc5e0620508a29497dac63a2822324ece52a ]

First, it should be noted that the CQE timeout (60 seconds) is substantial
so a CQE request that times out is really stuck, and the race between
timeout and completion is extremely unlikely. Nevertheless this patch
fixes an issue with it.

Commit ad73d6feadbd7b ("mmc: complete requests from ->timeout")
preserved the existing functionality, to complete the request.
However that had only been necessary because the block layer
timeout handler had been marking the request to prevent it from being
completed normally. That restriction was removed at the same time, the
result being that a request that has gone will have been completed anyway.
That is, the completion was unnecessary.

At the time, the unnecessary completion was harmless because the block
layer would ignore it, although that changed in kernel v5.0.

Note for stable, this patch will not apply cleanly without patch "mmc:
core: Fix recursive locking issue in CQE recovery path"

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Fixes: ad73d6feadbd7b ("mmc: complete requests from ->timeout")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200508062227.23144-1-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/queue.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
index becc6594a8a47..03f3d9c80fbac 100644
--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -111,8 +111,7 @@ static enum blk_eh_timer_return mmc_cqe_timed_out(struct request *req)
 				__mmc_cqe_recovery_notifier(mq);
 			return BLK_EH_RESET_TIMER;
 		}
-		/* No timeout (XXX: huh? comment doesn't make much sense) */
-		blk_mq_complete_request(req);
+		/* The request has gone already */
 		return BLK_EH_DONE;
 	default:
 		/* Timeout is handled by mmc core */
-- 
2.20.1



