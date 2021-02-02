Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E07D30CC75
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238425AbhBBT5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:57:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:38944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232854AbhBBNul (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:50:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EFD264FB2;
        Tue,  2 Feb 2021 13:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273383;
        bh=BKSu0GJyVNt9cGG4Pa1OD2A5odWo5mwGd5EkwP2ZDLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBgrVSr6MbemoC4L0IOmGagZEKlvhktMNGaZ77WJuT/teHtOKfJUMh/01H+2lVQou
         Aq1Y6ECDuuRpeoq1nmvL6uWjTZmMh3LtlYM/qbDOWEztbgffRCoiDyRm2Qg1po27FD
         TJ08BjeegstwyIha0PTa18wDfAJBPuhhyD84krq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Anson Huang <Anson.Huang@nxp.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/142] firmware: imx: select SOC_BUS to fix firmware build
Date:   Tue,  2 Feb 2021 14:37:30 +0100
Message-Id: <20210202133001.297865483@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 82c082784e03a9a9c043345f9bc04bc8254cf6da ]

Fix build error in firmware/imx/ selecting SOC_BUS.

riscv32-linux-ld: drivers/firmware/imx/imx-scu-soc.o: in function `.L9':
imx-scu-soc.c:(.text+0x1b0): undefined reference to `soc_device_register'

Fixes: edbee095fafb ("firmware: imx: add SCU firmware driver support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Atish Patra <atish.patra@wdc.com>
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Anson Huang <Anson.Huang@nxp.com>
Cc: Daniel Baluta <daniel.baluta@nxp.com>
Reviewed-by: Dong Aisheng <aisheng.dong@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/imx/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/imx/Kconfig b/drivers/firmware/imx/Kconfig
index 1d2e5b85d7ca8..c027d99f2a599 100644
--- a/drivers/firmware/imx/Kconfig
+++ b/drivers/firmware/imx/Kconfig
@@ -13,6 +13,7 @@ config IMX_DSP
 config IMX_SCU
 	bool "IMX SCU Protocol driver"
 	depends on IMX_MBOX
+	select SOC_BUS
 	help
 	  The System Controller Firmware (SCFW) is a low-level system function
 	  which runs on a dedicated Cortex-M core to provide power, clock, and
-- 
2.27.0



