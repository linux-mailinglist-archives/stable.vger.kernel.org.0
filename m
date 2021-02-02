Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30B430C032
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbhBBNvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:51:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:40700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232773AbhBBNtb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:49:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D0CA64DBD;
        Tue,  2 Feb 2021 13:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273343;
        bh=dHIRzyTYQEdyjil9r2cQCzCqNZ++DVuy/9go6Ju0c88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4iLpdaO8qmGrv3p43mSlXzNliFzrHFPwVkK+WQS6Z/xOppVY5Ng4n2/i5aroswLG
         dbz0sl3Bmvn0V5wKZdWzuwszb0L3e4SHsuoH5tBCin82lCEjk6sVzFMNGCEPDmNNwn
         QQdUz4eCGhNofb/Anoa4IgP9O41++Cx9kQSZ6I/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.10 070/142] clk: imx: fix Kconfig warning for i.MX SCU clk
Date:   Tue,  2 Feb 2021 14:37:13 +0100
Message-Id: <20210202133000.613194739@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 73f6b7ed9835ad9f953aebd60dd720aabc487b81 upstream.

A previous patch introduced a harmless randconfig warning:

WARNING: unmet direct dependencies detected for MXC_CLK_SCU
  Depends on [n]: COMMON_CLK [=y] && ARCH_MXC [=n] && IMX_SCU [=y] && HAVE_ARM_SMCCC [=y]
  Selected by [m]:
  - CLK_IMX8QXP [=m] && COMMON_CLK [=y] && (ARCH_MXC [=n] && ARM64 [=y] || COMPILE_TEST [=y]) && IMX_SCU [=y] && HAVE_ARM_SMCCC [=y]

Since the symbol is now hidden and only selected by other symbols,
just remove the dependencies and require the other drivers to
get it right.

Fixes: 6247e31b7530 ("clk: imx: scu: fix MXC_CLK_SCU module build break")
Reported-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20201230155244.981757-1-arnd@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/imx/Kconfig |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/clk/imx/Kconfig
+++ b/drivers/clk/imx/Kconfig
@@ -6,8 +6,6 @@ config MXC_CLK
 
 config MXC_CLK_SCU
 	tristate
-	depends on ARCH_MXC
-	depends on IMX_SCU && HAVE_ARM_SMCCC
 
 config CLK_IMX1
 	def_bool SOC_IMX1


