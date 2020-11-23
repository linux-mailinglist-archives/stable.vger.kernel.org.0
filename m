Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8160C2C09AB
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387459AbgKWNK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:10:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:60928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732801AbgKWMrN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:47:13 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A332208C3;
        Mon, 23 Nov 2020 12:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135631;
        bh=VvvzoKZQg6mc598RuNe7MM/bEyvBiuL2yzO/Rrd8v0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d2Pj+pamhB79L4wzYXpgTTOHTlIpRNLReSTfzfE56asDKs17d/GuhloveoWtihiJz
         nUCEX8nC4jJgvBlRZxDws7XDpU/f6ZdW1KLN1Bu1o2Hohpv7617vlVHjTys0Hhd61p
         /7QiE/6OXei5Lyrt8yjB0vr+hm//xhnUqEIqHXao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 138/252] can: tcan4x5x: tcan4x5x_can_remove(): fix order of deregistration
Date:   Mon, 23 Nov 2020 13:21:28 +0100
Message-Id: <20201123121842.258610973@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit c81d0b6ca665477c761f227807010762630b089f ]

Change the order in tcan4x5x_can_remove() to be the exact inverse of
tcan4x5x_can_probe(). First m_can_class_unregister(), then power down the
device.

Fixes: 5443c226ba91 ("can: tcan4x5x: Add tcan4x5x driver to the kernel")
Cc: Dan Murphy <dmurphy@ti.com>
Link: http://lore.kernel.org/r/20201019154233.1262589-10-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/tcan4x5x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
index f058bd9104e99..4fdb7121403ab 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -527,10 +527,10 @@ static int tcan4x5x_can_remove(struct spi_device *spi)
 {
 	struct tcan4x5x_priv *priv = spi_get_drvdata(spi);
 
-	tcan4x5x_power_enable(priv->power, 0);
-
 	m_can_class_unregister(priv->mcan_dev);
 
+	tcan4x5x_power_enable(priv->power, 0);
+
 	return 0;
 }
 
-- 
2.27.0



