Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 349B31595D
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbfEGFgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:36:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727964AbfEGFgB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:36:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A01320C01;
        Tue,  7 May 2019 05:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207361;
        bh=LtL9Lu69IYXxNadhHHE5MxBPom1bl3355HqXQ65dbeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XBaj3iFv5R5jHiuapVqsVfFWm28B48nuAeb0O1k8DUAFfjMkhCpmPcDUTtdKKpyfs
         c9/ShQ+nsTOckmkvMxTDJAIgaJJE87TMvr/aJg8nvQBSlyeaV0+YOlnt+24DFyuwrk
         nownXvOlqbQGWan/COoUzcpIK6SGhI6ZEvnejW8A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Sven Van Asbroeck <TheSven73@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/81] iio: adc: xilinx: prevent touching unclocked h/w on remove
Date:   Tue,  7 May 2019 01:34:34 -0400
Message-Id: <20190507053554.30848-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

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
index 15e1a103f37d..1ae86e7359f7 100644
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

