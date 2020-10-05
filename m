Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF8A283B22
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgJEPjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:39:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727634AbgJEP3m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:29:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3731207BC;
        Mon,  5 Oct 2020 15:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911781;
        bh=Ru7/vpo8GarfJRXJYCkNWopOS6nnw3qYPy3r2b2lhbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yw4+Tz0nCsKSKkPvxVgWYIDEX2gG5h8SJ2j11R3If/cqN6jRCYS5Aijaqos6Hi836
         tLMaOMynAFf42MWIIk394DWjki0P9T8qPXcoKoY8bZ0+56xLeHCCH9P81OwkCjEHsP
         F/9pVX7CaO6FLyKohDb3QIV8Zwi5qX4hHTqFDses=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Andrew Lunn <andrew@lunn.ch>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 35/57] pinctrl: mvebu: Fix i2c sda definition for 98DX3236
Date:   Mon,  5 Oct 2020 17:26:47 +0200
Message-Id: <20201005142111.499044512@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
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
index a767a05fa3a0d..48e2a6c56a83b 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
@@ -414,7 +414,7 @@ static struct mvebu_mpp_mode mv98dx3236_mpp_modes[] = {
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



