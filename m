Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9C22E1648
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbgLWC7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:59:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:46280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728869AbgLWCUH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1298A2312E;
        Wed, 23 Dec 2020 02:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689991;
        bh=yKGVcUCNNGvX/3zRVNBC7SmxJeCVCipl3/dSmB4n+Co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GJSMbAwPU4rnmNgVjdhp/HxzibD1di4UJy3RP/acLIEvH9RH3Ta5ecbJXB+rtp2Hl
         j4sCBxyK4X+RsI5uL1O/z8iPFZVoI+/uBoUY1mg9dJ083szV9iTs5R4p3qsN9KCrLt
         Juo80uD1+DQ9VPGJIB6q0pl9zinXILDDZV1d2zUc6kZdPZJ2dGrqxCbzqP4/yp/KkN
         7s12spI43ftDXmRVG7NGspI++oDcm2EdrZ1K9VU35LslEl4ak7fyZXge2IRxSXbC/y
         dzxflVOFcwy+a5We7DiiCwl1gWSOgHjoERuan2Hl02TVvfNcSBeJYZ1gT3wZwZ1N7I
         SAnhlKTIJVkLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinh Nguyen <dinguyen@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 076/130] reset: socfpga: add error handling and release mem-region
Date:   Tue, 22 Dec 2020 21:17:19 -0500
Message-Id: <20201223021813.2791612-76-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

[ Upstream commit 0d625a167b169f0bfdfd2e4dc05b9c89b81efe98 ]

In case of an error, call release_mem_region when an error happens
during allocation of resources. Also add error handling for the case
that reset_controller_register fails.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/reset-socfpga.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/reset/reset-socfpga.c b/drivers/reset/reset-socfpga.c
index 96953992c2bb5..c78c7425195e2 100644
--- a/drivers/reset/reset-socfpga.c
+++ b/drivers/reset/reset-socfpga.c
@@ -45,7 +45,7 @@ static int a10_reset_init(struct device_node *np)
 	data->membase = ioremap(res.start, size);
 	if (!data->membase) {
 		ret = -ENOMEM;
-		goto err_alloc;
+		goto release_region;
 	}
 
 	if (of_property_read_u32(np, "altr,modrst-offset", &reg_offset))
@@ -60,7 +60,14 @@ static int a10_reset_init(struct device_node *np)
 	data->rcdev.of_node = np;
 	data->status_active_low = true;
 
-	return reset_controller_register(&data->rcdev);
+	ret = reset_controller_register(&data->rcdev);
+	if (ret)
+		pr_err("unable to register device\n");
+
+	return ret;
+
+release_region:
+	release_mem_region(res.start, size);
 
 err_alloc:
 	kfree(data);
-- 
2.27.0

