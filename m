Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925ED2E6815
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730354AbgL1NEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:04:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730342AbgL1NEF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:04:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50F0E208BA;
        Mon, 28 Dec 2020 13:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160604;
        bh=SsfM55E3ejQOLuIXCJFK4G7tc3KGGcQwqQuKCZgLwuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zLCvQL/WGSiczNwt4ecWRU/Z2C4SYSXuZ8hSwj/Ziydj9XRL5HJtGvctb/gvAWTsD
         0/yRZ8JBminycQ7bVr9WlMIwNAAxwR3uT/2xbKn2vD2fisE8fVfxVGEr6cI4Ffne43
         czKRD2IQEjNusfHWDDVMAbygX+kFkHJP5q+4aKco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 107/175] usb: oxu210hp-hcd: Fix memory leak in oxu_create
Date:   Mon, 28 Dec 2020 13:49:20 +0100
Message-Id: <20201228124858.436590174@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit e5548b05631ec3e6bfdaef1cad28c799545b791b ]

usb_create_hcd will alloc memory for hcd, and we should
call usb_put_hcd to free it when adding fails to prevent
memory leak.

Fixes: b92a78e582b1a ("usb host: Oxford OXU210HP HCD driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201123145809.1456541-1-zhangqilong3@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/oxu210hp-hcd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
index 4e4d601af35c1..2f48da0c0bb39 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -3734,8 +3734,10 @@ static struct usb_hcd *oxu_create(struct platform_device *pdev,
 	oxu->is_otg = otg;
 
 	ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
-	if (ret < 0)
+	if (ret < 0) {
+		usb_put_hcd(hcd);
 		return ERR_PTR(ret);
+	}
 
 	device_wakeup_enable(hcd->self.controller);
 	return hcd;
-- 
2.27.0



