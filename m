Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A63E2F16D1
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725843AbhAKN5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:57:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:54548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730405AbhAKNG5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:06:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47961227C3;
        Mon, 11 Jan 2021 13:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370376;
        bh=aVqh9PJ0QM0Lb8SGPiK90Bxi6gHdH5jX3dEMJxdfz3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KLEjoQ2BOgj7cOuYf5nKhDq20s5XTXoG7QUKPVqfKJX1fbkG1NAyYWmLA0P9zy+MK
         o/8FeuXUbwFUZ1PcXnelOt0KOfTgz86jZobeiRDv+rR4LWmeI4eujdvm6dLRMqXRPq
         gSDbhfuwGk70f0S5MHvKHTbW8ZvtTBYMCmxhPoVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 25/57] net: mvpp2: Fix GoP port 3 Networking Complex Control configurations
Date:   Mon, 11 Jan 2021 14:01:44 +0100
Message-Id: <20210111130034.935432182@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.715773309@linuxfoundation.org>
References: <20210111130033.715773309@linuxfoundation.org>
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
 drivers/net/ethernet/marvell/mvpp2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/mvpp2.c
+++ b/drivers/net/ethernet/marvell/mvpp2.c
@@ -4349,7 +4349,7 @@ static void mvpp22_gop_init_rgmii(struct
 
 	regmap_read(priv->sysctrl_base, GENCONF_CTRL0, &val);
 	if (port->gop_id == 2)
-		val |= GENCONF_CTRL0_PORT0_RGMII | GENCONF_CTRL0_PORT1_RGMII;
+		val |= GENCONF_CTRL0_PORT0_RGMII;
 	else if (port->gop_id == 3)
 		val |= GENCONF_CTRL0_PORT1_RGMII_MII;
 	regmap_write(priv->sysctrl_base, GENCONF_CTRL0, val);


