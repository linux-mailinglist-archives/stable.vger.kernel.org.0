Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C6C3D625A
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236876AbhGZPfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:35:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234774AbhGZPd5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:33:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F9DA60F5E;
        Mon, 26 Jul 2021 16:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316051;
        bh=vvAWL2niHHsaplu5TbnbZMJ6g2rH5FdEuq84pbscXhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XxODQFIFnh3IdVvb0J4GamLR19KAUjD8x5OxD7FJK4PFtopJ9mKmTSiRvQJuMBMfn
         6n1IxigdNTuPV9e2dcpxQE3W3goYU+duSox+XJl9HFyjU6+6MUu6KR9lBrJLs1cwCw
         4f2NHgcL3oD+jTuzrlsPkWqGci9RSjb76dpirfOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>
Subject: [PATCH 5.13 169/223] usb: gadget: Fix Unbalanced pm_runtime_enable in tegra_xudc_probe
Date:   Mon, 26 Jul 2021 17:39:21 +0200
Message-Id: <20210726153851.733672346@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

commit 5b01248156bd75303e66985c351dee648c149979 upstream.

Add missing pm_runtime_disable() when probe error out. It could
avoid pm_runtime implementation complains when removing and probing
again the driver.

Fixes: 49db427232fe ("usb: gadget: Add UDC driver for tegra XUSB device mode controller")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20210618141441.107817-1-zhangqilong3@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/tegra-xudc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/udc/tegra-xudc.c
+++ b/drivers/usb/gadget/udc/tegra-xudc.c
@@ -3861,6 +3861,7 @@ static int tegra_xudc_probe(struct platf
 	return 0;
 
 free_eps:
+	pm_runtime_disable(&pdev->dev);
 	tegra_xudc_free_eps(xudc);
 free_event_ring:
 	tegra_xudc_free_event_ring(xudc);


