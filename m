Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A77D2E3C0D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405112AbgL1N6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:58:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:59770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407491AbgL1N6A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:58:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D63842064B;
        Mon, 28 Dec 2020 13:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163840;
        bh=uDNo/bqltRqyWn1OWKZO/QWcAC4H4wazbhYVmb6d6Ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W/0a3l+nuBZrdYuTlLaBDFSgdsvZl7KW6/V8NOCOzGN0vqDKtnByjJiz9ngYTrc8t
         rgXuoJENJ+oDEOP14vKijxKCJ0VnuZkzjVNbnRkqF/DZ/gt4A5K1+s9iHmDIxZ5D+5
         MzrrkDUWRx4mRoLgOiqdzdtWmgVD53NkHrUGu0i0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 426/453] iio: adc: rockchip_saradc: fix missing clk_disable_unprepare() on error in rockchip_saradc_resume
Date:   Mon, 28 Dec 2020 13:51:02 +0100
Message-Id: <20201228124957.723876424@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
@@ -372,7 +372,7 @@ static int rockchip_saradc_resume(struct
 
 	ret = clk_prepare_enable(info->clk);
 	if (ret)
-		return ret;
+		clk_disable_unprepare(info->pclk);
 
 	return ret;
 }


