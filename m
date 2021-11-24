Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D1E45BE73
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242980AbhKXMq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:46:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:51024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245229AbhKXMoi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:44:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8B986126A;
        Wed, 24 Nov 2021 12:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756792;
        bh=QnibGiVTccSNGE/fMZJz8aeFKBy1GIoooRfOS2TNRM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zM3Fe81BvdHHtzSh6Pe3Ei05Q7uas/5vNEEl30TzXLyyTBnvhXBqAF/5nsvWQc4M1
         +dQpmP5IdMKmETEc+2AFX76PanzN+6ym2CNoRzciKMdXLXRCzd1K6KT+GfvAkjUeBd
         tJUJyPXyCiua2ckZtuZh1DGBNFmV5ketxVCMjyO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 207/251] usb: host: ohci-tmio: check return value after calling platform_get_resource()
Date:   Wed, 24 Nov 2021 12:57:29 +0100
Message-Id: <20211124115717.461909937@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 9eff2b2e59fda25051ab36cd1cb5014661df657b ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20211011134920.118477-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ohci-tmio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ohci-tmio.c b/drivers/usb/host/ohci-tmio.c
index 0cf4b6dc89720..4c7846dc5eed1 100644
--- a/drivers/usb/host/ohci-tmio.c
+++ b/drivers/usb/host/ohci-tmio.c
@@ -199,7 +199,7 @@ static int ohci_hcd_tmio_drv_probe(struct platform_device *dev)
 	if (usb_disabled())
 		return -ENODEV;
 
-	if (!cell)
+	if (!cell || !regs || !config || !sram)
 		return -EINVAL;
 
 	if (irq < 0)
-- 
2.33.0



