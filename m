Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6072E37C4B7
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbhELPdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:33:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234279AbhELPY3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:24:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4A04619C5;
        Wed, 12 May 2021 15:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832205;
        bh=EbU8vG/bL1/P9oUMT1oMgo5/upTIpLYpXuIbEWm/PTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C5Pz6JKf5AQnv23rabI/2I5E9pUx8StbSOQ5kUPAAvvKsYZWiy5wI/9yy2kOEGDOa
         4Lh8EK5LZkj5mBa4j6HGiqJk6yC9MkREHLX8j1LBhsFgPa067XM9DZBd6cZ90fOdLb
         Ku8uSTkWkrlKki5Hon6DozzpPutePIEyMz9TFdec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 150/530] mtd: Handle possible -EPROBE_DEFER from parse_mtd_partitions()
Date:   Wed, 12 May 2021 16:44:20 +0200
Message-Id: <20210512144824.778555365@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 08608adb520e51403be7592c2214846fa440a23a ]

There are chances that the parse_mtd_partitions() function will return
-EPROBE_DEFER in mtd_device_parse_register(). This might happen when
the dependency is not available for the parser. For instance, on SDX55
the MTD_QCOMSMEM_PARTS parser depends on the QCOM_SMEM driver to parse
the partitions defined in the shared memory region. With the current
flow, the error returned from parse_mtd_partitions() will be discarded
in favor of trying to add the fallback partition.

This will prevent the driver to end up in probe deferred pool and the
partitions won't be parsed even after the QCOM_SMEM driver is available.

Fix this issue by bailing out of mtd_device_parse_register() when
-EPROBE_DEFER error is returned from parse_mtd_partitions() function and
propagate the error code to the driver core for probing later.

Fixes: 5ac67ce36cfe ("mtd: move code adding (registering) partitions to the parse_mtd_partitions()")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index b07cbb0661fb..1c8c40728678 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -820,6 +820,9 @@ int mtd_device_parse_register(struct mtd_info *mtd, const char * const *types,
 
 	/* Prefer parsed partitions over driver-provided fallback */
 	ret = parse_mtd_partitions(mtd, types, parser_data);
+	if (ret == -EPROBE_DEFER)
+		goto out;
+
 	if (ret > 0)
 		ret = 0;
 	else if (nr_parts)
-- 
2.30.2



