Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA77419C70
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237967AbhI0R3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:29:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238103AbhI0R0E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:26:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D7C06137E;
        Mon, 27 Sep 2021 17:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762973;
        bh=sCNdgnn2lHGPitKk5CGjkivxHEtk7HRPTksGzUE3IY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uG/hmhBZTNkbbI0hZ6QfZ4/eWIDPI8ylu5O4dYP3/1cBw/OZXc6b6wjB75VOgxPK4
         lACArYUV+uCWmrdyQg7H+UEnDk2ElyOVA6K6cO5XXzmUpMEdWxgUBskesKx720fjUQ
         CT1BhAzAfPWooqKKQzlXyokg6yMtmG9CwlMBFcIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Nilsson <jesper.nilsson@axis.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 119/162] net: stmmac: allow CSR clock of 300MHz
Date:   Mon, 27 Sep 2021 19:02:45 +0200
Message-Id: <20210927170237.561331067@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesper Nilsson <jesper.nilsson@axis.com>

[ Upstream commit 08dad2f4d541fcfe5e7bfda72cc6314bbfd2802f ]

The Synopsys Ethernet IP uses the CSR clock as a base clock for MDC.
The divisor used is set in the MAC_MDIO_Address register field CR
(Clock Rate)

The divisor is there to change the CSR clock into a clock that falls
below the IEEE 802.3 specified max frequency of 2.5MHz.

If the CSR clock is 300MHz, the code falls back to using the reset
value in the MAC_MDIO_Address register, as described in the comment
above this code.

However, 300MHz is actually an allowed value and the proper divider
can be estimated quite easily (it's just 1Hz difference!)

A CSR frequency of 300MHz with the maximum clock rate value of 0x5
(STMMAC_CSR_250_300M, a divisor of 124) gives somewhere around
~2.42MHz which is below the IEEE 802.3 specified maximum.

For the ARTPEC-8 SoC, the CSR clock is this problematic 300MHz,
and unfortunately, the reset-value of the MAC_MDIO_Address CR field
is 0x0.

This leads to a clock rate of zero and a divisor of 42, and gives an
MDC frequency of ~7.14MHz.

Allow CSR clock of 300MHz by making the comparison inclusive.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 0dbd189c2721..2218bc3a624b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -309,7 +309,7 @@ static void stmmac_clk_csr_set(struct stmmac_priv *priv)
 			priv->clk_csr = STMMAC_CSR_100_150M;
 		else if ((clk_rate >= CSR_F_150M) && (clk_rate < CSR_F_250M))
 			priv->clk_csr = STMMAC_CSR_150_250M;
-		else if ((clk_rate >= CSR_F_250M) && (clk_rate < CSR_F_300M))
+		else if ((clk_rate >= CSR_F_250M) && (clk_rate <= CSR_F_300M))
 			priv->clk_csr = STMMAC_CSR_250_300M;
 	}
 
-- 
2.33.0



