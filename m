Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27D92C05A7
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729767AbgKWMYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:24:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:33742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729764AbgKWMYM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:24:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF9B620781;
        Mon, 23 Nov 2020 12:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134252;
        bh=8zuK+EHkzGHFrY+j+zhJ+t4rmPsnmwXt3TG/2VbhS7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gN+V4q0kKl6CXfulDnaTmrHJ2uuI+SNzthGHhpab6jFOetgJzKhojFJ2zyliBbn6L
         /2vUrr7q4pK461ebFqT5nzXwnwUDXhF+TVjViyKgH/W9NRY8UEX/UwukZV/TdBaNrx
         zlXCgQ+xYf1mqdc2Pp8F/BKqBhPCTiQ63ldGeato=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 18/38] ARM: dts: imx50-evk: Fix the chip select 1 IOMUX
Date:   Mon, 23 Nov 2020 13:22:04 +0100
Message-Id: <20201123121805.181129732@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121804.306030358@linuxfoundation.org>
References: <20201123121804.306030358@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 33d0d843872c5ddbe28457a92fc6f2487315fb9f ]

The SPI chip selects are represented as:

cs-gpios = <&gpio4 11 GPIO_ACTIVE_LOW>, <&gpio4 13 GPIO_ACTIVE_LOW>;

, which means that they are used in GPIO function instead of native
SPI mode.

Fix the IOMUX for the chip select 1 to use GPIO4_13 instead of
the native CSPI_SSI function.

Fixes: c605cbf5e135 ("ARM: dts: imx: add device tree support for Freescale imx50evk board")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx50-evk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx50-evk.dts b/arch/arm/boot/dts/imx50-evk.dts
index 27d763c7a307d..4dbd180e72ba6 100644
--- a/arch/arm/boot/dts/imx50-evk.dts
+++ b/arch/arm/boot/dts/imx50-evk.dts
@@ -66,7 +66,7 @@
 				MX50_PAD_CSPI_MISO__CSPI_MISO		0x00
 				MX50_PAD_CSPI_MOSI__CSPI_MOSI		0x00
 				MX50_PAD_CSPI_SS0__GPIO4_11		0xc4
-				MX50_PAD_ECSPI1_MOSI__CSPI_SS1		0xf4
+				MX50_PAD_ECSPI1_MOSI__GPIO4_13		0x84
 			>;
 		};
 
-- 
2.27.0



