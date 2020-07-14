Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F81721FBAD
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbgGNTDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:03:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731148AbgGNS5W (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:57:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16172229CA;
        Tue, 14 Jul 2020 18:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753041;
        bh=jnp0t6ErVSfA+lpTQq88zRCWkkjlAaptnMPyR4Wd4Ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPz9lbTHa+YCCBQHu0IEyvLszQ4lsm+fpkCL2b2bSYk0JT6peudLuTydywVUXTL5D
         2+Zh1PEp9HB7CvqOyyq890oy12rwIn8nsZtLQCRwTKd5lAzQ30UsrI0x/3kqRCrm41
         hE1fmXJsEHg37AlsqpHjYgGN5UiTPNz5VGkLSzBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 090/166] cxgb4: fix all-mask IP address comparison
Date:   Tue, 14 Jul 2020 20:44:15 +0200
Message-Id: <20200714184120.150771598@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

[ Upstream commit 76c4d85c9260c3d741cbd194c30c61983d0a4303 ]

Convert all-mask IP address to Big Endian, instead, for comparison.

Fixes: f286dd8eaad5 ("cxgb4: use correct type for all-mask IP address comparison")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index 7a7f61a8cdf40..d02d346629b36 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -1112,16 +1112,16 @@ static bool is_addr_all_mask(u8 *ipmask, int family)
 		struct in_addr *addr;
 
 		addr = (struct in_addr *)ipmask;
-		if (ntohl(addr->s_addr) == 0xffffffff)
+		if (addr->s_addr == htonl(0xffffffff))
 			return true;
 	} else if (family == AF_INET6) {
 		struct in6_addr *addr6;
 
 		addr6 = (struct in6_addr *)ipmask;
-		if (ntohl(addr6->s6_addr32[0]) == 0xffffffff &&
-		    ntohl(addr6->s6_addr32[1]) == 0xffffffff &&
-		    ntohl(addr6->s6_addr32[2]) == 0xffffffff &&
-		    ntohl(addr6->s6_addr32[3]) == 0xffffffff)
+		if (addr6->s6_addr32[0] == htonl(0xffffffff) &&
+		    addr6->s6_addr32[1] == htonl(0xffffffff) &&
+		    addr6->s6_addr32[2] == htonl(0xffffffff) &&
+		    addr6->s6_addr32[3] == htonl(0xffffffff))
 			return true;
 	}
 	return false;
-- 
2.25.1



