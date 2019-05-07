Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD8015D04
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfEGFcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:32:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbfEGFck (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:32:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF8AD2087F;
        Tue,  7 May 2019 05:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207159;
        bh=b6nEX9JyoFG3leregqh5qsp2VIYU9nfUcat7IvLJ+Ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/CihpTQ+rFW2/LEUlx5KAcRP7Gquj3fwAOxqmFCyxijsAMB7TSOzPcDVr7i2KzXR
         N+tu/zvpZwgEB8urvFtu6GuD610FJAgNcIIMLjid1/b5xO+b+qDrIOc/wxyot77z74
         jc8VMqhCKcwG9fRl7HGKIBvLROK34/lJlX5TGxPE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Sven Van Asbroeck <TheSven73@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 02/99] iio: adc: xilinx: fix potential use-after-free on probe
Date:   Tue,  7 May 2019 01:30:56 -0400
Message-Id: <20190507053235.29900-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

[ Upstream commit 862e4644fd2d7df8998edc65e0963ea2f567bde9 ]

If probe errors out after request_irq(), its error path
does not explicitly cancel the delayed work, which may
have been scheduled by the interrupt handler.

This means the delayed work may still be running when
the core frees the private structure (struct xadc).
This is a potential use-after-free.

Fix by inserting cancel_delayed_work_sync() in the probe
error path.

Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/xilinx-xadc-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/xilinx-xadc-core.c b/drivers/iio/adc/xilinx-xadc-core.c
index 1960694e8007..15e1a103f37d 100644
--- a/drivers/iio/adc/xilinx-xadc-core.c
+++ b/drivers/iio/adc/xilinx-xadc-core.c
@@ -1290,6 +1290,7 @@ static int xadc_probe(struct platform_device *pdev)
 
 err_free_irq:
 	free_irq(xadc->irq, indio_dev);
+	cancel_delayed_work_sync(&xadc->zynq_unmask_work);
 err_clk_disable_unprepare:
 	clk_disable_unprepare(xadc->clk);
 err_free_samplerate_trigger:
-- 
2.20.1

