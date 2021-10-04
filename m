Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31001420FDE
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237524AbhJDNjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:39:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238197AbhJDNha (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:37:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEF9D61251;
        Mon,  4 Oct 2021 13:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353418;
        bh=UMf1XOVsHv94e0KkW/FqHK4srx1noV6Jb9GwHgOc0lU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zGupXx2HLjf4srTuzvbSerYJmq0IGB4lEah+ze1zKHzpR8W+F9E/HF2gf0sMbF7OZ
         N35tJqMqd9V29EFStxZBZn5KZSjoUr50tdGbVAyRQjw6BMMBlf32kcP0VQkDMvrPZp
         sASt2QkURNuOvlGFThSwRndYdZfB33h1XxoaxYeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 120/172] ionic: fix gathering of debug stats
Date:   Mon,  4 Oct 2021 14:52:50 +0200
Message-Id: <20211004125048.857007252@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit c23bb54f28d61a48008428e8cd320c947993919b ]

Don't print stats for which we haven't reserved space as it can
cause nasty memory bashing and related bad behaviors.

Fixes: aa620993b1e5 ("ionic: pull per-q stats work out of queue loops")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_stats.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_stats.c b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
index 58a854666c62..c14de5fcedea 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_stats.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
@@ -380,15 +380,6 @@ static void ionic_sw_stats_get_txq_values(struct ionic_lif *lif, u64 **buf,
 					  &ionic_dbg_intr_stats_desc[i]);
 		(*buf)++;
 	}
-	for (i = 0; i < IONIC_NUM_DBG_NAPI_STATS; i++) {
-		**buf = IONIC_READ_STAT64(&txqcq->napi_stats,
-					  &ionic_dbg_napi_stats_desc[i]);
-		(*buf)++;
-	}
-	for (i = 0; i < IONIC_MAX_NUM_NAPI_CNTR; i++) {
-		**buf = txqcq->napi_stats.work_done_cntr[i];
-		(*buf)++;
-	}
 	for (i = 0; i < IONIC_MAX_NUM_SG_CNTR; i++) {
 		**buf = txstats->sg_cntr[i];
 		(*buf)++;
-- 
2.33.0



