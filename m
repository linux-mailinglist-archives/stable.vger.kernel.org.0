Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2812E6932
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgL1Mzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:55:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:51624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727744AbgL1Mzl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:55:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30B5121D94;
        Mon, 28 Dec 2020 12:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160125;
        bh=OrwJrGcTg4tAr/X+3gWrpqUITrvwyGyv8UDuheifhIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dd2mB9K3IjpxVoL1qNOXDdYkZeUoy0hksJeT64A/msKM1hAeQaDzK4tvVGzWAMwYk
         +X2LEdPnJxnXUocBMlzYBM6jpNKFvyy1GlM5xj0exMJYTOr8D0DFopW5ibajI+AKSJ
         GlL5TVpZCOQCgLhkSNQbncsU5x/JLuVNYQG5XXKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 077/132] usb: oxu210hp-hcd: Fix memory leak in oxu_create
Date:   Mon, 28 Dec 2020 13:49:21 +0100
Message-Id: <20201228124850.158328654@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
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
index 1f139d82cee08..d1e0d9d4e7a60 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -3741,8 +3741,10 @@ static struct usb_hcd *oxu_create(struct platform_device *pdev,
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



