Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE0B4124B1
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349079AbhITSg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:36:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380612AbhITSee (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:34:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB00161452;
        Mon, 20 Sep 2021 17:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158929;
        bh=wqxoSHrYnFKb1yKlRlNEg66y5BaK5jtnPVEV/r+uDP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2svgqj6sg8Y9ofH1VlUondVUnVf6QkscS9hXlOVlbrQv29IGvUOyiBbWtxrgk++23
         phIurhrXsymIISWhT/OCfhjvVf6Crv8AC6bki1EXgcnVkfSg9zozKiO05p9pPuy+mA
         ZJqZpR0hsdjqUoJjxLa5BMlQzvAlp4WA0pyzo3XU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Turischev <denis@compulab.co.il>,
        Randy Dunlap <rdunlap@infradead.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/122] mfd: lpc_sch: Rename GPIOBASE to prevent build error
Date:   Mon, 20 Sep 2021 18:44:52 +0200
Message-Id: <20210920163919.747056318@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit cdff1eda69326fb46de10c5454212b3efcf4bb41 ]

One MIPS platform (mach-rc32434) defines GPIOBASE. This macro
conflicts with one of the same name in lpc_sch.c. Rename the latter one
to prevent the build error.

../drivers/mfd/lpc_sch.c:25: error: "GPIOBASE" redefined [-Werror]
   25 | #define GPIOBASE        0x44
../arch/mips/include/asm/mach-rc32434/rb.h:32: note: this is the location of the previous definition
   32 | #define GPIOBASE        0x050000

Cc: Denis Turischev <denis@compulab.co.il>
Fixes: e82c60ae7d3a ("mfd: Introduce lpc_sch for Intel SCH LPC bridge")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/lpc_sch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
index 428a526cbe86..9ab9adce06fd 100644
--- a/drivers/mfd/lpc_sch.c
+++ b/drivers/mfd/lpc_sch.c
@@ -22,7 +22,7 @@
 #define SMBASE		0x40
 #define SMBUS_IO_SIZE	64
 
-#define GPIOBASE	0x44
+#define GPIO_BASE	0x44
 #define GPIO_IO_SIZE	64
 #define GPIO_IO_SIZE_CENTERTON	128
 
@@ -145,7 +145,7 @@ static int lpc_sch_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if (ret == 0)
 		cells++;
 
-	ret = lpc_sch_populate_cell(dev, GPIOBASE, "sch_gpio",
+	ret = lpc_sch_populate_cell(dev, GPIO_BASE, "sch_gpio",
 				    info->io_size_gpio,
 				    id->device, &lpc_sch_cells[cells]);
 	if (ret < 0)
-- 
2.30.2



