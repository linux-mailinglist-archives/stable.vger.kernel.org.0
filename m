Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B8A3CDBC2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238620AbhGSOtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:49:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344216AbhGSOsm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:48:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0B5761406;
        Mon, 19 Jul 2021 15:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708432;
        bh=Ull+HBjYMAu3jf+YhHQ7f8LdoRH52QHKotZnOBasL6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VY3jqHYeA6RI4ZCgUOKVENxClwHAKTcjXX62QKKFn8AuRq3ze+Mq4J8C+lh/De/Zp
         m+HhxarXVzXYze7H3YIBKG6++QnMWF/irz/9KRUy5TI0j/cIIDBRp0XvsrWfK5NCK/
         D/6+3JzsJ/SrSmZi+Pb7rvHenKIaJ3A4VQe09mGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 308/315] memory: fsl_ifc: fix leak of IO mapping on probe failure
Date:   Mon, 19 Jul 2021 16:53:17 +0200
Message-Id: <20210719144953.607110056@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
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
index 1b182b117f9c..74bbbdc584f4 100644
--- a/drivers/memory/fsl_ifc.c
+++ b/drivers/memory/fsl_ifc.c
@@ -231,8 +231,7 @@ static int fsl_ifc_ctrl_probe(struct platform_device *dev)
 	fsl_ifc_ctrl_dev->gregs = of_iomap(dev->dev.of_node, 0);
 	if (!fsl_ifc_ctrl_dev->gregs) {
 		dev_err(&dev->dev, "failed to get memory region\n");
-		ret = -ENODEV;
-		goto err;
+		return -ENODEV;
 	}
 
 	if (of_property_read_bool(dev->dev.of_node, "little-endian")) {
@@ -308,6 +307,7 @@ err_irq:
 	free_irq(fsl_ifc_ctrl_dev->irq, fsl_ifc_ctrl_dev);
 	irq_dispose_mapping(fsl_ifc_ctrl_dev->irq);
 err:
+	iounmap(fsl_ifc_ctrl_dev->gregs);
 	return ret;
 }
 
-- 
2.30.2



