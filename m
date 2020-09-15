Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7D726B53F
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgIOXks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:40:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbgIOOem (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:34:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0589021D43;
        Tue, 15 Sep 2020 14:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179313;
        bh=Yt0b4gJDcQu0ta/aIo+Zh5yuVYciFiPTALHJWdllOX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLPI2MSWHHBxWF9TuG2L1CLpaXe39lJzcATAqhv+vVBNxB09ybIlw4Q9UZRBHZ0uW
         omdWbvqQ5NwWkCX8BEm9etqzBYFig9M8ryhPkBBFGTl50GW+sxqj+Qfz8IF2E3Y01E
         mweRtJ30SHrRgVJmWEkv6Avc9a9jyZARDrzpARiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/78] RDMA/core: Fix reported speed and width
Date:   Tue, 15 Sep 2020 16:12:36 +0200
Message-Id: <20200915140634.107587688@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
References: <20200915140633.552502750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

[ Upstream commit 28b0865714b315e318ac45c4fc9156f3d4649646 ]

When the returned speed from __ethtool_get_link_ksettings() is
SPEED_UNKNOWN this will lead to reporting a wrong speed and width for
providers that uses ib_get_eth_speed(), fix that by defaulting the
netdev_speed to SPEED_1000 in case the returned value from
__ethtool_get_link_ksettings() is SPEED_UNKNOWN.

Fixes: d41861942fc5 ("IB/core: Add generic function to extract IB speed from netdev")
Link: https://lore.kernel.org/r/20200902124304.170912-1-kamalheib1@gmail.com
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index e8432876cc860..e1ecd4682c096 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1711,7 +1711,7 @@ int ib_get_eth_speed(struct ib_device *dev, u8 port_num, u8 *speed, u8 *width)
 
 	dev_put(netdev);
 
-	if (!rc) {
+	if (!rc && lksettings.base.speed != (u32)SPEED_UNKNOWN) {
 		netdev_speed = lksettings.base.speed;
 	} else {
 		netdev_speed = SPEED_1000;
-- 
2.25.1



