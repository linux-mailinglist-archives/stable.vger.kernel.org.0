Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E5334C67C
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbhC2IIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:08:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231857AbhC2IGq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:06:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC86261938;
        Mon, 29 Mar 2021 08:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005206;
        bh=8NllxWJv8dV/rvVnmt0yfm1APsDLRkh9hQKgcfErAOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JpqICv6Rf3bj1TNzZBb3sWJoOzEhaxjzGsmaNlgxHTuq8RP2lbpsDAgjz7bJ0OA3X
         2eLYQbX2Df8MiD0O84GoCc2qyHLK/RiRpqvyCX5i6Q9SgorAlGgJYSvrOTfyK4q30z
         SIOnGqI5mXt9ts/GLlcNoRkKxc8C5h4LlUbzkNl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dylan Hung <dylan_hung@aspeedtech.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Joel Stanley <joel@jms.id.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 36/59] ftgmac100: Restart MAC HW once
Date:   Mon, 29 Mar 2021 09:58:16 +0200
Message-Id: <20210329075610.070177031@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075608.898173317@linuxfoundation.org>
References: <20210329075608.898173317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dylan Hung <dylan_hung@aspeedtech.com>

[ Upstream commit 6897087323a2fde46df32917462750c069668b2f ]

The interrupt handler may set the flag to reset the mac in the future,
but that flag is not cleared once the reset has occurred.

Fixes: 10cbd6407609 ("ftgmac100: Rework NAPI & interrupts handling")
Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index b28425f4cfac..f35c5dbe54ee 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1328,6 +1328,7 @@ static int ftgmac100_poll(struct napi_struct *napi, int budget)
 	 */
 	if (unlikely(priv->need_mac_restart)) {
 		ftgmac100_start_hw(priv);
+		priv->need_mac_restart = false;
 
 		/* Re-enable "bad" interrupts */
 		iowrite32(FTGMAC100_INT_BAD,
-- 
2.30.1



