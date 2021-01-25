Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92C330339A
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725792AbhAZFA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:00:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:38202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730962AbhAYSvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:51:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 938F62067B;
        Mon, 25 Jan 2021 18:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600617;
        bh=c2MuqezHcKNzAiM1yrZjSxkfci542e9Lcb3Mdhpv3OY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xyWEx5dhjucD0ew5zKK3yEoUtILxEaDHd3nzwRZWfuA8n3c+9+L0OLUWDPq6Bojik
         BtoVG3s9ni2tMENLh/vQ6OeF6yIzjRmyK9cZ1IBd8G5xVj22OwVrvNXUg4pOFjVnHW
         1nLIPT9Cly97Nfo2aGb0yJ5OhpaP8bWmSoMfkzhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/199] scsi: ufs: ufshcd-pltfrm depends on HAS_IOMEM
Date:   Mon, 25 Jan 2021 19:38:26 +0100
Message-Id: <20210125183219.812739460@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 5e6ddadf7637d336acaad1df1f3bcbb07f7d104d ]

Building ufshcd-pltfrm.c on arch/s390/ has a linker error since S390 does
not support IOMEM, so add a dependency on HAS_IOMEM.

s390-linux-ld: drivers/scsi/ufs/ufshcd-pltfrm.o: in function `ufshcd_pltfrm_init':
ufshcd-pltfrm.c:(.text+0x38e): undefined reference to `devm_platform_ioremap_resource'

where that devm_ function is inside an #ifdef CONFIG_HAS_IOMEM/#endif
block.

Link: lore.kernel.org/r/202101031125.ZEFCUiKi-lkp@intel.com
Link: https://lore.kernel.org/r/20210106040822.933-1-rdunlap@infradead.org
Fixes: 03b1781aa978 ("[SCSI] ufs: Add Platform glue driver for ufshcd")
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: linux-scsi@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index dcdb4eb1f90ba..c339517b7a094 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -72,6 +72,7 @@ config SCSI_UFS_DWC_TC_PCI
 config SCSI_UFSHCD_PLATFORM
 	tristate "Platform bus based UFS Controller support"
 	depends on SCSI_UFSHCD
+	depends on HAS_IOMEM
 	help
 	This selects the UFS host controller support. Select this if
 	you have an UFS controller on Platform bus.
-- 
2.27.0



