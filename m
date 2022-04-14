Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9515501218
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345869AbiDNNyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345117AbiDNNpJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:45:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBA037BC2;
        Thu, 14 Apr 2022 06:42:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DB3F61D68;
        Thu, 14 Apr 2022 13:42:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5870EC385A1;
        Thu, 14 Apr 2022 13:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943745;
        bh=STE1V4eBIELbzwjKqO/RVxava5O5udGBwQKcKktC430=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zIir5VVFGmiYWOODiBuInrQDu4XMT2tlDaKwDeJGRgbXDS9PRFxJhfTq0a5+mPE4M
         C+rVEs+E2SkdeaYlXCaRxhHIsW6LhoOjJzv3HUmsWoEwAV/iUhTKZao2g2Awlu7nUr
         lYYFaCt4Y5sdZYB/lwR41WS+PyxTxRfXqBvEaxBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 226/475] mfd: asic3: Add missing iounmap() on error asic3_mfd_probe
Date:   Thu, 14 Apr 2022 15:10:11 +0200
Message-Id: <20220414110901.445759182@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit e84ee1a75f944a0fe3c277aaa10c426603d2b0bc ]

Add the missing iounmap() before return from asic3_mfd_probe
in the error handling case.

Fixes: 64e8867ba809 ("mfd: tmio_mmc hardware abstraction for CNF area")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20220307072947.5369-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/asic3.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index a6bd2134cea2..14e4bbe6a9da 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -914,14 +914,14 @@ static int __init asic3_mfd_probe(struct platform_device *pdev,
 		ret = mfd_add_devices(&pdev->dev, pdev->id,
 			&asic3_cell_ds1wm, 1, mem, asic->irq_base, NULL);
 		if (ret < 0)
-			goto out;
+			goto out_unmap;
 	}
 
 	if (mem_sdio && (irq >= 0)) {
 		ret = mfd_add_devices(&pdev->dev, pdev->id,
 			&asic3_cell_mmc, 1, mem_sdio, irq, NULL);
 		if (ret < 0)
-			goto out;
+			goto out_unmap;
 	}
 
 	ret = 0;
@@ -935,8 +935,12 @@ static int __init asic3_mfd_probe(struct platform_device *pdev,
 		ret = mfd_add_devices(&pdev->dev, 0,
 			asic3_cell_leds, ASIC3_NUM_LEDS, NULL, 0, NULL);
 	}
+	return ret;
 
- out:
+out_unmap:
+	if (asic->tmio_cnf)
+		iounmap(asic->tmio_cnf);
+out:
 	return ret;
 }
 
-- 
2.34.1



