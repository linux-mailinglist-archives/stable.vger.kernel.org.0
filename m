Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C80450E26
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240720AbhKOSMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:12:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:46106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240089AbhKOSFf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A01F263381;
        Mon, 15 Nov 2021 17:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998130;
        bh=gMCh50sWMLo/CxMm0wPelRTH4Y6IT3WoMSbRub9uBII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZVDyMj6Bp0nwS4ADuiEWp7kVBJZ+DA9Enijux11UwAAYpBk/7zgfzhgoxBPU3PAcN
         KCbXC5XKgbllWGzSMQNCOaKQXyoHNGJ6YXNrbtepXcEK46LOXl43AWmTO2mgo371Mt
         7CFjViRcoAsq5Zx5+0Ytg/iHIf/cDa4dbjuvdZwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 365/575] spi: spi-rpc-if: Check return value of rpcif_sw_init()
Date:   Mon, 15 Nov 2021 18:01:30 +0100
Message-Id: <20211115165356.422113049@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 0b0a281ed7001d4c4f4c47bdc84680c4997761ca ]

rpcif_sw_init() can fail so make sure we check the return value
of it and on error exit rpcif_spi_probe() callback with error code.

Fixes: eb8d6d464a27 ("spi: add Renesas RPC-IF driver")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20211025205631.21151-4-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rpc-if.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-rpc-if.c b/drivers/spi/spi-rpc-if.c
index 3579675485a5e..727d7cf0a6ad8 100644
--- a/drivers/spi/spi-rpc-if.c
+++ b/drivers/spi/spi-rpc-if.c
@@ -139,7 +139,9 @@ static int rpcif_spi_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	rpc = spi_controller_get_devdata(ctlr);
-	rpcif_sw_init(rpc, parent);
+	error = rpcif_sw_init(rpc, parent);
+	if (error)
+		return error;
 
 	platform_set_drvdata(pdev, ctlr);
 
-- 
2.33.0



