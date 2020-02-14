Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE1A315DBB4
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730205AbgBNPtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:49:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730188AbgBNPtr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:49:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6198D2468F;
        Fri, 14 Feb 2020 15:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695386;
        bh=GY003Kf7o5vi7BB4jlvFQ9Zp0hgkYbEd9tJw0MG2Pn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HCzlEkYu7+xOfS2PyebajIh5dUdtLThJvI65q9Fu/lILlRMTR7LVmjb7W1VaoNdW5
         dk0cbMA+8s5Gbuy1JVwwWTCKDDMUCXYQnqjkrSEzsM6942srG4LUKwapbzm/flpt6M
         QCaSoua8GB7tqiQczZqg+43rAfKKiAajzxX25WFc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 040/542] RDMA/i40iw: fix a potential NULL pointer dereference
Date:   Fri, 14 Feb 2020 10:40:32 -0500
Message-Id: <20200214154854.6746-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit 04db1580b5e48a79e24aa51ecae0cd4b2296ec23 ]

A NULL pointer can be returned by in_dev_get(). Thus add a corresponding
check so that a NULL pointer dereference will be avoided at this place.

Fixes: 8e06af711bf2 ("i40iw: add main, hdr, status")
Link: https://lore.kernel.org/r/1577672668-46499-1-git-send-email-xiyuyang19@fudan.edu.cn
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/i40iw/i40iw_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index d44cf33df81ae..238614370927a 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -1225,6 +1225,8 @@ static void i40iw_add_ipv4_addr(struct i40iw_device *iwdev)
 			const struct in_ifaddr *ifa;
 
 			idev = in_dev_get(dev);
+			if (!idev)
+				continue;
 			in_dev_for_each_ifa_rtnl(ifa, idev) {
 				i40iw_debug(&iwdev->sc_dev, I40IW_DEBUG_CM,
 					    "IP=%pI4, vlan_id=%d, MAC=%pM\n", &ifa->ifa_address,
-- 
2.20.1

