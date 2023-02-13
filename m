Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680046948CB
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjBMOxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjBMOxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:53:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246BE1CADE
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:53:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3A53B8125B
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49FBC433D2;
        Mon, 13 Feb 2023 14:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676299989;
        bh=ynkc7p+vQSO7aJs0qHyZwSYXlgXJ4AXGD6bY1HBRZoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D22XOWwj72EhrtbcVpFBRlw4OcgMJe/+dcdc9ncUBeGDcqRs6xOQiA2sXxtpTSv9l
         UZtEln3peW14aeFru0BUlGLDVbObKYtjXkJbKFDdFBf3H4f439jEg8sxkeV7JPAHOd
         byc5c/5PlaQq9N1pGRzHd1BM7999FykqR9pUbe9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
        Sindhu Devale <sindhu.devale@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/114] RDMA/irdma: Fix potential NULL-ptr-dereference
Date:   Mon, 13 Feb 2023 15:47:36 +0100
Message-Id: <20230213144743.247946326@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit 5d9745cead1f121974322b94ceadfb4d1e67960e ]

in_dev_get() can return NULL which will cause a failure once idev is
dereferenced in in_dev_for_each_ifa_rtnl(). This patch adds a
check for NULL value in idev beforehand.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 146b9756f14c ("RDMA/irdma: Add connection manager")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Link: https://lore.kernel.org/r/20230126185230.62464-1-n.zhandarovich@fintech.ru
Reviewed-by: Sindhu Devale <sindhu.devale@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/cm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma/cm.c
index 7b086fe63a245..195aa9ea18b6c 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -1722,6 +1722,9 @@ static int irdma_add_mqh_4(struct irdma_device *iwdev,
 			continue;
 
 		idev = in_dev_get(ip_dev);
+		if (!idev)
+			continue;
+
 		in_dev_for_each_ifa_rtnl(ifa, idev) {
 			ibdev_dbg(&iwdev->ibdev,
 				  "CM: Allocating child CM Listener forIP=%pI4, vlan_id=%d, MAC=%pM\n",
-- 
2.39.0



