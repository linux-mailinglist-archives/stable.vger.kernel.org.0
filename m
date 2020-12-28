Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BD52E37AC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 13:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727759AbgL1M7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:59:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:55330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728608AbgL1M67 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:58:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 577DA208B6;
        Mon, 28 Dec 2020 12:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160298;
        bh=EwbaHjiYdirakRAm7vK9y7i/tkDY1rssIIAlLd0Rhds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YeTWVACOvh76TYmTvPq7mDBhoHXTTnbJWyPjYmp4xFK5XGsrPDOmYBngEb7087y1k
         HJdaC8u2l/QimiRx5mZfSX062mf/RKaHv/wOmCq1BJUK/ucF6AjpcJ+4zzq5Ny4yQD
         oH4DoNjOoQouarnsr4npGNIUDRHMzkxTIEq0/s4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.4 125/132] iio: adc: rockchip_saradc: fix missing clk_disable_unprepare() on error in rockchip_saradc_resume
Date:   Mon, 28 Dec 2020 13:50:09 +0100
Message-Id: <20201228124852.447178861@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

commit 560c6b914c6ec7d9d9a69fddbb5bf3bf71433e8b upstream.

Fix the missing clk_disable_unprepare() of info->pclk
before return from rockchip_saradc_resume in the error
handling case when fails to prepare and enable info->clk.

Suggested-by: Robin Murphy <robin.murphy@arm.com>
Fixes: 44d6f2ef94f9 ("iio: adc: add driver for Rockchip saradc")
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201103120743.110662-1-miaoqinglang@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/rockchip_saradc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/rockchip_saradc.c
+++ b/drivers/iio/adc/rockchip_saradc.c
@@ -359,7 +359,7 @@ static int rockchip_saradc_resume(struct
 
 	ret = clk_prepare_enable(info->clk);
 	if (ret)
-		return ret;
+		clk_disable_unprepare(info->pclk);
 
 	return ret;
 }


