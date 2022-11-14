Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC71C628027
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237734AbiKNNDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:03:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237735AbiKNNDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:03:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC7FCC8
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:03:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 462AFB80EC5
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954F6C43140;
        Mon, 14 Nov 2022 13:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431009;
        bh=7MkqDnhVEf/JPDiNW/AHGMH6awNoc830WUzrNcNlWsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t73vcsoMp5CEcPkh/5SgEBF7XTVTx6dhEZ8H0Wx7hRo4f1659IWR0JCrPBtR19C4u
         gEmLNFdibUsot/b5+DeZMl3x1VJegqDh7GSCC/f36ROPPPX2gHaptB0cqjKYKu0kit
         xbhijh3xC5J49WY7XGQ7Z0hj0/17PZNe+9nv5Fic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Fengqian Gao <fengqian.gao@intel.com>,
        Xiaochen Shen <xiaochen.shen@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 066/190] dmaengine: idxd: fix RO device state error after been disabled/reset
Date:   Mon, 14 Nov 2022 13:44:50 +0100
Message-Id: <20221114124501.608090903@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fengqian Gao <fengqian.gao@intel.com>

[ Upstream commit 0b8c97a1d8c1bb6a853b8bb1778e8fef17b86fc9 ]

When IDXD is not configurable, that means its WQ, engine, and group
configurations cannot be changed. But it can be disabled and its state
should be set as disabled regardless it's configurable or not.

Fix this by setting device state IDXD_DEV_DISABLED for read-only device
as well in idxd_device_clear_state().

Fixes: cf4ac3fef338 ("dmaengine: idxd: fix lockdep warning on device driver removal")
Signed-off-by: Fengqian Gao <fengqian.gao@intel.com>
Reviewed-by: Xiaochen Shen <xiaochen.shen@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Link: https://lore.kernel.org/r/20220930032835.2290-1-fengqian.gao@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index cc7aabe4dc84..bd6e50f795be 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -724,13 +724,21 @@ static void idxd_device_wqs_clear_state(struct idxd_device *idxd)
 
 void idxd_device_clear_state(struct idxd_device *idxd)
 {
-	if (!test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags))
-		return;
+	/* IDXD is always disabled. Other states are cleared only when IDXD is configurable. */
+	if (test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags)) {
+		/*
+		 * Clearing wq state is protected by wq lock.
+		 * So no need to be protected by device lock.
+		 */
+		idxd_device_wqs_clear_state(idxd);
+
+		spin_lock(&idxd->dev_lock);
+		idxd_groups_clear_state(idxd);
+		idxd_engines_clear_state(idxd);
+	} else {
+		spin_lock(&idxd->dev_lock);
+	}
 
-	idxd_device_wqs_clear_state(idxd);
-	spin_lock(&idxd->dev_lock);
-	idxd_groups_clear_state(idxd);
-	idxd_engines_clear_state(idxd);
 	idxd->state = IDXD_DEV_DISABLED;
 	spin_unlock(&idxd->dev_lock);
 }
-- 
2.35.1



