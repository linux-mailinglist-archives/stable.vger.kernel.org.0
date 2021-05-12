Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953B437CC49
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237955AbhELQn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:43:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243151AbhELQgy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:36:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E3C461CD1;
        Wed, 12 May 2021 16:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835267;
        bh=AyiY6eYCrjZnOf5dCrV6b3n1uTECJh8Bs5Nv1zQA1xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dMpCkk7c7kRgSplkAK6IpXPjj6+7UJqJyJDhS51Mkyy3aGprKBxmEQE2AHl4UOMIv
         PIex0wBBXnnFvRtcN7lEM06ttOK3K6hz1R368r43W79ONt/wYsWOiuVjH3TptR1jaM
         93cqo3a1jsy7JqZWfC7UV9OmbVUTd8yuJ+Ybeuh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 276/677] spi: fsl: add missing iounmap() on error in of_fsl_spi_probe()
Date:   Wed, 12 May 2021 16:45:22 +0200
Message-Id: <20210512144846.392847545@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 5fed9fe5b41aea58e5b32be506dc50c9ab9a0e4d ]

Add the missing iounmap() before return from of_fsl_spi_probe()
in the error handling case.

Fixes: 0f0581b24bd0 ("spi: fsl: Convert to use CS GPIO descriptors")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20210401140350.1677925-1-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-spi.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index e4a8d203f940..d0e5aa18b7ba 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -707,6 +707,11 @@ static int of_fsl_spi_probe(struct platform_device *ofdev)
 	struct resource mem;
 	int irq, type;
 	int ret;
+	bool spisel_boot = false;
+#if IS_ENABLED(CONFIG_FSL_SOC)
+	struct mpc8xxx_spi_probe_info *pinfo = NULL;
+#endif
+
 
 	ret = of_mpc8xxx_spi_probe(ofdev);
 	if (ret)
@@ -715,9 +720,8 @@ static int of_fsl_spi_probe(struct platform_device *ofdev)
 	type = fsl_spi_get_type(&ofdev->dev);
 	if (type == TYPE_FSL) {
 		struct fsl_spi_platform_data *pdata = dev_get_platdata(dev);
-		bool spisel_boot = false;
 #if IS_ENABLED(CONFIG_FSL_SOC)
-		struct mpc8xxx_spi_probe_info *pinfo = to_of_pinfo(pdata);
+		pinfo = to_of_pinfo(pdata);
 
 		spisel_boot = of_property_read_bool(np, "fsl,spisel_boot");
 		if (spisel_boot) {
@@ -746,15 +750,24 @@ static int of_fsl_spi_probe(struct platform_device *ofdev)
 
 	ret = of_address_to_resource(np, 0, &mem);
 	if (ret)
-		return ret;
+		goto unmap_out;
 
 	irq = platform_get_irq(ofdev, 0);
-	if (irq < 0)
-		return irq;
+	if (irq < 0) {
+		ret = irq;
+		goto unmap_out;
+	}
 
 	master = fsl_spi_probe(dev, &mem, irq);
 
 	return PTR_ERR_OR_ZERO(master);
+
+unmap_out:
+#if IS_ENABLED(CONFIG_FSL_SOC)
+	if (spisel_boot)
+		iounmap(pinfo->immr_spi_cs);
+#endif
+	return ret;
 }
 
 static int of_fsl_spi_remove(struct platform_device *ofdev)
-- 
2.30.2



