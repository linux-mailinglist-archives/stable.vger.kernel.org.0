Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABD929BE6B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1812913AbgJ0Qqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:46:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S368869AbgJ0PmP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:42:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05818223B0;
        Tue, 27 Oct 2020 15:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813333;
        bh=RMnaOxwYEr/eXmQc5u4PaNwMou8OoSdDCGRmA/BkiaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I+C+uNvxVUFRSj+vCdYlqx5AzEA6oqGwaUV/qQBqbvWuiRh/owD164jGfXSIGaBg6
         GzZRubas3rNp7XbHt/Lfxbk3WQwSMGrhLvZeKK2x0QPsGlXBC+C9cQGAn4PdOzt9tZ
         dqcPA8TJuxMm1EB+aB1wqPWBqvN9OArG2njBhXCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dirk Behme <dirk.behme@de.bosch.com>,
        Andy Lowe <andy_lowe@mentor.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 517/757] i2c: rcar: Auto select RESET_CONTROLLER
Date:   Tue, 27 Oct 2020 14:52:47 +0100
Message-Id: <20201027135514.729742788@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index 293e7a0760e77..7ccbfbcb02e9a 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -1181,6 +1181,7 @@ config I2C_RCAR
 	tristate "Renesas R-Car I2C Controller"
 	depends on ARCH_RENESAS || COMPILE_TEST
 	select I2C_SLAVE
+	select RESET_CONTROLLER if ARCH_RCAR_GEN3
 	help
 	  If you say yes to this option, support will be included for the
 	  R-Car I2C controller.
-- 
2.25.1



