Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAA43F661D
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239868AbhHXRU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239315AbhHXRSi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:18:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6FD661ABD;
        Tue, 24 Aug 2021 17:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824578;
        bh=Z6xS0A5UkjrgyeYYqBQwPq5n29rhmu9mPXsS4uyHhIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tVBGt1P3PBzTbz+NzYkcRxG5Qf8U782cGEW+2ctcnwYs7sETnq3EvL7ICXbVos7Yy
         SeviKVncMWHAwfqDLygmuxZ1eJtHQeHlD03xLlVllCYjKS2t+8VpBNYdUqatnU6dSt
         wsiG64NiTydJUKUEzNSPq6IBPEL0zA0c6IAo6xtmEBt5WOsxNRGCnQYkh0Np7+IMHM
         INaXiWxNfFwdB74jriY8L/ZcjAj5oljlMnLm2JYckoX6s8YhiXhhZNCBYKw1NBv30r
         FJv1trHvw1JM4c/BPNjqxKTD9V29s38L0GpqiZ9/DUPYP2os2UWIFlqzLeowqCTyFv
         +jyIBirybtSbg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/84] ieee802154: hwsim: fix GPF in hwsim_set_edge_lqi
Date:   Tue, 24 Aug 2021 13:01:32 -0400
Message-Id: <20210824170250.710392-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit e9faf53c5a5d01f6f2a09ae28ec63a3bbd6f64fd ]

Both MAC802154_HWSIM_ATTR_RADIO_ID and MAC802154_HWSIM_ATTR_RADIO_EDGE,
MAC802154_HWSIM_EDGE_ATTR_ENDPOINT_ID and MAC802154_HWSIM_EDGE_ATTR_LQI
must be present to fix GPF.

Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Acked-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210705131321.217111-1-mudongliangabcd@gmail.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 06aadebc2d5b..82f3fbda7dfe 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -546,7 +546,7 @@ static int hwsim_set_edge_lqi(struct sk_buff *msg, struct genl_info *info)
 	u32 v0, v1;
 	u8 lqi;
 
-	if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] &&
+	if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] ||
 	    !info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE])
 		return -EINVAL;
 
@@ -555,7 +555,7 @@ static int hwsim_set_edge_lqi(struct sk_buff *msg, struct genl_info *info)
 			     hwsim_edge_policy, NULL))
 		return -EINVAL;
 
-	if (!edge_attrs[MAC802154_HWSIM_EDGE_ATTR_ENDPOINT_ID] &&
+	if (!edge_attrs[MAC802154_HWSIM_EDGE_ATTR_ENDPOINT_ID] ||
 	    !edge_attrs[MAC802154_HWSIM_EDGE_ATTR_LQI])
 		return -EINVAL;
 
-- 
2.30.2

