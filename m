Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703C229C451
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900957AbgJ0OUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:20:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758294AbgJ0OUE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:20:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B86B206D4;
        Tue, 27 Oct 2020 14:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808404;
        bh=/3DGhVJWA+qE/dFPc+EzjBK/VRNYI0Cyn4S2SSTLUAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZDvwHN1K+WkFuX5xulWSkKSUcT952IOjiC4xPxPzr24uNKWdZIJCVUSsFePA+0j8b
         I9u2BBjlmNwoa8xfoOgbac9ZQAMHyS6QgrHHhuHAsyxqlmBOIcQxRx+2Ajnc1SNM/R
         ue1S5kTFKHNkG6ajqyUcKowCBHYdi1xwN2tMefIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 048/264] media: omap3isp: Fix memleak in isp_probe
Date:   Tue, 27 Oct 2020 14:51:46 +0100
Message-Id: <20201027135432.935209253@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit d8fc21c17099635e8ebd986d042be65a6c6b5bd0 ]

When devm_ioremap_resource() fails, isp should be
freed just like other error paths in isp_probe.

Fixes: 8644cdf972dd6 ("[media] omap3isp: Replace many MMIO regions by two")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/omap3isp/isp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index addd03b517481..00e52f0b8251b 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2265,8 +2265,10 @@ static int isp_probe(struct platform_device *pdev)
 		mem = platform_get_resource(pdev, IORESOURCE_MEM, i);
 		isp->mmio_base[map_idx] =
 			devm_ioremap_resource(isp->dev, mem);
-		if (IS_ERR(isp->mmio_base[map_idx]))
-			return PTR_ERR(isp->mmio_base[map_idx]);
+		if (IS_ERR(isp->mmio_base[map_idx])) {
+			ret = PTR_ERR(isp->mmio_base[map_idx]);
+			goto error;
+		}
 	}
 
 	ret = isp_get_clocks(isp);
-- 
2.25.1



