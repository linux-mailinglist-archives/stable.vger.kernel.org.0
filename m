Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B070965EB8B
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbjAENAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:00:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbjAEM7s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 07:59:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D6B58F9E
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 04:59:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1C82B81ACE
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 12:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29001C433D2;
        Thu,  5 Jan 2023 12:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923580;
        bh=G7E1iqakTX/tIagmnrHh7XUZgSQyn0DR+QulAV70MPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vkr7p6jBQ8KUC93Ad48BDvhQkudagBta+8M4I6d5RJNyHrJa6b9BBt8o8+QoaJ0+1
         esDFYO4ovKh+yMmv4zFmiTo3S6wwu02mFqNRZJU2FS17vE8i8LP7lfZ+Ctmg+BiiVe
         kJdns/jzj+PEvczCeK3YG9W9jMA7uFlUNmM/eQdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 036/251] PNP: fix name memory leak in pnp_alloc_dev()
Date:   Thu,  5 Jan 2023 13:52:53 +0100
Message-Id: <20230105125336.410234964@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 110d7b0325c55ff3620073ba4201845f59e22ebf ]

After commit 1fa5ae857bb1 ("driver core: get rid of struct device's
bus_id string array"), the name of device is allocated dynamically,
move dev_set_name() after pnp_add_id() to avoid memory leak.

Fixes: 1fa5ae857bb1 ("driver core: get rid of struct device's bus_id string array")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pnp/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pnp/core.c b/drivers/pnp/core.c
index b54620e53830..3d5865c7694b 100644
--- a/drivers/pnp/core.c
+++ b/drivers/pnp/core.c
@@ -159,14 +159,14 @@ struct pnp_dev *pnp_alloc_dev(struct pnp_protocol *protocol, int id,
 	dev->dev.coherent_dma_mask = dev->dma_mask;
 	dev->dev.release = &pnp_release_device;
 
-	dev_set_name(&dev->dev, "%02x:%02x", dev->protocol->number, dev->number);
-
 	dev_id = pnp_add_id(dev, pnpid);
 	if (!dev_id) {
 		kfree(dev);
 		return NULL;
 	}
 
+	dev_set_name(&dev->dev, "%02x:%02x", dev->protocol->number, dev->number);
+
 	return dev;
 }
 
-- 
2.35.1



