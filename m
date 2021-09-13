Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB615408DC6
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241041AbhIMN3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:29:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241808AbhIMNZx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:25:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62C8061216;
        Mon, 13 Sep 2021 13:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539342;
        bh=e+P4dl2KbpGl6pCNNnWX4EDdbrCKj/fdECJLg6JKtrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IATm8CauscwiFQ7jedAQ41tgkY+v71Q3m1rGnTqQoGXhVmTgJ9QZ+9eY344ku4rTG
         b4LGhPCBuIlUCFnA/CVC47jFAQOd8Dz4zgMJbPcCD3XKWZ7sWvGJaZdn6bS2UJ9zFR
         2zAR+1MSTW5g3szDsFN4bvXVCgGDSVlDW4U+6Uz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/144] usb: gadget: udc: renesas_usb3: Fix soc_device_match() abuse
Date:   Mon, 13 Sep 2021 15:14:32 +0200
Message-Id: <20210913131050.993957721@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
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
index 08a93cf68eff..b6653bc7acc2 100644
--- a/drivers/usb/gadget/udc/renesas_usb3.c
+++ b/drivers/usb/gadget/udc/renesas_usb3.c
@@ -2692,10 +2692,15 @@ static const struct renesas_usb3_priv renesas_usb3_priv_r8a77990 = {
 
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
@@ -2704,18 +2709,10 @@ static const struct of_device_id usb3_of_match[] = {
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



