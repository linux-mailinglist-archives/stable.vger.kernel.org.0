Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599E3408FF0
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243536AbhIMNsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:48:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241330AbhIMNp7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:45:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3C6960F58;
        Mon, 13 Sep 2021 13:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539911;
        bh=DFE49qTJJc7/zYUceDgjbsIiJjTFyFIexMYeqH+w0ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tBK6/cD94QAkwam5+bPiNQxNn4Oc/q5BaXvWER2z4r8BTB/fyADJLyy4qIbbCDdeG
         HZMVNggMOhZhtns+pQ0X2XnRJ+67BRGQq/J8qoniPArmIDM+ksVMXYCXc3XSO/G3hm
         WyynmgR4SYuTnEhZnyB11fZNrr70AvtlAZGMB0Z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 168/236] clk: staging: correct reference to config IOMEM to config HAS_IOMEM
Date:   Mon, 13 Sep 2021 15:14:33 +0200
Message-Id: <20210913131106.085957687@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

[ Upstream commit cbfa6f33e3a685c329d78e06b0cf1dcb23c9d849 ]

Commit 0a0a66c984b3 ("clk: staging: Specify IOMEM dependency for Xilinx
Clocking Wizard driver") introduces a dependency on the non-existing config
IOMEM, which basically makes it impossible to include this driver into any
build. Fortunately, ./scripts/checkkconfigsymbols.py warns:

IOMEM
Referencing files: drivers/staging/clocking-wizard/Kconfig

The config for IOMEM support is called HAS_IOMEM. Correct this reference to
the intended config.

Fixes: 0a0a66c984b3 ("clk: staging: Specify IOMEM dependency for Xilinx Clocking Wizard driver")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Link: https://lore.kernel.org/r/20210817105404.13146-1-lukas.bulwahn@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/clocking-wizard/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/clocking-wizard/Kconfig b/drivers/staging/clocking-wizard/Kconfig
index 69cf51445f08..2324b5d73788 100644
--- a/drivers/staging/clocking-wizard/Kconfig
+++ b/drivers/staging/clocking-wizard/Kconfig
@@ -5,6 +5,6 @@
 
 config COMMON_CLK_XLNX_CLKWZRD
 	tristate "Xilinx Clocking Wizard"
-	depends on COMMON_CLK && OF && IOMEM
+	depends on COMMON_CLK && OF && HAS_IOMEM
 	help
 	  Support for the Xilinx Clocking Wizard IP core clock generator.
-- 
2.30.2



