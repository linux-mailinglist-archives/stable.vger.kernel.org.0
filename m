Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E67408F7B
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242514AbhIMNnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:43:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242938AbhIMNlN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:41:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C009661284;
        Mon, 13 Sep 2021 13:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539784;
        bh=oLulRJc2tHhj2i0xsNbP/xF1YZEErCzvRn5Suf+glkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hvNaXlQCLfeXScFW86A+iV7OgvzEMCXCyOvbV/MAKyy2pgWDFQgBGo/1AQi6nVvfb
         JS2wkX9g4iJmya8Pde7uefF/eUX7UAI+q2yNcIREfdLB5zJDWkN4jIvrMpcdhJniB1
         aJBY9hv1MQ6wwguy0oNep1+2zHC82kUyfHdm4kgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 159/236] usb: host: ohci-tmio: add IRQ check
Date:   Mon, 13 Sep 2021 15:14:24 +0200
Message-Id: <20210913131105.790321683@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit 4ac5132e8a4300637a2da8f5d6bc7650db735b8a ]

The driver neglects to check the  result of platform_get_irq()'s call and
blithely passes the negative error codes to usb_add_hcd() (which takes
*unsigned* IRQ #), causing request_irq() that it calls to fail with
-EINVAL, overriding an original error code. Stop calling usb_add_hcd()
with the invalid IRQ #s.

Fixes: 78c73414f4f6 ("USB: ohci: add support for tmio-ohci cell")
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/402e1a45-a0a4-0e08-566a-7ca1331506b1@omp.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ohci-tmio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/host/ohci-tmio.c b/drivers/usb/host/ohci-tmio.c
index 7f857bad9e95..08ec2ab0d95a 100644
--- a/drivers/usb/host/ohci-tmio.c
+++ b/drivers/usb/host/ohci-tmio.c
@@ -202,6 +202,9 @@ static int ohci_hcd_tmio_drv_probe(struct platform_device *dev)
 	if (!cell)
 		return -EINVAL;
 
+	if (irq < 0)
+		return irq;
+
 	hcd = usb_create_hcd(&ohci_tmio_hc_driver, &dev->dev, dev_name(&dev->dev));
 	if (!hcd) {
 		ret = -ENOMEM;
-- 
2.30.2



