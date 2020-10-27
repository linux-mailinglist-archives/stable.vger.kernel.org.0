Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B971E29B6DB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368751AbgJ0P1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:27:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797490AbgJ0PXv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:23:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D89C620657;
        Tue, 27 Oct 2020 15:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812231;
        bh=USYYtO6VgYTrA5w3ydkn75nox/VqrlDSuPJidgcGUgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yPmB9PH8bUEfMR0BHDmie4nxzmReuUn5xmxKwt8DD6nRBBXcswVWAMYQxXSvurTPL
         o9bKV+8nt43CNmN9TOBmc8m/lkNAvLZHmZuFKp1G9KCHcUBWl0gqUO5wS647t7ZcS1
         s6833wKCTDJzdflNiY1xIUunB1zVkTMSQLYIOvX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 136/757] media: omap3isp: Fix memleak in isp_probe
Date:   Tue, 27 Oct 2020 14:46:26 +0100
Message-Id: <20201027135456.977462862@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index b91e472ee764e..de066757726de 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2328,8 +2328,10 @@ static int isp_probe(struct platform_device *pdev)
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



