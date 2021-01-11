Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAC92F16A7
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730556AbhAKNzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:55:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729106AbhAKNHV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:07:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB6D4227C3;
        Mon, 11 Jan 2021 13:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370426;
        bh=rKXza5oLpiNJOwF26kjCTzS1RfXAa6fmSg4lfwpQjeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qa0NpytAtVZUVVNoOjA/BPVqBPaRkv+O2+BblXZ3ASrTn+CajGbW+nWDBD9E7aCf9
         1SFzyOcVtswCBfy6qcE1YCr0DlHBSmSt9G2bluVqa4/p0Sfvuj3BBGcCCzJ0m/4J+Q
         /CLZ8aLu23dj8JfUm+Wv61WZJ5Z84RH5+wnRHKqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 17/77] net: mvpp2: Fix GoP port 3 Networking Complex Control configurations
Date:   Mon, 11 Jan 2021 14:01:26 +0100
Message-Id: <20210111130037.245720640@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
References: <20210111130036.414620026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

[ Upstream commit 2575bc1aa9d52a62342b57a0b7d0a12146cf6aed ]

During GoP port 2 Networking Complex Control mode of operation configurations,
also GoP port 3 mode of operation was wrongly set.
Patch removes these configurations.

Fixes: f84bf386f395 ("net: mvpp2: initialize the GoP")
Acked-by: Marcin Wojtas <mw@semihalf.com>
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
Link: https://lore.kernel.org/r/1608462149-1702-1-git-send-email-stefanc@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -954,7 +954,7 @@ static void mvpp22_gop_init_rgmii(struct
 
 	regmap_read(priv->sysctrl_base, GENCONF_CTRL0, &val);
 	if (port->gop_id == 2)
-		val |= GENCONF_CTRL0_PORT0_RGMII | GENCONF_CTRL0_PORT1_RGMII;
+		val |= GENCONF_CTRL0_PORT0_RGMII;
 	else if (port->gop_id == 3)
 		val |= GENCONF_CTRL0_PORT1_RGMII_MII;
 	regmap_write(priv->sysctrl_base, GENCONF_CTRL0, val);


