Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F8D29C1EF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762204AbgJ0Ol2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:41:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761794AbgJ0OkR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:40:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B429206B2;
        Tue, 27 Oct 2020 14:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809617;
        bh=tkB/yXFVPby4N0FmtBJI2vukNkHoKcMz+QpOnze/WcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdAZZ3V0fyOgzz147ZGCgUmVlGfsRjBRzuv5VnjzOIx3ZG/rX09CRkuDAhO9noiYP
         JL8JdGwKZ9VdzWMAIwr4IOh+TasW9ZgeP/i3CcPSIE11rK5PMSPq+hhbkPIVSv+xTe
         WAelnZs/m4+ybZ4o35U0AADWjpd+TKyxh+d7ok0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dirk Behme <dirk.behme@de.bosch.com>,
        Andy Lowe <andy_lowe@mentor.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 260/408] i2c: rcar: Auto select RESET_CONTROLLER
Date:   Tue, 27 Oct 2020 14:53:18 +0100
Message-Id: <20201027135507.105270046@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
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
index 146ce40d8e0aa..2d08a8719506c 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -1162,6 +1162,7 @@ config I2C_RCAR
 	tristate "Renesas R-Car I2C Controller"
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select I2C_SLAVE
+	select RESET_CONTROLLER if ARCH_RCAR_GEN3
 	help
 	  If you say yes to this option, support will be included for the
 	  R-Car I2C controller.
-- 
2.25.1



