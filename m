Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8706DC82
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388601AbfGSEPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:15:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387852AbfGSEPB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:15:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B97CB21873;
        Fri, 19 Jul 2019 04:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509701;
        bh=w/qHg7Pkk5udeRUUKK36ENgx2X/clcTCCJhpT8cuFFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aMAGYNFm3blUpziMg4siwZBhxQ4UWFwoNf4YwJydq6hBfb57NqE/mYPxP8DN7PdJU
         rUy+H/L7mr9SiOQ3UHjcYM/vqcnkChem3aC5VCdn1m9J54PXw8vttWXbCfLrg9ZjXx
         aNiRDWNAG/GngnNVFiHUXr5NS/kX5jh31tmYA/n4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robert Hancock <hancock@sedsystems.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 20/35] mfd: core: Set fwnode for created devices
Date:   Fri, 19 Jul 2019 00:14:08 -0400
Message-Id: <20190719041423.19322-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719041423.19322-1-sashal@kernel.org>
References: <20190719041423.19322-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <hancock@sedsystems.ca>

[ Upstream commit c176c6d7e932662668bcaec2d763657096589d85 ]

The logic for setting the of_node on devices created by mfd did not set
the fwnode pointer to match, which caused fwnode-based APIs to
malfunction on these devices since the fwnode pointer was null. Fix
this.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/mfd-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 022c9374ce8b..215bb5eeb5ac 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -178,6 +178,7 @@ static int mfd_add_device(struct device *parent, int id,
 		for_each_child_of_node(parent->of_node, np) {
 			if (of_device_is_compatible(np, cell->of_compatible)) {
 				pdev->dev.of_node = np;
+				pdev->dev.fwnode = &np->fwnode;
 				break;
 			}
 		}
-- 
2.20.1

