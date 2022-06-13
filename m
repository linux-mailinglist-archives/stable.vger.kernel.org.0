Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A287549608
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358281AbiFMMCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356672AbiFMMAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:00:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72324F1D5;
        Mon, 13 Jun 2022 03:57:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E49B1B80E59;
        Mon, 13 Jun 2022 10:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC2EC34114;
        Mon, 13 Jun 2022 10:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117821;
        bh=YB9LyvTrRyk3XzyZg79/7s7AIqrmTsIjcd5nYkaq1FM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nigMMtnzFKDmiltmyJ8X80qS+QjMmafoCZitGY3palSCTYMr996SFQ0iRTsAOBsWN
         TvR7vU7+alebMme1kpDndbEM7t4CP0Bh6eeqG15hSrImVGFqvaMSySvhlD5l0zuZJz
         TpJUyFRlFhtJr/3OZ4yVC2UDx0adv2PeLErv6ah8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Douglas Miller <doug.miller@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 131/287] RDMA/hfi1: Prevent use of lock before it is initialized
Date:   Mon, 13 Jun 2022 12:09:15 +0200
Message-Id: <20220613094927.851859358@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Miller <doug.miller@cornelisnetworks.com>

[ Upstream commit 05c03dfd09c069c4ffd783b47b2da5dcc9421f2c ]

If there is a failure during probe of hfi1 before the sdma_map_lock is
initialized, the call to hfi1_free_devdata() will attempt to use a lock
that has not been initialized. If the locking correctness validator is on
then an INFO message and stack trace resembling the following may be seen:

  INFO: trying to register non-static key.
  The code is fine but needs lockdep annotation, or maybe
  you didn't initialize this object before use?
  turning off the locking correctness validator.
  Call Trace:
  register_lock_class+0x11b/0x880
  __lock_acquire+0xf3/0x7930
  lock_acquire+0xff/0x2d0
  _raw_spin_lock_irq+0x46/0x60
  sdma_clean+0x42a/0x660 [hfi1]
  hfi1_free_devdata+0x3a7/0x420 [hfi1]
  init_one+0x867/0x11a0 [hfi1]
  pci_device_probe+0x40e/0x8d0

The use of sdma_map_lock in sdma_clean() is for freeing the sdma_map
memory, and sdma_map is not allocated/initialized until after
sdma_map_lock has been initialized. This code only needs to be run if
sdma_map is not NULL, and so checking for that condition will avoid trying
to use the lock before it is initialized.

Fixes: 473291b3ea0e ("IB/hfi1: Fix for early release of sdma context")
Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Link: https://lore.kernel.org/r/20220520183701.48973.72434.stgit@awfm-01.cornelisnetworks.com
Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Douglas Miller <doug.miller@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/sdma.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 38258de75a94..33ff9eca28f6 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -1313,11 +1313,13 @@ void sdma_clean(struct hfi1_devdata *dd, size_t num_engines)
 		kvfree(sde->tx_ring);
 		sde->tx_ring = NULL;
 	}
-	spin_lock_irq(&dd->sde_map_lock);
-	sdma_map_free(rcu_access_pointer(dd->sdma_map));
-	RCU_INIT_POINTER(dd->sdma_map, NULL);
-	spin_unlock_irq(&dd->sde_map_lock);
-	synchronize_rcu();
+	if (rcu_access_pointer(dd->sdma_map)) {
+		spin_lock_irq(&dd->sde_map_lock);
+		sdma_map_free(rcu_access_pointer(dd->sdma_map));
+		RCU_INIT_POINTER(dd->sdma_map, NULL);
+		spin_unlock_irq(&dd->sde_map_lock);
+		synchronize_rcu();
+	}
 	kfree(dd->per_sdma);
 	dd->per_sdma = NULL;
 
-- 
2.35.1



