Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 453321480AE
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390053AbgAXLN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:13:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389042AbgAXLN2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:13:28 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9ECF2071A;
        Fri, 24 Jan 2020 11:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864407;
        bh=XY215XUO9c8E57PJyQfFKHKFTaPma3O7mFZV3Xb8Z9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fbXgazzjliWKFffF2D+PMuMMVRZjdLrgjLG+V5QBJdyxYxIAHv/X+EbVUYd5gqVb6
         WXHzRtWso9wgy7TBeRhBMCCttLH3/8up9AJgysAFfNKPz8C7W46YuZbjYVhdDLapxm
         4WaDk68wegYWiAqPEYNSM6mYLjZigINAL3cgU6NY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nikita Danilov <nikita.danilov@aquantia.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 248/639] net: aquantia: fixed instack structure overflow
Date:   Fri, 24 Jan 2020 10:26:58 +0100
Message-Id: <20200124093117.825342615@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Igor Russkikh <Igor.Russkikh@aquantia.com>

[ Upstream commit 8006e3730b6e900319411e35cee85b4513d298df ]

This is a real stack undercorruption found by kasan build.

The issue did no harm normally because it only overflowed
2 bytes after `bitary` array which on most architectures
were mapped into `err` local.

Fixes: bab6de8fd180 ("net: ethernet: aquantia: Atlantic A0 and B0 specific functions.")
Signed-off-by: Nikita Danilov <nikita.danilov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c | 4 ++--
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
index 97addfa6f8956..dab5891b97145 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
@@ -207,8 +207,8 @@ static int hw_atl_a0_hw_rss_set(struct aq_hw_s *self,
 	u32 i = 0U;
 	u32 num_rss_queues = max(1U, self->aq_nic_cfg->num_rss_queues);
 	int err = 0;
-	u16 bitary[(HW_ATL_A0_RSS_REDIRECTION_MAX *
-					HW_ATL_A0_RSS_REDIRECTION_BITS / 16U)];
+	u16 bitary[1 + (HW_ATL_A0_RSS_REDIRECTION_MAX *
+		   HW_ATL_A0_RSS_REDIRECTION_BITS / 16U)];
 
 	memset(bitary, 0, sizeof(bitary));
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 51cd1f98bcf07..c4f914a29c385 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -192,8 +192,8 @@ static int hw_atl_b0_hw_rss_set(struct aq_hw_s *self,
 	u32 i = 0U;
 	u32 num_rss_queues = max(1U, self->aq_nic_cfg->num_rss_queues);
 	int err = 0;
-	u16 bitary[(HW_ATL_B0_RSS_REDIRECTION_MAX *
-					HW_ATL_B0_RSS_REDIRECTION_BITS / 16U)];
+	u16 bitary[1 + (HW_ATL_B0_RSS_REDIRECTION_MAX *
+		   HW_ATL_B0_RSS_REDIRECTION_BITS / 16U)];
 
 	memset(bitary, 0, sizeof(bitary));
 
-- 
2.20.1



