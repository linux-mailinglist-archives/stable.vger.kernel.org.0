Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C302E67DA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633627AbgL1Q3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:29:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:34882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729218AbgL1NHJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:07:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 863A022582;
        Mon, 28 Dec 2020 13:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160789;
        bh=s0SWNNKf0DpnWFJWvV5sK+f8n28NEy6C+dlELFmW8vQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OBYXSgP64wbGobqTzoKVmoUOqhv2zd7Ay2tfrZDWzD2D8UAtgYnalEJhoM3wfjyvg
         zwEt3q69oAvryHIkzE5/PYKyaiC8kOlHSY2/iNnyvY6pjz6japmK9P19qgbdKq7wGW
         QyeZgzmLGDq7w0P5oWNMVYFJhNSLayvU7KKt2ae8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.9 171/175] iio: adc: rockchip_saradc: fix missing clk_disable_unprepare() on error in rockchip_saradc_resume
Date:   Mon, 28 Dec 2020 13:50:24 +0100
Message-Id: <20201228124901.511336983@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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
@@ -378,7 +378,7 @@ static int rockchip_saradc_resume(struct
 
 	ret = clk_prepare_enable(info->clk);
 	if (ret)
-		return ret;
+		clk_disable_unprepare(info->pclk);
 
 	return ret;
 }


