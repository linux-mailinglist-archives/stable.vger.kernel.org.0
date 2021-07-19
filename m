Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA073CE193
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349336AbhGSP0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:26:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348087AbhGSPYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3ACB61412;
        Mon, 19 Jul 2021 16:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710483;
        bh=OgCApF9g4DGMHKRlYaoHVBOoAFpWrb/y9h744UR1QNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CcebVu3txsqsyWVYWjkri8LR6Mljg7VH4DMgYvx9pbo+JnMMWorc1LV9qpDnDpkHK
         rffVRviD8HXR/y1RcMIwN2iHasn+mdXkGNHQVPjLg0Um6H5Wrj94MQMnkUabtEXcU7
         H/ZJVAiYCpgG71VFJhfLmiIk4jb68D+476fxsi0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 218/243] memory: fsl_ifc: fix leak of IO mapping on probe failure
Date:   Mon, 19 Jul 2021 16:54:07 +0200
Message-Id: <20210719144947.961556771@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit 3b132ab67fc7a358fff35e808fa65d4bea452521 ]

On probe error the driver should unmap the IO memory.  Smatch reports:

  drivers/memory/fsl_ifc.c:298 fsl_ifc_ctrl_probe() warn: 'fsl_ifc_ctrl_dev->gregs' not released on lines: 298.

Fixes: a20cbdeffce2 ("powerpc/fsl: Add support for Integrated Flash Controller")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20210527154322.81253-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/fsl_ifc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/memory/fsl_ifc.c b/drivers/memory/fsl_ifc.c
index 89f99b5b6450..a6324044a085 100644
--- a/drivers/memory/fsl_ifc.c
+++ b/drivers/memory/fsl_ifc.c
@@ -219,8 +219,7 @@ static int fsl_ifc_ctrl_probe(struct platform_device *dev)
 	fsl_ifc_ctrl_dev->gregs = of_iomap(dev->dev.of_node, 0);
 	if (!fsl_ifc_ctrl_dev->gregs) {
 		dev_err(&dev->dev, "failed to get memory region\n");
-		ret = -ENODEV;
-		goto err;
+		return -ENODEV;
 	}
 
 	if (of_property_read_bool(dev->dev.of_node, "little-endian")) {
@@ -295,6 +294,7 @@ err_irq:
 	free_irq(fsl_ifc_ctrl_dev->irq, fsl_ifc_ctrl_dev);
 	irq_dispose_mapping(fsl_ifc_ctrl_dev->irq);
 err:
+	iounmap(fsl_ifc_ctrl_dev->gregs);
 	return ret;
 }
 
-- 
2.30.2



