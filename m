Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 998441F121
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730104AbfEOLVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:21:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731216AbfEOLVH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:21:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2B972084F;
        Wed, 15 May 2019 11:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919267;
        bh=CERp3i2iLB2TEaVHKwjI6GCZatALGM64HOa2MbAtixU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l1m0XhMxqxiI3cDrtyQGNVpNg3223DzNVeOBfvvXhlj3hIJuoEXdf6bQ7c4n+/Jdy
         Wmao01fffjESvfEQS3AmEjjN4FhoyQZTqGwvBHjSJl25Z56peuKUKPDT4XcRSamhEN
         tncLXzUpYbsa22nHYpvJTt0OvReqJPO3jeYQsT7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Van Asbroeck <TheSven73@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 011/113] iio: adc: xilinx: prevent touching unclocked h/w on remove
Date:   Wed, 15 May 2019 12:55:02 +0200
Message-Id: <20190515090654.392101761@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2e4b88f73966adead360e47621df0183586fac32 ]

In remove, the clock is disabled before canceling the
delayed work. This means that the delayed work may be
touching unclocked hardware.

Fix by disabling the clock after the delayed work is
fully canceled. This is consistent with the probe error
path order.

Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/xilinx-xadc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/xilinx-xadc-core.c b/drivers/iio/adc/xilinx-xadc-core.c
index 15e1a103f37da..1ae86e7359f73 100644
--- a/drivers/iio/adc/xilinx-xadc-core.c
+++ b/drivers/iio/adc/xilinx-xadc-core.c
@@ -1320,8 +1320,8 @@ static int xadc_remove(struct platform_device *pdev)
 		iio_triggered_buffer_cleanup(indio_dev);
 	}
 	free_irq(xadc->irq, indio_dev);
-	clk_disable_unprepare(xadc->clk);
 	cancel_delayed_work_sync(&xadc->zynq_unmask_work);
+	clk_disable_unprepare(xadc->clk);
 	kfree(xadc->data);
 	kfree(indio_dev->channels);
 
-- 
2.20.1



