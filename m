Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55C591F3E6
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbfEOLBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727754AbfEOLBk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:01:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BA8F216FD;
        Wed, 15 May 2019 11:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918100;
        bh=oHPELByl9M22/Gl9ucSlDkC3SSx/IiY/03J/tm8ILx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjWuzzo9vm+w1HBU6NE4MTsBB3i2vx0zlNftbM+Eyir7GBtIBIZeWaR/dkBBnZaOl
         O0+nwisRKEAynxDhFdaEH02gVuceEDGnh6sQOh39HMneZN+/MkBpTXgxZ+eAOpx1xG
         iN4YACqySrcyKudJ/pyK1PV/rFsPGCcsMeaQYSGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Van Asbroeck <TheSven73@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 3.18 65/86] iio: adc: xilinx: fix potential use-after-free on remove
Date:   Wed, 15 May 2019 12:55:42 +0200
Message-Id: <20190515090654.643286016@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090642.339346723@linuxfoundation.org>
References: <20190515090642.339346723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 62039b6aef63380ba7a37c113bbaeee8a55c5342 ]

When cancel_delayed_work() returns, the delayed work may still
be running. This means that the core could potentially free
the private structure (struct xadc) while the delayed work
is still using it. This is a potential use-after-free.

Fix by calling cancel_delayed_work_sync(), which waits for
any residual work to finish before returning.

Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/xilinx-xadc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/xilinx-xadc-core.c b/drivers/iio/adc/xilinx-xadc-core.c
index a483747cdc9b9..b520de11fc17f 100644
--- a/drivers/iio/adc/xilinx-xadc-core.c
+++ b/drivers/iio/adc/xilinx-xadc-core.c
@@ -1315,7 +1315,7 @@ static int xadc_remove(struct platform_device *pdev)
 	}
 	free_irq(irq, indio_dev);
 	clk_disable_unprepare(xadc->clk);
-	cancel_delayed_work(&xadc->zynq_unmask_work);
+	cancel_delayed_work_sync(&xadc->zynq_unmask_work);
 	kfree(xadc->data);
 	kfree(indio_dev->channels);
 
-- 
2.20.1



