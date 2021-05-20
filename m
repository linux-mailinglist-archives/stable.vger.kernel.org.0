Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E7538A37D
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbhETJxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:53:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:54742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233977AbhETJvC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:51:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34BB0613F8;
        Thu, 20 May 2021 09:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503338;
        bh=6y9/q81XCOhwDxHVfQosFXIPrGvGte2RFvPw2fZ+69Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iIJoYBoRAD9fev0j5JuGFTSWEGoxwsSviATrUyKIK9NsId/SvnjwloKX/FEqTsf9K
         EAqbr0cDjz6XacU/Fy+awxnYilVB/YuSZzwikMKr4C5CPWjoEa6nhZb6oaR5Py9HsQ
         aaPfYzK5xpc/vZaixoNxLo93DO0bkSGr7qWC7KlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 175/425] mtd: Handle possible -EPROBE_DEFER from parse_mtd_partitions()
Date:   Thu, 20 May 2021 11:19:04 +0200
Message-Id: <20210520092137.189097413@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
index 97ac219c082e..a0b1a7814e2e 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -712,6 +712,9 @@ int mtd_device_parse_register(struct mtd_info *mtd, const char * const *types,
 
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



