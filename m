Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C3E60881E
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbiJVIKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbiJVII2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:08:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AEA2CB8BA;
        Sat, 22 Oct 2022 00:53:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8789860B83;
        Sat, 22 Oct 2022 07:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8531FC43470;
        Sat, 22 Oct 2022 07:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425167;
        bh=k9UmSSd24VoHD4EdvwgqSONVwGFzHEbaHDORRiPVUfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=naz7o3c014gL0BG8ejmgL+BXYtjb6VfmbAl6bnX1uycoTAvNsFtgzY3bxlfnQ14OO
         fLlVbyh/okQGAHZBXEdNmOXumvkprRxaz4Khl3DgIuzc7tAWzA+d9OCTXNgxjpMKK0
         cWpmizbahHcHoPPvTPVQtTDD/3g1pZnJ7pe+lYxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 412/717] dmaengine: idxd: avoid deadlock in process_misc_interrupts()
Date:   Sat, 22 Oct 2022 09:24:51 +0200
Message-Id: <20221022072516.329391173@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerry Snitselaar <jsnitsel@redhat.com>

[ Upstream commit 407171717a4f4d2d80825584643374a2dfdb0540 ]

idxd_device_clear_state() now grabs the idxd->dev_lock
itself, so don't grab the lock prior to calling it.

This was seen in testing after dmar fault occurred on system,
resulting in lockup stack traces.

Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: dmaengine@vger.kernel.org
Fixes: cf4ac3fef338 ("dmaengine: idxd: fix lockdep warning on device driver removal")
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20220823163709.2102468-1-jsnitsel@redhat.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/irq.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index 743ead5ebc57..5b9921475be6 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -324,13 +324,11 @@ static int process_misc_interrupts(struct idxd_device *idxd, u32 cause)
 			idxd->state = IDXD_DEV_HALTED;
 			idxd_wqs_quiesce(idxd);
 			idxd_wqs_unmap_portal(idxd);
-			spin_lock(&idxd->dev_lock);
 			idxd_device_clear_state(idxd);
 			dev_err(&idxd->pdev->dev,
 				"idxd halted, need %s.\n",
 				gensts.reset_type == IDXD_DEVICE_RESET_FLR ?
 				"FLR" : "system reset");
-			spin_unlock(&idxd->dev_lock);
 			return -ENXIO;
 		}
 	}
-- 
2.35.1



