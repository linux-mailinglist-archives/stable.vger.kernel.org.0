Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7626499DAC
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1586018AbiAXWZc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584560AbiAXWVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:21:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA84C0424DA;
        Mon, 24 Jan 2022 12:50:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE258B81063;
        Mon, 24 Jan 2022 20:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC093C340E5;
        Mon, 24 Jan 2022 20:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057452;
        bh=VsqcRsKeQsqwzqDqD0xbagbDVV5qUU0S+ZbEicARw10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRPU9U2cF+SAzpqNe5orUnSnqnCKqqLsrM1HoAZPlLVN8UL6EHvyYdcwQn1uAXB6q
         1Xq/a/+VnHuis7/m9d0fIka/gW0vE88Fs6LGijZGfjoMK8XwzKVskWeonKI+4Jh6Ba
         TV8fsj5IEW6qVLEgmqZR4e5HVBgEjeZUsHv/MldA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gu <guwen@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 790/846] net/smc: Fix hung_task when removing SMC-R devices
Date:   Mon, 24 Jan 2022 19:45:07 +0100
Message-Id: <20220124184128.213697931@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Gu <guwen@linux.alibaba.com>

commit 56d99e81ecbc997a5f984684d0eeb583992b2072 upstream.

A hung_task is observed when removing SMC-R devices. Suppose that
a link group has two active links(lnk_A, lnk_B) associated with two
different SMC-R devices(dev_A, dev_B). When dev_A is removed, the
link group will be removed from smc_lgr_list and added into
lgr_linkdown_list. lnk_A will be cleared and smcibdev(A)->lnk_cnt
will reach to zero. However, when dev_B is removed then, the link
group can't be found in smc_lgr_list and lnk_B won't be cleared,
making smcibdev->lnk_cnt never reaches zero, which causes a hung_task.

This patch fixes this issue by restoring the implementation of
smc_smcr_terminate_all() to what it was before commit 349d43127dac
("net/smc: fix kernel panic caused by race of smc_sock"). The original
implementation also satisfies the intention that make sure QP destroy
earlier than CQ destroy because we will always wait for smcibdev->lnk_cnt
reaches zero, which guarantees QP has been destroyed.

Fixes: 349d43127dac ("net/smc: fix kernel panic caused by race of smc_sock")
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_core.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1387,16 +1387,11 @@ void smc_smcd_terminate_all(struct smcd_
 /* Called when an SMCR device is removed or the smc module is unloaded.
  * If smcibdev is given, all SMCR link groups using this device are terminated.
  * If smcibdev is NULL, all SMCR link groups are terminated.
- *
- * We must wait here for QPs been destroyed before we destroy the CQs,
- * or we won't received any CQEs and cdc_pend_tx_wr cannot reach 0 thus
- * smc_sock cannot be released.
  */
 void smc_smcr_terminate_all(struct smc_ib_device *smcibdev)
 {
 	struct smc_link_group *lgr, *lg;
 	LIST_HEAD(lgr_free_list);
-	LIST_HEAD(lgr_linkdown_list);
 	int i;
 
 	spin_lock_bh(&smc_lgr_list.lock);
@@ -1408,7 +1403,7 @@ void smc_smcr_terminate_all(struct smc_i
 		list_for_each_entry_safe(lgr, lg, &smc_lgr_list.list, list) {
 			for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 				if (lgr->lnk[i].smcibdev == smcibdev)
-					list_move_tail(&lgr->list, &lgr_linkdown_list);
+					smcr_link_down_cond_sched(&lgr->lnk[i]);
 			}
 		}
 	}
@@ -1420,16 +1415,6 @@ void smc_smcr_terminate_all(struct smc_i
 		__smc_lgr_terminate(lgr, false);
 	}
 
-	list_for_each_entry_safe(lgr, lg, &lgr_linkdown_list, list) {
-		for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-			if (lgr->lnk[i].smcibdev == smcibdev) {
-				mutex_lock(&lgr->llc_conf_mutex);
-				smcr_link_down_cond(&lgr->lnk[i]);
-				mutex_unlock(&lgr->llc_conf_mutex);
-			}
-		}
-	}
-
 	if (smcibdev) {
 		if (atomic_read(&smcibdev->lnk_cnt))
 			wait_event(smcibdev->lnks_deleted,


