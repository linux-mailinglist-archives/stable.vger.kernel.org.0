Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87291AA260
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898262AbgDOMyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:54:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897213AbgDOLhJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:37:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFDB62137B;
        Wed, 15 Apr 2020 11:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950629;
        bh=+e9qoTMeeUTLIN6LPfEmAaCFBw1h2Jg68LOFaxYeyAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dwS1YlAJT6gP/834hCev4b3oHXIEtBqS5DakUoJOPP5ASYfJzXACfmtDaCp7ps/m0
         XXoX/Ich1JI7wJ6Pwta+5VtRdTjC+Wf+dYmZfiVGwSW/8Fpa9PdSujWkatdBqMEGU6
         cXIecAuDmPuTORMuTGap12qcmi1kLlbS7UwXc990=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yuantian Tang <andy.tang@nxp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 120/129] thermal: qoriq: Fix a compiling issue
Date:   Wed, 15 Apr 2020 07:34:35 -0400
Message-Id: <20200415113445.11881-120-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuantian Tang <andy.tang@nxp.com>

[ Upstream commit cbe259fd80b7b02fba0dad79d8fdda8b70a8b963 ]

Qoriq thermal driver is used by both PowerPC and ARM architecture.
When built for PowerPC architecture, it reports error:
undefined reference to `.__devm_regmap_init_mmio_clk'
To fix it, select config REGMAP_MMIO.

Fixes: 4316237bd627 (thermal: qoriq: Convert driver to use regmap API)
Signed-off-by: Yuantian Tang <andy.tang@nxp.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20200303084641.35687-1-andy.tang@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 5a05db5438d60..5a0df0e54ce3e 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -265,6 +265,7 @@ config QORIQ_THERMAL
 	tristate "QorIQ Thermal Monitoring Unit"
 	depends on THERMAL_OF
 	depends on HAS_IOMEM
+	select REGMAP_MMIO
 	help
 	  Support for Thermal Monitoring Unit (TMU) found on QorIQ platforms.
 	  It supports one critical trip point and one passive trip point. The
-- 
2.20.1

