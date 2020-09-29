Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB9327CB59
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbgI2M1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:27:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729659AbgI2Ldb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:33:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0F7123BCD;
        Tue, 29 Sep 2020 11:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378849;
        bh=DdvzAaC6J6nQLYIT469vWi39O8jo+T55pCFGjJn94oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSxQVcWEbHhWdXcpjLGnBLqcCQHylCMQZL04olCIeAvzSAFILIp2/s0mPgRwBYsfc
         /yDowWpHwkpypAHWEp47pJVb5vPVTUIh7UJ78BKyqUAdmDoFbHuzrnqxs1R2AtUrbK
         f7jcI3UTEL0ua3dEGskvh8I1O4D4rU+raDAPV7So=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 161/245] USB: EHCI: ehci-mv: fix error handling in mv_ehci_probe()
Date:   Tue, 29 Sep 2020 13:00:12 +0200
Message-Id: <20200929105954.821072910@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tang Bin <tangbin@cmss.chinamobile.com>

[ Upstream commit c856b4b0fdb5044bca4c0acf9a66f3b5cc01a37a ]

If the function platform_get_irq() failed, the negative value
returned will not be detected here. So fix error handling in
mv_ehci_probe(). And when get irq failed, the function
platform_get_irq() logs an error message, so remove redundant
message here.

Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Link: https://lore.kernel.org/r/20200508114305.15740-1-tangbin@cmss.chinamobile.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ehci-mv.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-mv.c b/drivers/usb/host/ehci-mv.c
index de764459e05a6..4edcd7536a01b 100644
--- a/drivers/usb/host/ehci-mv.c
+++ b/drivers/usb/host/ehci-mv.c
@@ -193,9 +193,8 @@ static int mv_ehci_probe(struct platform_device *pdev)
 	hcd->regs = ehci_mv->op_regs;
 
 	hcd->irq = platform_get_irq(pdev, 0);
-	if (!hcd->irq) {
-		dev_err(&pdev->dev, "Cannot get irq.");
-		retval = -ENODEV;
+	if (hcd->irq < 0) {
+		retval = hcd->irq;
 		goto err_disable_clk;
 	}
 
-- 
2.25.1



