Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274A647ADCC
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236248AbhLTOzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:55:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57216 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238145AbhLTOxT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:53:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4153B80EEC;
        Mon, 20 Dec 2021 14:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E790CC36AF9;
        Mon, 20 Dec 2021 14:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011997;
        bh=YQstaUijfvG9IDkDNxFKPtKnwCdcUaE/GqDJlVfUTLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C70TFbj+iJHTGKjt8SqOSmaVmxB0/sPmjcLTTvTJnAJWr1Wt2BTtmvXCOegFxnbr7
         F6Uano7uDcQV7KNqJEmvBiAzvnA/hv80uMddPDGGiuu5sMsPiZ8WWF82r9YS5HLsMd
         PknyWnp5MQfdpYzyS0Lzue3BiFaFADk66GtFBUeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/177] dmaengine: idxd: fix calling wq quiesce inside spinlock
Date:   Mon, 20 Dec 2021 15:33:14 +0100
Message-Id: <20211220143041.584946515@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit fa51b16d05583c7aebbc06330afb50276243d198 ]

Dan reports that smatch has found idxd_wq_quiesce() is being called inside
the idxd->dev_lock. idxd_wq_quiesce() calls wait_for_completion() and
therefore it can sleep. Move the call outside of the spinlock as it does
not need device lock.

Fixes: 5b0c68c473a1 ("dmaengine: idxd: support reporting of halt interrupt")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/163716858508.1721911.15051495873516709923.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index 3261ea247e832..6d6af0dc3c0ec 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -137,10 +137,10 @@ static int process_misc_interrupts(struct idxd_device *idxd, u32 cause)
 			INIT_WORK(&idxd->work, idxd_device_reinit);
 			queue_work(idxd->wq, &idxd->work);
 		} else {
-			spin_lock(&idxd->dev_lock);
 			idxd->state = IDXD_DEV_HALTED;
 			idxd_wqs_quiesce(idxd);
 			idxd_wqs_unmap_portal(idxd);
+			spin_lock(&idxd->dev_lock);
 			idxd_device_clear_state(idxd);
 			dev_err(&idxd->pdev->dev,
 				"idxd halted, need %s.\n",
-- 
2.33.0



