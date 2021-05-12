Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEBA37CA70
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238443AbhELQaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236733AbhELQWz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:22:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC890619AE;
        Wed, 12 May 2021 15:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834432;
        bh=0mvuS6A5KBQSa4AckEgc5G1V/9ZhHey/tSU60/VdNLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=knSgG8Rzag6AXC6h1ERnHPmK+uTgtjkJosqVOXrR/7oKtqtPOPDcPi/dJv15ct8Oz
         0ky6xzvFaz7YoXh9nN/58mnPMaOxfNGGJD4nPz07grZq3nq7AcfQJGFjal76LQ1KI2
         WW4ozs7TU1ULpJLm48kM2tL3N+4XdqlZN4B4XW+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 541/601] net: davinci_emac: Fix incorrect masking of tx and rx error channel
Date:   Wed, 12 May 2021 16:50:18 +0200
Message-Id: <20210512144845.676196176@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit d83b8aa5207d81f9f6daec9888390f079cc5db3f ]

The bit-masks used for the TXERRCH and RXERRCH (tx and rx error channels)
are incorrect and always lead to a zero result. The mask values are
currently the incorrect post-right shifted values, fix this by setting
them to the currect values.

(I double checked these against the TMS320TCI6482 data sheet, section
5.30, page 127 to ensure I had the correct mask values for the TXERRCH
and RXERRCH fields in the MACSTATUS register).

Addresses-Coverity: ("Operands don't affect result")
Fixes: a6286ee630f6 ("net: Add TI DaVinci EMAC driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/davinci_emac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index c7031e1960d4..03055c96f076 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -169,11 +169,11 @@ static const char emac_version_string[] = "TI DaVinci EMAC Linux v6.1";
 /* EMAC mac_status register */
 #define EMAC_MACSTATUS_TXERRCODE_MASK	(0xF00000)
 #define EMAC_MACSTATUS_TXERRCODE_SHIFT	(20)
-#define EMAC_MACSTATUS_TXERRCH_MASK	(0x7)
+#define EMAC_MACSTATUS_TXERRCH_MASK	(0x70000)
 #define EMAC_MACSTATUS_TXERRCH_SHIFT	(16)
 #define EMAC_MACSTATUS_RXERRCODE_MASK	(0xF000)
 #define EMAC_MACSTATUS_RXERRCODE_SHIFT	(12)
-#define EMAC_MACSTATUS_RXERRCH_MASK	(0x7)
+#define EMAC_MACSTATUS_RXERRCH_MASK	(0x700)
 #define EMAC_MACSTATUS_RXERRCH_SHIFT	(8)
 
 /* EMAC RX register masks */
-- 
2.30.2



