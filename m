Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6AACA968
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392589AbfJCQmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:42:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392363AbfJCQmJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:42:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 886232086A;
        Thu,  3 Oct 2019 16:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120928;
        bh=BhJwqG++4J9wEY2L8CXnAV4u3Z2d3St1190j766FZvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tIg6TQLbuZd/7/14dTryaTpWT6OBGUR9Kwz07cYqIJrLSe64XPBSbc97k/BHI7WHr
         O+e82PmdSGM4sGxhY/xLToCL3GzMNVOmNeD7L0d8JZaUys4fc+3WwhJJTtuIfYKHmb
         OVi28X+VA3gvFNkqgu3QcijjkVsNBbdJMZ88gbZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 090/344] media: staging: tegra-vde: Fix build error
Date:   Thu,  3 Oct 2019 17:50:55 +0200
Message-Id: <20191003154549.062096303@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 6b2265975239ab655069d796b822835a593e1cc7 ]

If IOMMU_SUPPORT is not set, and COMPILE_TEST is y,
IOMMU_IOVA may be set to m. So building will fails:

drivers/staging/media/tegra-vde/iommu.o: In function `tegra_vde_iommu_map':
iommu.c:(.text+0x41): undefined reference to `alloc_iova'
iommu.c:(.text+0x56): undefined reference to `__free_iova'

Select IOMMU_IOVA while COMPILE_TEST is set to fix this.

Reported-by: Hulk Robot <hulkci@huawei.com>
Suggested-by: Dmitry Osipenko <digetx@gmail.com>
Fixes: b301f8de1925 ("media: staging: media: tegra-vde: Add IOMMU support")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/tegra-vde/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/tegra-vde/Kconfig b/drivers/staging/media/tegra-vde/Kconfig
index 2e7f644ae5911..ba49ea50b8c0b 100644
--- a/drivers/staging/media/tegra-vde/Kconfig
+++ b/drivers/staging/media/tegra-vde/Kconfig
@@ -3,7 +3,7 @@ config TEGRA_VDE
 	tristate "NVIDIA Tegra Video Decoder Engine driver"
 	depends on ARCH_TEGRA || COMPILE_TEST
 	select DMA_SHARED_BUFFER
-	select IOMMU_IOVA if IOMMU_SUPPORT
+	select IOMMU_IOVA if (IOMMU_SUPPORT || COMPILE_TEST)
 	select SRAM
 	help
 	    Say Y here to enable support for the NVIDIA Tegra video decoder
-- 
2.20.1



