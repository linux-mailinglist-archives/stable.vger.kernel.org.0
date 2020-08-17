Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDCC624753E
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388893AbgHQTVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730501AbgHQPgi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:36:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABEDB20709;
        Mon, 17 Aug 2020 15:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678589;
        bh=KVA7jIGmUpUlfr8yJQEV2oOgWlA9Co+YOsKvENc/6E0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bk3SJilwnN+OQwd7pltbpcd68rYccOITgkPIvEehbdQCHXFZ5qFMAWvVg+k6z9k3e
         24dYIzRK6IJ4b2tJKsk8t7lI7rXgf9Y1SLEh0EY7QEnVH8j05cm7POUlWwDMXCwfEX
         NAGI5uIKA/rhCtnJ3xOyynhVLLYQQTkneyGXrqIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David VomLehn <vomlehn@texas.net>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 356/464] net: ethernet: aquantia: Fix wrong return value
Date:   Mon, 17 Aug 2020 17:15:09 +0200
Message-Id: <20200817143850.818079496@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

[ Upstream commit 0470a48880f8bc42ce26962b79c7b802c5a695ec ]

In function hw_atl_a0_hw_multicast_list_set(), when an invalid
request is encountered, a negative error code should be returned.

Fixes: bab6de8fd180b ("net: ethernet: aquantia: Atlantic A0 and B0 specific functions")
Cc: David VomLehn <vomlehn@texas.net>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
index a312864969afe..6640fd35b29b2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
@@ -782,7 +782,7 @@ static int hw_atl_a0_hw_multicast_list_set(struct aq_hw_s *self,
 	int err = 0;
 
 	if (count > (HW_ATL_A0_MAC_MAX - HW_ATL_A0_MAC_MIN)) {
-		err = EBADRQC;
+		err = -EBADRQC;
 		goto err_exit;
 	}
 	for (self->aq_nic_cfg->mc_list_count = 0U;
-- 
2.25.1



