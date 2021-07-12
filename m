Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD343C5292
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242721AbhGLHrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:47:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345946AbhGLHpd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:45:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 638AF613DA;
        Mon, 12 Jul 2021 07:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075705;
        bh=9woMd5Q1TJ4Br7c6mG+NyaMf0CefBOFGC093iL4zKWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J77W0TK1yTZXpcjMzoIKx1G9Qp8Qd6B45tceqnMOlzleZYUkTNsdMjVDBhajL8OY8
         BJn/0EfOyANeGBUgKmgWaBwCv/glPTwVx8WscmJnhW+DzKL+b++WR2UDRHEgCS4pIb
         qthysTw6w1ACaecY6fPA1/qGmxiFv6P63DCufB3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 292/800] regulator: bd71815: add select to fix build
Date:   Mon, 12 Jul 2021 08:05:15 +0200
Message-Id: <20210712060956.092023386@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 5ba3747dbc9ade2d22a8f5bff3c928cb41d35030 ]

Mend the Kconfig for REGULATOR_BD71815 to prevent build errors:

riscv32-linux-ld: drivers/regulator/bd71815-regulator.o: in function `.L0 ':
regulator.c:289: undefined reference to `rohm_regulator_set_dvs_levels'
riscv32-linux-ld: drivers/regulator/bd71815-regulator.c:370: undefined reference to `rohm_regulator_set_dvs_levels'

Fixes: 1aad39001e85 ("regulator: Support ROHM BD71815 regulators")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Reviewed-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Link: https://lore.kernel.org/r/20210523001427.13500-1-rdunlap@infradead.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 3e7a38525cb3..fc9e8f589d16 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -207,6 +207,7 @@ config REGULATOR_BD70528
 config REGULATOR_BD71815
 	tristate "ROHM BD71815 Power Regulator"
 	depends on MFD_ROHM_BD71828
+	select REGULATOR_ROHM
 	help
 	  This driver supports voltage regulators on ROHM BD71815 PMIC.
 	  This will enable support for the software controllable buck
-- 
2.30.2



