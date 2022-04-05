Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B584F3813
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376290AbiDELVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349375AbiDEJtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239AC14002;
        Tue,  5 Apr 2022 02:44:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACF106164D;
        Tue,  5 Apr 2022 09:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1D7C385A1;
        Tue,  5 Apr 2022 09:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151876;
        bh=xtIMnYy/oN7Xfj9rTXRq6O2uWaiAM06WmjSw/S5HbOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fARTHkx+874a1FLBEng+JNYaPx63jwF3+VZlZcJq5V3n9kwaw2tmZGszdqLUpiyEV
         sF2uGVh36pq0MtQ0YDQKc2j/zBUkoGGrokHd2qeIoDGKfNuXFkfXs6z21BaSks7Tyl
         ZMrgypwsGSdukls0Ch372bNZi1Pp0WVA/XD/ut9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 572/913] mfd: asic3: Add missing iounmap() on error asic3_mfd_probe
Date:   Tue,  5 Apr 2022 09:27:14 +0200
Message-Id: <20220405070356.989728082@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
index 8d58c8df46cf..56338f9dbd0b 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -906,14 +906,14 @@ static int __init asic3_mfd_probe(struct platform_device *pdev,
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
@@ -927,8 +927,12 @@ static int __init asic3_mfd_probe(struct platform_device *pdev,
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



