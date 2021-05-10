Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D5D378824
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239009AbhEJLUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:20:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236709AbhEJLIj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A72E6619D4;
        Mon, 10 May 2021 11:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644615;
        bh=ZSqH0HKaES/cRWmAqrfBEeb5+bXwFPujDyAIfNZi+lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LgKawN8pzW2LMVDQZvY4H8yzm9216yghLgEcnUzd/ewQ/boGGCUHw88FSD825y2Sp
         EGpSKyLfDfqoPafQHMDeui5K+GjaLvW1fIMcLz78TSx+W7uyI0AZabGec3wSRf94ud
         09y7a/l4RmdZBbYDwR3j0Zt5tiqs38OFq0uXvV74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 118/384] usb: gadget: tegra-xudc: Fix possible use-after-free in tegra_xudc_remove()
Date:   Mon, 10 May 2021 12:18:27 +0200
Message-Id: <20210510102018.780846576@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit a932ee40c276767cd55fadec9e38829bf441db41 ]

This driver's remove path calls cancel_delayed_work(). However, that
function does not wait until the work function finishes. This means
that the callback function may still be running after the driver's
remove function has finished, which would result in a use-after-free.

Fix by calling cancel_delayed_work_sync(), which ensures that
the work is properly cancelled, no longer running, and unable
to re-schedule itself.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20210407092947.3271507-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/tegra-xudc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/tegra-xudc.c b/drivers/usb/gadget/udc/tegra-xudc.c
index 580bef8eb4cb..2319c9737c2b 100644
--- a/drivers/usb/gadget/udc/tegra-xudc.c
+++ b/drivers/usb/gadget/udc/tegra-xudc.c
@@ -3883,7 +3883,7 @@ static int tegra_xudc_remove(struct platform_device *pdev)
 
 	pm_runtime_get_sync(xudc->dev);
 
-	cancel_delayed_work(&xudc->plc_reset_work);
+	cancel_delayed_work_sync(&xudc->plc_reset_work);
 	cancel_work_sync(&xudc->usb_role_sw_work);
 
 	usb_del_gadget_udc(&xudc->gadget);
-- 
2.30.2



