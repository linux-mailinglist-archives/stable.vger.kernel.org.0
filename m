Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6612D48339C
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbiACOj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235332AbiACOht (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:37:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5069DC08EAF2;
        Mon,  3 Jan 2022 06:34:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F85AB80EFC;
        Mon,  3 Jan 2022 14:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D36AC36AEB;
        Mon,  3 Jan 2022 14:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220443;
        bh=L5NVFIqTyWhxBulYNxG2t8qMqN+Zt142hZOH8jA4RQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=11bMh6zDMt6EmZ98E/lzEllKUbZvcZdt0magyfgJGXU4DndsVxsRvzKTULwXUNw1Q
         Z1PAEwFMm8sUApyMKe1CTtNpuSzg9wb9D1S+F2d+Wbu/YHJoIjy5qdoU0wuCEVbOPF
         IckHP3QcX9cYt+2EUyuiISt8CPP8bRrausoki2Ds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        James McLaughlin <james.mclaughlin@qsc.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Nechama Kraus <nechamax.kraus@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 38/73] igc: Fix TX timestamp support for non-MSI-X platforms
Date:   Mon,  3 Jan 2022 15:23:59 +0100
Message-Id: <20220103142058.133082278@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James McLaughlin <james.mclaughlin@qsc.com>

[ Upstream commit f85846bbf43de38fb2c89fe7d2a085608c4eb25a ]

Time synchronization was not properly enabled on non-MSI-X platforms.

Fixes: 2c344ae24501 ("igc: Add support for TX timestamping")
Signed-off-by: James McLaughlin <james.mclaughlin@qsc.com>
Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 0e19b4d02e628..0a96627391a8c 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5466,6 +5466,9 @@ static irqreturn_t igc_intr_msi(int irq, void *data)
 			mod_timer(&adapter->watchdog_timer, jiffies + 1);
 	}
 
+	if (icr & IGC_ICR_TS)
+		igc_tsync_interrupt(adapter);
+
 	napi_schedule(&q_vector->napi);
 
 	return IRQ_HANDLED;
@@ -5509,6 +5512,9 @@ static irqreturn_t igc_intr(int irq, void *data)
 			mod_timer(&adapter->watchdog_timer, jiffies + 1);
 	}
 
+	if (icr & IGC_ICR_TS)
+		igc_tsync_interrupt(adapter);
+
 	napi_schedule(&q_vector->napi);
 
 	return IRQ_HANDLED;
-- 
2.34.1



