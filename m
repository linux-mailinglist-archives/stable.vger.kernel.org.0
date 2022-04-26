Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C645E50F59A
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345819AbiDZIry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346933AbiDZIpb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:45:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651603BBFD;
        Tue, 26 Apr 2022 01:36:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4624618E8;
        Tue, 26 Apr 2022 08:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F4CC385A0;
        Tue, 26 Apr 2022 08:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962211;
        bh=O5cWtjT6oZ9kHdt3jLx0dw74Nywf3PaeWXGX73eSrJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h8U5zN+LbLDcyYSiJ0UlwAT9RnmpiKXLmwGc3fFcoK4tDuKbsIQR3hBgS91Hh5huG
         RNLRc3tqINJqQ/ELBEmkIgEYra/2wibdzMHxsZIEtDPc+X2A8uzoydL+ssEaLvlEnQ
         wMyFUjyxU5Jv5w/4SLdm68GuwWtxPHU8f0gxgxT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Zhu <tony.zhu@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/124] dmaengine: idxd: fix device cleanup on disable
Date:   Tue, 26 Apr 2022 10:20:23 +0200
Message-Id: <20220426081747.936081453@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
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
index 7bd9ac1e93b2..a67bafc596b7 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -406,7 +406,6 @@ static void idxd_wq_device_reset_cleanup(struct idxd_wq *wq)
 {
 	lockdep_assert_held(&wq->wq_lock);
 
-	idxd_wq_disable_cleanup(wq);
 	wq->size = 0;
 	wq->group = NULL;
 }
@@ -723,9 +722,9 @@ static void idxd_device_wqs_clear_state(struct idxd_device *idxd)
 
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



