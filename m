Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A196828B982
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731205AbgJLNii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:38:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730344AbgJLNhP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:37:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D35E22203;
        Mon, 12 Oct 2020 13:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509825;
        bh=xKk6bit8/CWUSLdRySUobvWcOHRDKm6MQA/zALFxt7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJAxLNaAVJDABMk8dLuQjq38IOqXOwyyhEedAlY1WFXoLdlV4ssd4IDyY76vzNodI
         CoDyoMKKZQob51SFF148MTU6IELrNIzc8EAdSEs7eWY0hhOt6DvkW2f1l6VGYS2Qgt
         K0nJPMHBIKbw7CyTWisFle2O3WARNMm6A7HzxxFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Andrew Lunn <andrew@lunn.ch>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 18/70] pinctrl: mvebu: Fix i2c sda definition for 98DX3236
Date:   Mon, 12 Oct 2020 15:26:34 +0200
Message-Id: <20201012132631.097694736@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132630.201442517@linuxfoundation.org>
References: <20201012132630.201442517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit 63c3212e7a37d68c89a13bdaebce869f4e064e67 ]

Per the datasheet the i2c functions use MPP_Sel=0x1. They are documented
as using MPP_Sel=0x4 as well but mixing 0x1 and 0x4 is clearly wrong. On
the board tested 0x4 resulted in a non-functioning i2c bus so stick with
0x1 which works.

Fixes: d7ae8f8dee7f ("pinctrl: mvebu: pinctrl driver for 98DX3236 SoC")
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20200907211712.9697-2-chris.packham@alliedtelesis.co.nz
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mvebu/pinctrl-armada-xp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-xp.c b/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
index b854f1ee5de57..4ef3618bca93f 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
@@ -418,7 +418,7 @@ static struct mvebu_mpp_mode mv98dx3236_mpp_modes[] = {
 		 MPP_VAR_FUNCTION(0x1, "i2c0", "sck",        V_98DX3236_PLUS)),
 	MPP_MODE(15,
 		 MPP_VAR_FUNCTION(0x0, "gpio", NULL,         V_98DX3236_PLUS),
-		 MPP_VAR_FUNCTION(0x4, "i2c0", "sda",        V_98DX3236_PLUS)),
+		 MPP_VAR_FUNCTION(0x1, "i2c0", "sda",        V_98DX3236_PLUS)),
 	MPP_MODE(16,
 		 MPP_VAR_FUNCTION(0x0, "gpo", NULL,          V_98DX3236_PLUS),
 		 MPP_VAR_FUNCTION(0x4, "dev", "oe",          V_98DX3236_PLUS)),
-- 
2.25.1



