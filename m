Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF41E147CAB
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388084AbgAXJxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:53:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:56424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730133AbgAXJxl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:53:41 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1FEB20709;
        Fri, 24 Jan 2020 09:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859620;
        bh=N8ed4tULIYYaxf3fIJAOMpnrwIDztcA4sCHL5h3U8Vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fShQGmg73BZEgcJoQKHXy4Vcyo9hV65XzqpBGJtxMse3PGIx6PS7gVYKs6qz0Tno/
         vpAel4ZsfJOYz0ArpD+/a8EJmV0SlZi5xH7t6yf1ylkawFFzOBaewUvco8nfALvN6m
         PaIbxLuT0bvOV0e6z+MtP1dpSDnQUbLazno8+81g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nikita Danilov <nikita.danilov@aquantia.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 135/343] net: aquantia: fixed instack structure overflow
Date:   Fri, 24 Jan 2020 10:29:13 +0100
Message-Id: <20200124092937.735809945@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
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
index b0abd187cead9..b83ee74d28391 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
@@ -182,8 +182,8 @@ static int hw_atl_a0_hw_rss_set(struct aq_hw_s *self,
 	u32 i = 0U;
 	u32 num_rss_queues = max(1U, self->aq_nic_cfg->num_rss_queues);
 	int err = 0;
-	u16 bitary[(HW_ATL_A0_RSS_REDIRECTION_MAX *
-					HW_ATL_A0_RSS_REDIRECTION_BITS / 16U)];
+	u16 bitary[1 + (HW_ATL_A0_RSS_REDIRECTION_MAX *
+		   HW_ATL_A0_RSS_REDIRECTION_BITS / 16U)];
 
 	memset(bitary, 0, sizeof(bitary));
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 236325f48ec9b..1c1bb074f6645 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -183,8 +183,8 @@ static int hw_atl_b0_hw_rss_set(struct aq_hw_s *self,
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



