Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852F2411BF9
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343733AbhITRFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:05:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345569AbhITRDp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:03:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C61816141B;
        Mon, 20 Sep 2021 16:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156844;
        bh=IAJzPJm6psF2GjI1dEIJkyQ59WOL9V751RVZDVdIXwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TOrrgWF4eJweZ+mb3t7BnFmlmwbU/ird52P+26OUYWLsJuPaqfTp8C/YpSZZ923i0
         7IbuX+y5HRVyW3+41x3cf+MOEkNTLUTcpuyIXbwPC85/+fdzVC7xt29rKo58hAKHJc
         FMJhDAMxtKj4+x06MoZ8S8PQtsSGtZhChEgqjao0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 069/175] usb: host: ohci-tmio: add IRQ check
Date:   Mon, 20 Sep 2021 18:41:58 +0200
Message-Id: <20210920163920.316701354@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
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
index cfcfadfc94fc..9c9e97294c18 100644
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



