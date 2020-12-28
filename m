Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438582E3C98
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437418AbgL1OEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:04:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:38578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437407AbgL1OEh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:04:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3422207B2;
        Mon, 28 Dec 2020 14:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164262;
        bh=MvwINwTEjv0gwNuT1fYEsw9EV77aWtaoNtaGfZNe9mI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WRc4XhyPpqLPQTXZEiZqd6BRp8bfcc425zect1+mYPB2LmSNfOYYjLRcDyp94TiRk
         dEP4/jELF2cMYdpxYaZNS6M9rM3vKMToSdpJPtyCyG5b4slLn/QDKJNL8gkljIVWUJ
         stEDFnaCJIGQFue8OzYoRm60H2QzOk25eu/n44mw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/717] media: platform: add missing put_device() call in mtk_jpeg_clk_init()
Date:   Mon, 28 Dec 2020 13:41:57 +0100
Message-Id: <20201228125026.663367165@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit f28a81a3b64270da3588174feff4628c36e0ff4e ]

if of_find_device_by_node() succeeds, mtk_jpeg_clk_init() doesn't have
a corresponding put_device(). Thus add put_device() to fix the exception
handling for this function implementation.

Fixes: 648372a87cee ("media: platform: Change the call functions of getting/enable/disable the jpeg's clock")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
index 227245ccaedc7..106543391c460 100644
--- a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
@@ -1306,6 +1306,7 @@ static int mtk_jpeg_clk_init(struct mtk_jpeg_dev *jpeg)
 				jpeg->variant->clks);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to get jpeg clock:%d\n", ret);
+		put_device(&pdev->dev);
 		return ret;
 	}
 
-- 
2.27.0



