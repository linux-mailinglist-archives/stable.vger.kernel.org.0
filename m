Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6C2B148408
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388621AbgAXLkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:40:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391244AbgAXLWq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:22:46 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E484F20704;
        Fri, 24 Jan 2020 11:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864965;
        bh=8grAFjD+86gBdd7bfi1B44QwdNP+iPzlA2hT81xdcCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0AJsG8u3EqjMY+Uif5lfTr1wl4HpEIShACgqcdTgUXn8owGzjXuBfcAodzMeIjmlf
         Gw/5ZgjqeaCqtxS6oRRx+rm8l/K4Vvb8iZTI2ayNMch1UX/JAnPx2Kcri7jaE2w4O/
         GkDmTwR01HatY+fOiT0oSX737fbvrfyKRIa3EN18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 402/639] media: Staging: media: Release the correct resource in an error handling path
Date:   Fri, 24 Jan 2020 10:29:32 +0100
Message-Id: <20200124093137.297261658@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 95942768639cd..7bf2648affc0c 100644
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



