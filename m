Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788C634C778
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbhC2IPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:15:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232815AbhC2ION (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:14:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C9F26195B;
        Mon, 29 Mar 2021 08:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005648;
        bh=XzGJoKTe3qRy50LBunVZGaZTaZmZzJkoHmuEAcS59IE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wKPLAKddvQc1fJ4d9LGyYrTOaShwiSC8KGNIoUZRaed+1Wpfssy/APh8tkJ0giQll
         dxK4CKjuxFgd2Nig3gGemzlsouQ9KFRM50j77T3tufHqHqHE0m4v0OoU5AITABBGW8
         ipw4B8XDZr7Ae+7reQJlabLKsRVCdDo1+d6iaV8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dylan Hung <dylan_hung@aspeedtech.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Joel Stanley <joel@jms.id.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/111] ftgmac100: Restart MAC HW once
Date:   Mon, 29 Mar 2021 09:58:14 +0200
Message-Id: <20210329075617.404515988@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
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
index 1aea22d2540f..4050f81f788c 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1307,6 +1307,7 @@ static int ftgmac100_poll(struct napi_struct *napi, int budget)
 	 */
 	if (unlikely(priv->need_mac_restart)) {
 		ftgmac100_start_hw(priv);
+		priv->need_mac_restart = false;
 
 		/* Re-enable "bad" interrupts */
 		iowrite32(FTGMAC100_INT_BAD,
-- 
2.30.1



