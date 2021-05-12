Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E7B37CBE6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237863AbhELQix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:38:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239896AbhELQa3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:30:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCE7661AC0;
        Wed, 12 May 2021 15:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835037;
        bh=nijJKkOFtrIpFW9WD1G417CrwixcpBLkAhMUnVuFZr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VOHlqb0wrkBTG58OOjWkNEK1AFMFOoMRkEo9DRJ9WsNQHuIYKQDuR22djdtpIySKL
         XUcusxGyFelG61576tSgEpBRBX0K37H8bqMl4DCBXx7gXOztgkGzvFrCDi6KhOsU7K
         5DLrqJH2Ve4yhDJZsMUpPNXTWsPv01v1ahCWWJ74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 182/677] mtd: Handle possible -EPROBE_DEFER from parse_mtd_partitions()
Date:   Wed, 12 May 2021 16:43:48 +0200
Message-Id: <20210512144843.295955066@linuxfoundation.org>
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
index 2d6423d89a17..d97ddc65b5d4 100644
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



