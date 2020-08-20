Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1211F24B293
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgHTJdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:33:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727034AbgHTJbc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:31:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE22A22B49;
        Thu, 20 Aug 2020 09:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915892;
        bh=v07Xbj/HWPbOQkiZOboDC1XwxejTbPaUZpj8iwaDbXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P2vTAywdSM+SObblT6u8PDDFO/sVIYOEGSZ2AUeLrToXZjmd3T52yfmNptKt+wNNL
         uPBTdLmQWCw5Cuk5ChfQg20hxitb/BNb8hGPYlx1Am9t0hGgnYRkgTLr7VTd2HbH61
         e+7v9vuiswdV7uB4KHD2HoezHnuMPWb6Y2fIEmvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 172/232] i2c: rcar: avoid race when unregistering slave
Date:   Thu, 20 Aug 2020 11:20:23 +0200
Message-Id: <20200820091621.150029215@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit c7c9e914f9a0478fba4dc6f227cfd69cf84a4063 ]

Due to the lockless design of the driver, it is theoretically possible
to access a NULL pointer, if a slave interrupt was running while we were
unregistering the slave. To make this rock solid, disable the interrupt
for a short time while we are clearing the interrupt_enable register.
This patch is purely based on code inspection. The OOPS is super-hard to
trigger because clearing SAR (the address) makes interrupts even more
unlikely to happen as well. While here, reinit SCR to SDBS because this
bit should always be set according to documentation. There is no effect,
though, because the interface is disabled.

Fixes: 7b814d852af6 ("i2c: rcar: avoid race when unregistering slave client")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-rcar.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index 76c615be5acae..9e883474db8ce 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -866,12 +866,14 @@ static int rcar_unreg_slave(struct i2c_client *slave)
 
 	WARN_ON(!priv->slave);
 
-	/* disable irqs and ensure none is running before clearing ptr */
+	/* ensure no irq is running before clearing ptr */
+	disable_irq(priv->irq);
 	rcar_i2c_write(priv, ICSIER, 0);
-	rcar_i2c_write(priv, ICSCR, 0);
+	rcar_i2c_write(priv, ICSSR, 0);
+	enable_irq(priv->irq);
+	rcar_i2c_write(priv, ICSCR, SDBS);
 	rcar_i2c_write(priv, ICSAR, 0); /* Gen2: must be 0 if not using slave */
 
-	synchronize_irq(priv->irq);
 	priv->slave = NULL;
 
 	pm_runtime_put(rcar_i2c_priv_to_dev(priv));
-- 
2.25.1



