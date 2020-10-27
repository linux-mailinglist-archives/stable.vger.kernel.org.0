Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6ECA29B0CF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901501AbgJ0OYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:24:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901492AbgJ0OX6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:23:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC52921D42;
        Tue, 27 Oct 2020 14:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808638;
        bh=ApMy92L19cwrfUNVjApTOSZu9vfjCfDlGpsRskCQwpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KDC0o11039CaS7UhsXhFEMvhc16nMTyew/bteW0yymc377AxXpaKxLHvoDKOoxB4Q
         qbCGYySi3KWEj4TeMZSAjIr8dhtghw8WMwlqQZMYOZ80OxgkAVmdYnBuYMr/wZ16cA
         c5YQUY4IzmOP3xKw018IKWTTjpJpunIBpScQ7XDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dirk Behme <dirk.behme@de.bosch.com>,
        Andy Lowe <andy_lowe@mentor.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 167/264] i2c: rcar: Auto select RESET_CONTROLLER
Date:   Tue, 27 Oct 2020 14:53:45 +0100
Message-Id: <20201027135438.532246203@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dirk Behme <dirk.behme@de.bosch.com>

[ Upstream commit 5b9bacf28a973a6b16510493416baeefa2c06289 ]

The i2c-rcar driver utilizes the Generic Reset Controller kernel
feature, so select the RESET_CONTROLLER option when the I2C_RCAR
option is selected with a Gen3 SoC.

Fixes: 2b16fd63059ab9 ("i2c: rcar: handle RXDMA HW behaviour on Gen3")
Signed-off-by: Dirk Behme <dirk.behme@de.bosch.com>
Signed-off-by: Andy Lowe <andy_lowe@mentor.com>
[erosca: Add "if ARCH_RCAR_GEN3" per Wolfram's request]
Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index ee6dd1b84fac8..017aec34a238d 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -1117,6 +1117,7 @@ config I2C_RCAR
 	tristate "Renesas R-Car I2C Controller"
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select I2C_SLAVE
+	select RESET_CONTROLLER if ARCH_RCAR_GEN3
 	help
 	  If you say yes to this option, support will be included for the
 	  R-Car I2C controller.
-- 
2.25.1



