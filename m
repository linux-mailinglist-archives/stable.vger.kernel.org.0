Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4766583B1
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234401AbiL1QuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234955AbiL1Qtu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:49:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29AD01F627
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:45:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8130B817AC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B606C433D2;
        Wed, 28 Dec 2022 16:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245904;
        bh=nvnkWN3BEN2p39C1nsMomAZZQoBsELZOox29IxQ0/Cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ub7c/uvQACu4JnCncZudOnyB+pFzH6RkNKjRJR7SgB8XvRC1hSlxQ5aa7h+C6r0B8
         MA5EC11Lfb79ziSsPbZQKZyCdNOlqdgc2CJ9GGpcchM6eSDz3OI/n35CyFL0R/OccG
         ZMimvaFngoSXaBEbitQNJ6FWfq7saTMoz7mFsDDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        ChiYuan Huang <cy_huang@richtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0978/1073] regulator: core: Fix resolve supply lookup issue
Date:   Wed, 28 Dec 2022 15:42:46 +0100
Message-Id: <20221228144354.639722671@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ChiYuan Huang <cy_huang@richtek.com>

[ Upstream commit 0debed5b117d11e33cba52870c4dcb64f5911891 ]

>From Marek's log, the previous change modify the parent of rdev.
https://lore.kernel.org/all/58b92e75-f373-dae7-7031-8abd465bb874@samsung.com/

In 'regulator_resolve_supply', it uses the parent DT node of rdev as the
DT-lookup starting node. But the parent DT node may not exist. This will
cause the NULL supply issue.

This patch modify the parent of rdev back to the device that provides
from 'regulator_config' in 'regulator_register'.

Fixes: 8f3cbcd6b440 ("regulator: core: Use different devices for resource allocation and DT lookup")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
Link: https://lore.kernel.org/r/1670981831-12583-1-git-send-email-u0084500@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c095ca9f01e8..93da2b4cbc72 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5531,7 +5531,7 @@ regulator_register(struct device *dev,
 
 	/* register with sysfs */
 	rdev->dev.class = &regulator_class;
-	rdev->dev.parent = dev;
+	rdev->dev.parent = config->dev;
 	dev_set_name(&rdev->dev, "regulator.%lu",
 		    (unsigned long) atomic_inc_return(&regulator_no));
 	dev_set_drvdata(&rdev->dev, rdev);
-- 
2.35.1



