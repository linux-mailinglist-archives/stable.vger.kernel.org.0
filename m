Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE1F2B6548
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730420AbgKQNxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:53:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:35892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731269AbgKQN1u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:27:50 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D4622078D;
        Tue, 17 Nov 2020 13:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619670;
        bh=AQ4pGKsA9yx3wFWgo1/O9cVVXd+CWFA1qClgYFjhxQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CynUgfU+amPJaa2to1TZoLxTRcgKiORB4IsZbkE4LBBjYKhB2e3q6pRwaesV5G+Te
         HS7F7IOLAVIG+B0mZ8eUCCQ2za4jWX9EvHFfmpffpsKCUQa0w2Q8gWPdNpoR7I8IJB
         9rllRw3X9LvmsFfevqy6eINl4WKYKff2e2+Yv2Ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>
Subject: [PATCH 5.4 117/151] xhci: hisilicon: fix refercence leak in xhci_histb_probe
Date:   Tue, 17 Nov 2020 14:05:47 +0100
Message-Id: <20201117122127.121691759@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
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
@@ -241,7 +241,7 @@ static int xhci_histb_probe(struct platf
 	/* Initialize dma_mask and coherent_dma_mask to 32-bits */
 	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
 	if (ret)
-		return ret;
+		goto disable_pm;
 
 	hcd = usb_create_hcd(driver, dev, dev_name(dev));
 	if (!hcd) {


