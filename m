Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE742E62BC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406068AbgL1NtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:49:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406079AbgL1NtL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:49:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A09B520738;
        Mon, 28 Dec 2020 13:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163336;
        bh=/QTD93ioTxXLqscl0R4W/C93PNa/4cpPRsqMePBQCcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JcsYPSJuATitH0sOYCFkpsUKZozJO77O27Ni0iq/4eWuPX1tTDwG2hej5+3Q4ErSC
         TcKORjzPyX8jcQRS+zIyLckq3x+h/O59vSl8gMrH6TrjUbntt76FPXL0TdL1kjd4Rc
         Gws/7aJiottFjhGma0pPibcRvabKTZZ3azAJH8BY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 251/453] usb: oxu210hp-hcd: Fix memory leak in oxu_create
Date:   Mon, 28 Dec 2020 13:48:07 +0100
Message-Id: <20201228124949.304670323@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index e67242e437edc..65985247fc00f 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -4149,8 +4149,10 @@ static struct usb_hcd *oxu_create(struct platform_device *pdev,
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



