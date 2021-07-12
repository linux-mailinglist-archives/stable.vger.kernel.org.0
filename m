Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6699C3C53AF
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348427AbhGLHzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350610AbhGLHvL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E7D361A2B;
        Mon, 12 Jul 2021 07:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075987;
        bh=y5Lnoru8//4X3M1ps+Cte5jXS4CHxA3GZSXdzlTp6FY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=okpAlsFoUUYZcWrVxccIcH8ELvbCRfTGhe7yD1UHEAjixyUz+Am/bRwaT/OI27fsG
         TSDzdb0ZSAbCUmVvfvhrxdCCSemj1lrrvhqYIxG7WSfUUp91oO2XQyJopL+aetSFWK
         chTx5Ze/O3PBPdt61ewv6zYIX6OimctXeLtB6xMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matteo Croce <mcroce@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 450/800] stmmac: prefetch right address
Date:   Mon, 12 Jul 2021 08:07:53 +0200
Message-Id: <20210712061014.994190372@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

[ Upstream commit 4744bf072b4640c5e2ea65c2361ad6c832f28fa8 ]

To support XDP, a headroom is prepended to the packet data.
Consider this offset when doing a prefetch.

Fixes: da5ec7f22a0f ("net: stmmac: refactor stmmac_init_rx_buffers for stmmac_reinit_rx_buffers")
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c87202cbd3d6..91cd5073ddb2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5138,7 +5138,7 @@ read_again:
 
 		/* Buffer is good. Go on. */
 
-		prefetch(page_address(buf->page));
+		prefetch(page_address(buf->page) + buf->page_offset);
 		if (buf->sec_page)
 			prefetch(page_address(buf->sec_page));
 
-- 
2.30.2



