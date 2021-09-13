Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5835E409236
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344518AbhIMOJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:09:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343997AbhIMOHJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:07:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4B0C61A81;
        Mon, 13 Sep 2021 13:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540421;
        bh=CTiolkTYws3gyQMM4I7/ByBwnzaC+QtGEsiS/SDkDMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gclaZhoFBAwtM/4Soav96VU1lJI33BHRKBOYv9ZWcw9YKErcsEu7bYUaa0YJrpurO
         bi5dFzLDR+PxmC8K+ikLLrdogkgzMZzMFL/HGEvez5vj7WMs+AlpkdO1rfPUfXKJBl
         gOmSka+O1ya8UYxeWo6U5isH94oUwwQF2k6marwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 186/300] usb: gadget: udc: renesas_usb3: Fix soc_device_match() abuse
Date:   Mon, 13 Sep 2021 15:14:07 +0200
Message-Id: <20210913131115.675228650@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit cea45a3bd2dd4d9c35581328f571afd32b3c9f48 ]

soc_device_match() is intended as a last resort, to handle e.g. quirks
that cannot be handled by matching based on a compatible value.

As the device nodes for the Renesas USB 3.0 Peripheral Controller on
R-Car E3 and RZ/G2E do have SoC-specific compatible values, the latter
can and should be used to match against these devices.

This also fixes support for the USB 3.0 Peripheral Controller on the
R-Car E3e (R8A779M6) SoC, which is a different grading of the R-Car E3
(R8A77990) SoC, using the same SoC-specific compatible value.

Fixes: 30025efa8b5e75f5 ("usb: gadget: udc: renesas_usb3: add support for r8a77990")
Fixes: 546970fdab1da5fe ("usb: gadget: udc: renesas_usb3: add support for r8a774c0")
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/760981fb4cd110d7cbfc9dcffa365e7c8b25c6e5.1628696960.git.geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/renesas_usb3.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/gadget/udc/renesas_usb3.c b/drivers/usb/gadget/udc/renesas_usb3.c
index f1b35a39d1ba..57d417a7c3e0 100644
--- a/drivers/usb/gadget/udc/renesas_usb3.c
+++ b/drivers/usb/gadget/udc/renesas_usb3.c
@@ -2707,10 +2707,15 @@ static const struct renesas_usb3_priv renesas_usb3_priv_r8a77990 = {
 
 static const struct of_device_id usb3_of_match[] = {
 	{
+		.compatible = "renesas,r8a774c0-usb3-peri",
+		.data = &renesas_usb3_priv_r8a77990,
+	}, {
 		.compatible = "renesas,r8a7795-usb3-peri",
 		.data = &renesas_usb3_priv_gen3,
-	},
-	{
+	}, {
+		.compatible = "renesas,r8a77990-usb3-peri",
+		.data = &renesas_usb3_priv_r8a77990,
+	}, {
 		.compatible = "renesas,rcar-gen3-usb3-peri",
 		.data = &renesas_usb3_priv_gen3,
 	},
@@ -2719,18 +2724,10 @@ static const struct of_device_id usb3_of_match[] = {
 MODULE_DEVICE_TABLE(of, usb3_of_match);
 
 static const struct soc_device_attribute renesas_usb3_quirks_match[] = {
-	{
-		.soc_id = "r8a774c0",
-		.data = &renesas_usb3_priv_r8a77990,
-	},
 	{
 		.soc_id = "r8a7795", .revision = "ES1.*",
 		.data = &renesas_usb3_priv_r8a7795_es1,
 	},
-	{
-		.soc_id = "r8a77990",
-		.data = &renesas_usb3_priv_r8a77990,
-	},
 	{ /* sentinel */ },
 };
 
-- 
2.30.2



