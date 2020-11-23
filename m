Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51862C0719
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731941AbgKWMha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:37:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:49692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731933AbgKWMh1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:37:27 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE25520721;
        Mon, 23 Nov 2020 12:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135047;
        bh=lZvBpeRjlI/VW97KSB7IlHBYVy1l46kdMCQZECCsG1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KnCWxDFI/rYwj1N3CmS4PMgx3nriXPikDROS0YolJLwqkFV+GeuB1mUd9NH3kWjtJ
         8mcGKOVycdsfiX5m21JxbZsBmeIuuGoXq7pAwc0QQjRaF3cajvtD81IQCIuD10tIMU
         dWHK6rrKX5rPzNeLt3GM0dr6nt5m6Qo61OpPOcjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/158] can: tcan4x5x: tcan4x5x_can_remove(): fix order of deregistration
Date:   Mon, 23 Nov 2020 13:21:52 +0100
Message-Id: <20201123121823.987303756@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
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
index 11c223a534887..681bb861de05e 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -501,10 +501,10 @@ static int tcan4x5x_can_remove(struct spi_device *spi)
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



