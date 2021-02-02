Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7011130C0A4
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbhBBODY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:03:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:46434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233629AbhBBOCA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:02:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D596165001;
        Tue,  2 Feb 2021 13:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273645;
        bh=00QpJ8V590J1O437SS51qUxxE3E3mZ/6rGZoRnGAv1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UC05BQQgpfpq2gFFr/8CHlhU//57LEZz98LKDVdGYcoRKjyxEUhqyIKkKzepzIjOH
         aywB2lJyxxy1of5wLvSv2IzCRLE+OjvbSZiJEvi9/e1ucTb8DQiudRiXVZuQuxDxPL
         KavHBrJVEekp9XqqubuN+iJa7EpFXS+QuyNCGgx0=
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
Subject: [PATCH 5.4 39/61] firmware: imx: select SOC_BUS to fix firmware build
Date:   Tue,  2 Feb 2021 14:38:17 +0100
Message-Id: <20210202132948.121521908@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
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
index 0dbee32da4c6d..5d995fe64b5ca 100644
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



