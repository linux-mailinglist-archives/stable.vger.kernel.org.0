Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76B2300642
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbhAVOy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:54:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:40006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728660AbhAVOYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:24:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CB0023A7C;
        Fri, 22 Jan 2021 14:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325144;
        bh=PJGI0RI9n0b8CV72l3ojUzF7izWhFbMYwKg1ZcKpiKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=og2nmvC5HmF3pUleTF3OmvKOtyES8HgL11IZpGNBnpuCVql+xS0dOQiU2rIHdrkj4
         kLnX7ES3DW91NQlxRYqYdx0u7KjCwV8U+m4xxmKoWCWEtTGk7bBNIj3zSrQIK2+KfD
         GPQVf3ZSj8E/aehuAnGDa5sfqAug8fSeUhRX4BMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 5.10 32/43] net: phy: smsc: fix clk error handling
Date:   Fri, 22 Jan 2021 15:12:48 +0100
Message-Id: <20210122135736.960032057@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit a18caa97b1bda0a3d126a7be165ddcfc56c2dde6 ]

Commit bedd8d78aba3 ("net: phy: smsc: LAN8710/20: add phy refclk in
support") added the phy clk support. The commit already checks if
clk_get_optional() throw an error but instead of returning the error it
ignores it.

Fixes: bedd8d78aba3 ("net: phy: smsc: LAN8710/20: add phy refclk in support")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20210111085932.28680-1-m.felsch@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/smsc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -284,7 +284,8 @@ static int smsc_phy_probe(struct phy_dev
 	/* Make clk optional to keep DTB backward compatibility. */
 	priv->refclk = clk_get_optional(dev, NULL);
 	if (IS_ERR(priv->refclk))
-		dev_err_probe(dev, PTR_ERR(priv->refclk), "Failed to request clock\n");
+		return dev_err_probe(dev, PTR_ERR(priv->refclk),
+				     "Failed to request clock\n");
 
 	ret = clk_prepare_enable(priv->refclk);
 	if (ret)


