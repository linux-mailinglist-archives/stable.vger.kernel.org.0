Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD8C59388B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244339AbiHOSxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244755AbiHOSvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:51:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651AF474F4;
        Mon, 15 Aug 2022 11:29:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE10CB81062;
        Mon, 15 Aug 2022 18:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1938AC433D6;
        Mon, 15 Aug 2022 18:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588178;
        bh=1epsVxATSZFmvE/+LKcAw9ma1DkPFnaS/bMMkv+nrm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NfCj/U8cOFFungxm+vXnFSAqYvm+mjwKp0tZAS4VUYJzVHK2YlurTltF/EaObT86u
         Fd8iNGrZWqL8jLJ74oKCaM3iTbenqZCe0tZmzbwsVprR2jMgGHKKKmn83HnbnucnQn
         4VtvWpWdLv0PHsWefjEyENKpPVTGyy87i7IK73f0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Jian Zhang <zhangjian210@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 292/779] media: driver/nxp/imx-jpeg: fix a unexpected return value problem
Date:   Mon, 15 Aug 2022 19:58:56 +0200
Message-Id: <20220815180349.760209981@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
 drivers/media/platform/imx-jpeg/mxc-jpeg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
index aeb3704cfff0..984fcdfa0f09 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
@@ -2108,12 +2108,14 @@ static int mxc_jpeg_probe(struct platform_device *pdev)
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



