Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9AD1EED2
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfEOL0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:26:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbfEOL0K (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:26:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EE3A20818;
        Wed, 15 May 2019 11:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919570;
        bh=7zpMCgIPMTHieUH/kBsQzSjOK6LEHevYPbzwmbMoFgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ug2sRnOY1umVHdC5H7CwLrOGUXAJFzuPSohaLdpKS8e1hiB/HdfjI7g4rtz5vwSVE
         WsAa2ofiWqyB50em5gFztEjOqdAu6dWFuvrl33NqYcqO1cT9fK9aQ6Yz+HOmQkLSrc
         VH56F6YiSPm31oRP5HgLYY8sFwU68v7GQIolnXkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Van Asbroeck <TheSven73@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 012/137] iio: adc: xilinx: fix potential use-after-free on probe
Date:   Wed, 15 May 2019 12:54:53 +0200
Message-Id: <20190515090654.181268620@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 1960694e80076..15e1a103f37da 100644
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



