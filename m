Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A88F712C91F
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733234AbfL2SA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:00:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:47790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732788AbfL2R5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:57:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B2EE22B48;
        Sun, 29 Dec 2019 17:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642239;
        bh=h4A/W2FN6BEUrDzG+BkEQyMdloFer4V9IMLr+UZSZDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xqF7BdxvtxgZFZi6Dmm2vjPWZVBuz7juN7p2ayMtW14jKy38ILppR3bEfZEOfwI8w
         SSsyHuD/rIcpsYay3Nlevhae+ihQnlkyXHdvThhogl770MkAz3QmxKmgiHOdpPXnh7
         3wPU7f+4w+bWfTn2AZQJR669yhIcPec+1zLnq8BY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Nyekjaer <sean@geanix.com>,
        Dan Murphy <dmurphy@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 373/434] can: m_can: tcan4x5x: add required delay after reset
Date:   Sun, 29 Dec 2019 18:27:06 +0100
Message-Id: <20191229172726.808908094@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Nyekjaer <sean@geanix.com>

commit 60552253e29c8860ee5bf1e6064591b0917c0394 upstream.

According to section "8.3.8 RST Pin" in the datasheet we are required to
wait >700us after the device is reset.

Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Acked-by: Dan Murphy <dmurphy@ti.com>
Cc: linux-stable <stable@vger.kernel.org> # >= v5.4
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/m_can/tcan4x5x.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -354,6 +354,8 @@ static int tcan4x5x_parse_config(struct
 	if (IS_ERR(tcan4x5x->reset_gpio))
 		tcan4x5x->reset_gpio = NULL;
 
+	usleep_range(700, 1000);
+
 	tcan4x5x->device_state_gpio = devm_gpiod_get_optional(cdev->dev,
 							      "device-state",
 							      GPIOD_IN);


