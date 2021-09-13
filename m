Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5162408D51
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235706AbhIMNZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:25:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240500AbhIMNXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:23:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C67F6108B;
        Mon, 13 Sep 2021 13:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539283;
        bh=KiDBhXZ7RdMy0kGtZMgu2PLDtHCRjgXdc9e6YuIvfDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2pAUjvANOaPskZFfOZBDlpzuEsBm5aS00DSr2N9fx48uT4moicT8SEsnvwg3kg9zP
         1J6ZSBSdNuBPIb2um766t0YbKURK3zoLDemuADSjg7VePBko9SR9kOtBpZ8swFrfqq
         QHlt+WKKqr+WM35fhs7gh70G1DM435o8gnFE4yVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/144] usb: host: ohci-tmio: add IRQ check
Date:   Mon, 13 Sep 2021 15:14:34 +0200
Message-Id: <20210913131051.058315407@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
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
index fb6f5e9ae5c6..fed43c6dd85c 100644
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



