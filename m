Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A265613F50B
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389311AbgAPRIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:08:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:41198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389287AbgAPRIH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2C4F2467C;
        Thu, 16 Jan 2020 17:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194487;
        bh=mpGL97m6k814QXjnL2ki81L3W3OZi3I9xyhDVPmMuY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SbaaxJ3Q+Jzm0nOtelDq9GMhzjTvOZUJg06BXlhfCkgz/SStqP2ZKyJpwLWAn8Fav
         MTfyZ/F9b9zubMqRpCojSSbfCHd4JNESSd70INixALx1lr0j61Fydx4i77RNb2Pb/9
         idiy7S71KaIOgSioSGeq3LWK+U9KatuXU4zoLxYk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.19 387/671] media: Staging: media: Release the correct resource in an error handling path
Date:   Thu, 16 Jan 2020 12:00:25 -0500
Message-Id: <20200116170509.12787-124-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 3b6471c7becd06325eb5e701cc2602b2edbbc7b6 ]

'res' is reassigned several times in the function and if we 'goto
error_unmap', its value is not the returned value of 'request_mem_region()'
anymore.

Introduce a new 'struct resource *' variable (i.e. res2) to keep a pointer
to the right resource, if needed in the error handling path.

Fixes: 4b4eda001704 ("Staging: media: Unmap and release region obtained by ioremap_nocache")

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index 95942768639c..7bf2648affc0 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -1777,7 +1777,7 @@ vpfe_ipipe_init(struct vpfe_ipipe_device *ipipe, struct platform_device *pdev)
 	struct media_pad *pads = &ipipe->pads[0];
 	struct v4l2_subdev *sd = &ipipe->subdev;
 	struct media_entity *me = &sd->entity;
-	struct resource *res, *memres;
+	struct resource *res, *res2, *memres;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 4);
 	if (!res)
@@ -1791,11 +1791,11 @@ vpfe_ipipe_init(struct vpfe_ipipe_device *ipipe, struct platform_device *pdev)
 	if (!ipipe->base_addr)
 		goto error_release;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 6);
-	if (!res)
+	res2 = platform_get_resource(pdev, IORESOURCE_MEM, 6);
+	if (!res2)
 		goto error_unmap;
-	ipipe->isp5_base_addr = ioremap_nocache(res->start,
-						resource_size(res));
+	ipipe->isp5_base_addr = ioremap_nocache(res2->start,
+						resource_size(res2));
 	if (!ipipe->isp5_base_addr)
 		goto error_unmap;
 
-- 
2.20.1

