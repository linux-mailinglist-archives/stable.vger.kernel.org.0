Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9678D167792
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbgBUHxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:53:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:52328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730174AbgBUHxx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:53:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E85C620801;
        Fri, 21 Feb 2020 07:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271633;
        bh=2wsmw7LgUVLxcb60T5P9mFsAuefCeFVQD3JLWpvFv74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=icMVpQ19TbfQsOKGhARVnj9BtDB7CmsRPi41xnZK/Y8UcLATw5M/FgJxmPOZfngiF
         PC1+vxvP/fSedn3Rs4ZB2FoJlt3mJomGZMUJbx/HS0nvdDcDhyxKUE/E8lZrPgByPG
         cK3TCT1vWnSuBbrGUxhTJe91VCzA+otMbMKZUbeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 192/399] PM / devfreq: rk3399_dmc: Add COMPILE_TEST and HAVE_ARM_SMCCC dependency
Date:   Fri, 21 Feb 2020 08:38:37 +0100
Message-Id: <20200221072421.485975199@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chanwoo Choi <cw00.choi@samsung.com>

[ Upstream commit eff5d31f7407fa9d31fb840106f1593399457298 ]

To build test, add COMPILE_TEST depedency to both ARM_RK3399_DMC_DEVFREQ
and DEVFREQ_EVENT_ROCKCHIP_DFI configuration. And ARM_RK3399_DMC_DEVFREQ
used the SMCCC interface so that add HAVE_ARM_SMCCC dependency to prevent
the build break.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/Kconfig       | 3 ++-
 drivers/devfreq/event/Kconfig | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index 35535833b6f78..c7804635e89ea 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -115,7 +115,8 @@ config ARM_TEGRA20_DEVFREQ
 
 config ARM_RK3399_DMC_DEVFREQ
 	tristate "ARM RK3399 DMC DEVFREQ Driver"
-	depends on ARCH_ROCKCHIP
+	depends on (ARCH_ROCKCHIP && HAVE_ARM_SMCCC) || \
+		(COMPILE_TEST && HAVE_ARM_SMCCC)
 	select DEVFREQ_EVENT_ROCKCHIP_DFI
 	select DEVFREQ_GOV_SIMPLE_ONDEMAND
 	select PM_DEVFREQ_EVENT
diff --git a/drivers/devfreq/event/Kconfig b/drivers/devfreq/event/Kconfig
index cef2cf5347ca7..a53e0a6ffdfeb 100644
--- a/drivers/devfreq/event/Kconfig
+++ b/drivers/devfreq/event/Kconfig
@@ -34,7 +34,7 @@ config DEVFREQ_EVENT_EXYNOS_PPMU
 
 config DEVFREQ_EVENT_ROCKCHIP_DFI
 	tristate "ROCKCHIP DFI DEVFREQ event Driver"
-	depends on ARCH_ROCKCHIP
+	depends on ARCH_ROCKCHIP || COMPILE_TEST
 	help
 	  This add the devfreq-event driver for Rockchip SoC. It provides DFI
 	  (DDR Monitor Module) driver to count ddr load.
-- 
2.20.1



