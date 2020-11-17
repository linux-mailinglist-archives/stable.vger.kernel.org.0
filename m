Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15FB92B6439
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732793AbgKQNjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:39:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:51762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732776AbgKQNjv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:39:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 871B620870;
        Tue, 17 Nov 2020 13:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620391;
        bh=HswQOayRJA3M7pC77Ok4nA9JGibXpiliqFLdEbe2UjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBIT95XchfARYyS3SYEK9uqUDwElNv23gRHpceSB3+2wo8NKCEkniR9jesoIyUbU3
         naitKVahB3BwLYLsK9VWrx6GlScBWRuyG2tRzYxpUVeE1Q074p7TFC/dST8DOZDjFZ
         hAW5fe5ZK0pygpxLJpj2qGSdIq3pskuR7nj+7i+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>
Subject: [PATCH 5.9 203/255] xhci: hisilicon: fix refercence leak in xhci_histb_probe
Date:   Tue, 17 Nov 2020 14:05:43 +0100
Message-Id: <20201117122148.811471287@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

commit 76255470ffa2795a44032e8b3c1ced11d81aa2db upstream.

pm_runtime_get_sync() will increment pm usage at first and it
will resume the device later. We should decrease the usage count
whetever it succeeded or failed(maybe runtime of the device has
error, or device is in inaccessible state, or other error state).
If we do not call put operation to decrease the reference, it will
result in reference leak in xhci_histb_probe. Moreover, this
device cannot enter the idle state and always stay busy or other
non-idle state later. So we fixed it by jumping to error handling
branch.

Fixes: c508f41da0788 ("xhci: hisilicon: support HiSilicon STB xHCI host controller")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201106122221.2304528-1-zhangqilong3@huawei.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-histb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-histb.c
+++ b/drivers/usb/host/xhci-histb.c
@@ -240,7 +240,7 @@ static int xhci_histb_probe(struct platf
 	/* Initialize dma_mask and coherent_dma_mask to 32-bits */
 	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
 	if (ret)
-		return ret;
+		goto disable_pm;
 
 	hcd = usb_create_hcd(driver, dev, dev_name(dev));
 	if (!hcd) {


