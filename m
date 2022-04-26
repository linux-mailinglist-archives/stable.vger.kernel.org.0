Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9063350F8C4
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346330AbiDZJHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347175AbiDZJFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:05:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1528A7B138;
        Tue, 26 Apr 2022 01:44:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70C0CB81A2F;
        Tue, 26 Apr 2022 08:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6101C385A0;
        Tue, 26 Apr 2022 08:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962651;
        bh=YT0TQpCJuFryPx3YwctFYZLSB1ycbxSfcqaPeBl/pbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lH+SQ90JYrKvWjRIUywAqgCZepPlVOxkN4UyHPSt3RYNlwLY2saStTSyy/gGtJkL+
         0pTOLlVwZ8WfDOG+szr+AKGH/0jgf4iCCbwHidmH7v7IViZUaHaXsJXG7kQfkmu1vR
         +S+yXCd8nsD2WlR6M/CHXzKeDVecz7GUy6cFaHaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Zhu <tony.zhu@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 016/146] dmaengine: idxd: fix device cleanup on disable
Date:   Tue, 26 Apr 2022 10:20:11 +0200
Message-Id: <20220426081750.522108976@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 12e45e89556d7a532120f976081e9e7582addd2b ]

There are certain parts of WQ that needs to be cleaned up even after WQ is
disabled during the device disable. Those are the unchangeable parts for a
WQ when the device is still enabled. Move the cleanup outside of WQ state
check. Remove idxd_wq_disable_cleanup() inside idxd_wq_device_reset_cleanup()
since only the unchangeable parts need to be cleared.

Fixes: 0f225705cf65 ("dmaengine: idxd: fix wq settings post wq disable")
Reported-by: Tony Zhu <tony.zhu@intel.com>
Tested-by: Tony Zhu <tony.zhu@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/164919561905.1455025.13542366389944678346.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 3061fe857d69..5a0535a0f850 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -373,7 +373,6 @@ static void idxd_wq_device_reset_cleanup(struct idxd_wq *wq)
 {
 	lockdep_assert_held(&wq->wq_lock);
 
-	idxd_wq_disable_cleanup(wq);
 	wq->size = 0;
 	wq->group = NULL;
 }
@@ -701,9 +700,9 @@ static void idxd_device_wqs_clear_state(struct idxd_device *idxd)
 
 		if (wq->state == IDXD_WQ_ENABLED) {
 			idxd_wq_disable_cleanup(wq);
-			idxd_wq_device_reset_cleanup(wq);
 			wq->state = IDXD_WQ_DISABLED;
 		}
+		idxd_wq_device_reset_cleanup(wq);
 	}
 }
 
-- 
2.35.1



