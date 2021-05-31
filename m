Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B04395EA9
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbhEaOBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:01:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233099AbhEaN72 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:59:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73ABB61938;
        Mon, 31 May 2021 13:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468165;
        bh=pGVpLtSMWaOVVz49mJPWWGTE8xs1/cMgTS/V3efAK3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c0O7fS/8EosUk9dt+2YSoS09ZYOI9lHgc0vUHpBHRiT7q5+Y9Ttvfy2D9KpP1v75K
         ysQns6SUwWSLBDaEBTFmQY8miUdKgMq3VJ4NY9jSqI7lIX/67+IHXbcVW6muH5yGOG
         TG7ha5Jom8tBUdJLPojsa1KXmP2z893F4eBddBFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/252] net/smc: properly handle workqueue allocation failure
Date:   Mon, 31 May 2021 15:13:25 +0200
Message-Id: <20210531130702.773639175@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Rayabharam <mail@anirudhrb.com>

[ Upstream commit bbeb18f27a44ce6adb00d2316968bc59dc640b9b ]

In smcd_alloc_dev(), if alloc_ordered_workqueue() fails, properly catch
it, clean up and return NULL to let the caller know there was a failure.
Move the call to alloc_ordered_workqueue higher in the function in order
to abort earlier without needing to unwind the call to device_initialize().

Cc: Ursula Braun <ubraun@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Link: https://lore.kernel.org/r/20210503115736.2104747-18-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_ism.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index b4a9fe452470..024ca21392f7 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -304,6 +304,14 @@ struct smcd_dev *smcd_alloc_dev(struct device *parent, const char *name,
 		return NULL;
 	}
 
+	smcd->event_wq = alloc_ordered_workqueue("ism_evt_wq-%s)",
+						 WQ_MEM_RECLAIM, name);
+	if (!smcd->event_wq) {
+		kfree(smcd->conn);
+		kfree(smcd);
+		return NULL;
+	}
+
 	smcd->dev.parent = parent;
 	smcd->dev.release = smcd_release;
 	device_initialize(&smcd->dev);
@@ -317,8 +325,6 @@ struct smcd_dev *smcd_alloc_dev(struct device *parent, const char *name,
 	INIT_LIST_HEAD(&smcd->vlan);
 	INIT_LIST_HEAD(&smcd->lgr_list);
 	init_waitqueue_head(&smcd->lgrs_deleted);
-	smcd->event_wq = alloc_ordered_workqueue("ism_evt_wq-%s)",
-						 WQ_MEM_RECLAIM, name);
 	return smcd;
 }
 EXPORT_SYMBOL_GPL(smcd_alloc_dev);
-- 
2.30.2



