Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5649A2E41D5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441066AbgL1PNV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:13:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:41446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437081AbgL1OHB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:07:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F9D2207B6;
        Mon, 28 Dec 2020 14:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164381;
        bh=B6AmGU8UwpVL099WvkiOry3EuTh6jwR4sRGWPpzWN7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zqcq13ZsTNiIIgv0Lg3Zc9XQHmBMldj178kk/Qgwy3SWvCggndHqpNajlGWc4XyDh
         ETzDKhn7OZlUhvVpKXQDJnnGRFrI/O36R0TuRpzJRIY03XmDbGnTo3pjpgv0BhnKky
         uRKmiySQ5w5tewzJY/5BSN6oL289Lz6mQC4bWgkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Walle <michael@walle.cc>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 161/717] mfd: MFD_SL28CPLD should depend on ARCH_LAYERSCAPE
Date:   Mon, 28 Dec 2020 13:42:39 +0100
Message-Id: <20201228125028.670699008@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit de1292817cf736c04fab31903a6aa9d9ffe60b79 ]

Currently the Kontron sl28cpld Board Management Controller is found only
on Kontron boards equipped with a Freescale Layerscape SoC.  Hence add a
dependency on ARCH_LAYERSCAPE, to prevent asking the user about a driver
for this controller when configuring a kernel without Layerscape support.

Fixes: a538ad229bbee4f8 ("mfd: simple-mfd-i2c: Add sl28cpld support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Michael Walle <michael@walle.cc>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 8b99a13669bfc..4789507f325b8 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1189,6 +1189,7 @@ config MFD_SIMPLE_MFD_I2C
 config MFD_SL28CPLD
 	tristate "Kontron sl28cpld Board Management Controller"
 	depends on I2C
+	depends on ARCH_LAYERSCAPE || COMPILE_TEST
 	select MFD_SIMPLE_MFD_I2C
 	help
 	  Say yes here to enable support for the Kontron sl28cpld board
-- 
2.27.0



