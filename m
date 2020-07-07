Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B8B2171D3
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729924AbgGGP0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:26:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728467AbgGGP0G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:26:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D5322065D;
        Tue,  7 Jul 2020 15:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135565;
        bh=8GNSDHYDMvwSBRWytulC9UqzU2sDvXg/VKTWvHv2yB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LhmPECyZom5DpP8uFXclr1GpJ5pbYVJVwRYDGAXWMmab3MBvlbKFmaaKL092Rmhe0
         INDRM8sDsgsCW1PTbyZ/u/EHpJKDZB/Ztp0rMUpSrx0cbp7NnwlVlzrU71V0U7jni2
         g3aMJsIg+vpICNnk3jPSsnBtWt6HD/ATo4x/JLsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 061/112] cxgb4: use correct type for all-mask IP address comparison
Date:   Tue,  7 Jul 2020 17:17:06 +0200
Message-Id: <20200707145803.903081848@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

[ Upstream commit f286dd8eaad5a2758750f407ab079298e0bcc8a5 ]

Use correct type to check for all-mask exact match IP addresses.

Fixes following sparse warnings due to big endian value checks
against 0xffffffff in is_addr_all_mask():
cxgb4_filter.c:977:25: warning: restricted __be32 degrades to integer
cxgb4_filter.c:983:37: warning: restricted __be32 degrades to integer
cxgb4_filter.c:984:37: warning: restricted __be32 degrades to integer
cxgb4_filter.c:985:37: warning: restricted __be32 degrades to integer
cxgb4_filter.c:986:37: warning: restricted __be32 degrades to integer

Fixes: 3eb8b62d5a26 ("cxgb4: add support to create hash-filters via tc-flower offload")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index c6bf2648fe420..7a7f61a8cdf40 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -1112,16 +1112,16 @@ static bool is_addr_all_mask(u8 *ipmask, int family)
 		struct in_addr *addr;
 
 		addr = (struct in_addr *)ipmask;
-		if (addr->s_addr == 0xffffffff)
+		if (ntohl(addr->s_addr) == 0xffffffff)
 			return true;
 	} else if (family == AF_INET6) {
 		struct in6_addr *addr6;
 
 		addr6 = (struct in6_addr *)ipmask;
-		if (addr6->s6_addr32[0] == 0xffffffff &&
-		    addr6->s6_addr32[1] == 0xffffffff &&
-		    addr6->s6_addr32[2] == 0xffffffff &&
-		    addr6->s6_addr32[3] == 0xffffffff)
+		if (ntohl(addr6->s6_addr32[0]) == 0xffffffff &&
+		    ntohl(addr6->s6_addr32[1]) == 0xffffffff &&
+		    ntohl(addr6->s6_addr32[2]) == 0xffffffff &&
+		    ntohl(addr6->s6_addr32[3]) == 0xffffffff)
 			return true;
 	}
 	return false;
-- 
2.25.1



