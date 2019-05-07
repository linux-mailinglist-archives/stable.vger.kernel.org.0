Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A589315C39
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfEGGBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 02:01:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727407AbfEGFf7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:35:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 223CD20B7C;
        Tue,  7 May 2019 05:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207358;
        bh=b6nEX9JyoFG3leregqh5qsp2VIYU9nfUcat7IvLJ+Ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F92IoYb766qNEaLrlBicRomfGCN/iUS99IE6DpS74xsjyDizd+p3pEBZKviwtrbyy
         WBVnKEBdHMyHDa2QKmP8gy297nv+2GL5Bx5HjF85U1S+3WMcHd04zZgoLdTF3BtOeD
         68M+4y6cDrx441TyYeWwmjN19qCiclxElt9JoZYY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Sven Van Asbroeck <TheSven73@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/81] iio: adc: xilinx: fix potential use-after-free on probe
Date:   Tue,  7 May 2019 01:34:33 -0400
Message-Id: <20190507053554.30848-2-sashal@kernel.org>
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

