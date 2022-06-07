Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA388541428
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347860AbiFGUNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359575AbiFGUMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:12:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93944A5010;
        Tue,  7 Jun 2022 11:27:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D283F6138B;
        Tue,  7 Jun 2022 18:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1918C341C5;
        Tue,  7 Jun 2022 18:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626462;
        bh=h52zxNpYYU8WCZXmj5zjTKIXV+j+MQqMSEZmLGWkZrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gfy97MNqQTO5oHzh+613h2anw+NFP5mgNCl4p8cPRn9+iMuPOjBHUw1zPP9WlLeMB
         Pf7lvsjgR5E1CpRsR/cu7TgAZwkNwuyiJcSjSE5u0maFlCw2SrBt4SIbQq5LfgSq0V
         Dp1TDCtyqz4Sg+WFPM1ThnoaEazMXdcZFSn0+FTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 346/772] spi: spi-fsl-qspi: check return value after calling platform_get_resource_byname()
Date:   Tue,  7 Jun 2022 18:58:58 +0200
Message-Id: <20220607164959.218092549@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit a2b331ac11e1cac56f5b7d367e9f3c5796deaaed ]

It will cause null-ptr-deref if platform_get_resource_byname() returns NULL,
we need check the return value.

Fixes: 858e26a515c2 ("spi: spi-fsl-qspi: Reduce devm_ioremap size to 4 times AHB buffer size")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20220505093954.1285615-1-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-qspi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/spi/spi-fsl-qspi.c b/drivers/spi/spi-fsl-qspi.c
index 9851551ebbe0..46ae46a944c5 100644
--- a/drivers/spi/spi-fsl-qspi.c
+++ b/drivers/spi/spi-fsl-qspi.c
@@ -876,6 +876,10 @@ static int fsl_qspi_probe(struct platform_device *pdev)
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
 					"QuadSPI-memory");
+	if (!res) {
+		ret = -EINVAL;
+		goto err_put_ctrl;
+	}
 	q->memmap_phy = res->start;
 	/* Since there are 4 cs, map size required is 4 times ahb_buf_size */
 	q->ahb_addr = devm_ioremap(dev, q->memmap_phy,
-- 
2.35.1



