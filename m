Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD6D59485B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353912AbiHOXmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354194AbiHOXlh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5950783F3A;
        Mon, 15 Aug 2022 13:11:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D466B80EAD;
        Mon, 15 Aug 2022 20:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7027CC433D7;
        Mon, 15 Aug 2022 20:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594265;
        bh=a4msX/u+y+7Zrc3gwU7scUBR6sDo4jLQHCMw3wNXdzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cnOsOVUziZU3EJMzVey8ADgxFYK2EVylhehW86LevX1xf49Q7cKYUS26u+m3efZii
         r11gS1SHX3R8yUQoTrwwDup+enoIbW4blkyjyvLc3BT/72NFcw5ltdG7oS8wuXW/hB
         coHpcLsyPRcY2USfLtfWo6mEBngCObZi9qy0/0YQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Jian Zhang <zhangjian210@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0403/1157] media: driver/nxp/imx-jpeg: fix a unexpected return value problem
Date:   Mon, 15 Aug 2022 19:55:59 +0200
Message-Id: <20220815180455.790165113@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jian Zhang <zhangjian210@huawei.com>

[ Upstream commit 5b304046a81eda221b5d06a9c62f7b5e45530fa5 ]

In function mxc_jpeg_probe(), when devm_clk_get() fail, the return value
will be unexpected, and it should be the devm_clk_get's error code.

Fixes: 4c2e5156d9fa6 ("media: imx-jpeg: Add pm-runtime support for imx-jpeg")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jian Zhang <zhangjian210@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
index 35a7cb936653..b2ea57b45028 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -2145,12 +2145,14 @@ static int mxc_jpeg_probe(struct platform_device *pdev)
 	jpeg->clk_ipg = devm_clk_get(dev, "ipg");
 	if (IS_ERR(jpeg->clk_ipg)) {
 		dev_err(dev, "failed to get clock: ipg\n");
+		ret = PTR_ERR(jpeg->clk_ipg);
 		goto err_clk;
 	}
 
 	jpeg->clk_per = devm_clk_get(dev, "per");
 	if (IS_ERR(jpeg->clk_per)) {
 		dev_err(dev, "failed to get clock: per\n");
+		ret = PTR_ERR(jpeg->clk_per);
 		goto err_clk;
 	}
 
-- 
2.35.1



