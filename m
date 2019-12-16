Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 298E81217A2
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbfLPSFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:05:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:44094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727459AbfLPSFe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:05:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4041820700;
        Mon, 16 Dec 2019 18:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519533;
        bh=i3SKMPZGX2kcISt1DIStMe09VN88qHoD/EJ9Rd1LWYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0fZxY1Udk1Ok8t2+zAlAxUxmH1b5J8CBHQf2NwR+Uzu/2Nz3gyYAHCxGz0SjRGvKy
         DcJcgXQpmIpaG8u2pGFftatr+Z5Pfli/elhiLu97KX5mX+TKE2+5QOkq0/SVD4usW6
         jU3Gm0PhxA2uJ+iIs78HfPbQIc1cccQAU3uR9KV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Merello <andrea.merello@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 106/140] iio: ad7949: kill pointless "readback"-handling code
Date:   Mon, 16 Dec 2019 18:49:34 +0100
Message-Id: <20191216174815.749524432@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Meng Li <Meng.Li@windriver.com>

[ Upstream commit c270bbf7bb9ddc4e2a51b3c56557c377c9ac79bc ]

The device could be configured to spit out also the configuration word
while reading the AD result value (in the same SPI xfer) - this is called
"readback" in the device datasheet.

The driver checks if readback is enabled and it eventually adjusts the SPI
xfer length and it applies proper shifts to still get the data, discarding
the configuration word.

The readback option is actually never enabled (the driver disables it), so
the said checks do not serve for any purpose.

Since enabling the readback option seems not to provide any advantage (the
driver entirely sets the configuration word without relying on any default
value), just kill the said, unused, code.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/altera_edac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/edac/altera_edac.c b/drivers/edac/altera_edac.c
index 56de378ad13dc..c9108906bcdc0 100644
--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -600,6 +600,7 @@ static const struct regmap_config s10_sdram_regmap_cfg = {
 	.reg_read = s10_protected_reg_read,
 	.reg_write = s10_protected_reg_write,
 	.use_single_rw = true,
+	.fast_io = true,
 };
 
 static int altr_s10_sdram_probe(struct platform_device *pdev)
-- 
2.20.1



