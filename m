Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5536205D1B
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388301AbgFWUJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:09:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388130AbgFWUJI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:09:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9983D206C3;
        Tue, 23 Jun 2020 20:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942948;
        bh=H6VJ9obbYArUMYvO6qBOQtEXRyWgkm6Xs/Q/wVa/QvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CAslWfuPhSzE3wCdVod2wwCyLDIWVF/d4juPWBXE4ZpB/TcQxBsZOHHn3d81HkFl+
         a72TqCKlopKnpU561C0D7LtqNJ2QUmbRmnrubcIffqQ62Zrf6JNyX/wWJUl4X+3qoB
         bCiZS02qoFaSar+iOyz85tIfDdYmZvM6yrLuT6p4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 197/477] USB: ohci-sm501: fix error return code in ohci_hcd_sm501_drv_probe()
Date:   Tue, 23 Jun 2020 21:53:14 +0200
Message-Id: <20200623195416.897284150@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit b919e077cccfbb77beb98809568b2fb0b4d113ec ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 7d9e6f5aebe8 ("usb: host: ohci-sm501: init genalloc for local memory")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20200506135625.106910-1-weiyongjun1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ohci-sm501.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ohci-sm501.c b/drivers/usb/host/ohci-sm501.c
index c158cda9e4b9b..cff9652403270 100644
--- a/drivers/usb/host/ohci-sm501.c
+++ b/drivers/usb/host/ohci-sm501.c
@@ -157,9 +157,10 @@ static int ohci_hcd_sm501_drv_probe(struct platform_device *pdev)
 	 * the call to usb_hcd_setup_local_mem() below does just that.
 	 */
 
-	if (usb_hcd_setup_local_mem(hcd, mem->start,
-				    mem->start - mem->parent->start,
-				    resource_size(mem)) < 0)
+	retval = usb_hcd_setup_local_mem(hcd, mem->start,
+					 mem->start - mem->parent->start,
+					 resource_size(mem));
+	if (retval < 0)
 		goto err5;
 	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (retval)
-- 
2.25.1



