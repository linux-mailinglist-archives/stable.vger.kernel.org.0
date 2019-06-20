Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4124D777
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbfFTSPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:15:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729567AbfFTSPU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:15:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E5412082C;
        Thu, 20 Jun 2019 18:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054519;
        bh=kf5RJKWA5oYAEDvJIm7IBbDOlA6XZbgSYxy+jrbqXkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ev/5+A6tdlUcLttKx4oMPtm5KcoWocf12B9FXrR0NYVTRnlpKYNE6hPSywq4fDLHc
         8r7F2Uura2O0VCJNloJkN0Rkngfb456ifRdFGBmtJbXBSSTHpiBblRzP2qQbvwzQMo
         CWTdsP+XeqfX+n6JlkI11M2hYALR/8ATBIqx7VRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 57/98] dpaa2-eth: Use PTR_ERR_OR_ZERO where appropriate
Date:   Thu, 20 Jun 2019 19:57:24 +0200
Message-Id: <20190620174351.929436971@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit bd8460fa4de46e9d6177af4fe33bf0763a7af4b7 ]

Use PTR_ERR_OR_ZERO instead of PTR_ERR in cases where
zero is a valid input. Reported by smatch.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 57cbaa38d247..df371c81a706 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1966,7 +1966,7 @@ alloc_channel(struct dpaa2_eth_priv *priv)
 
 	channel->dpcon = setup_dpcon(priv);
 	if (IS_ERR_OR_NULL(channel->dpcon)) {
-		err = PTR_ERR(channel->dpcon);
+		err = PTR_ERR_OR_ZERO(channel->dpcon);
 		goto err_setup;
 	}
 
@@ -2022,7 +2022,7 @@ static int setup_dpio(struct dpaa2_eth_priv *priv)
 		/* Try to allocate a channel */
 		channel = alloc_channel(priv);
 		if (IS_ERR_OR_NULL(channel)) {
-			err = PTR_ERR(channel);
+			err = PTR_ERR_OR_ZERO(channel);
 			if (err != -EPROBE_DEFER)
 				dev_info(dev,
 					 "No affine channel for cpu %d and above\n", i);
-- 
2.20.1



