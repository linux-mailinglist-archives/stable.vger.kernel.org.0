Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758FC2065BD
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388811AbgFWUKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:10:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388801AbgFWUK3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:10:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A412A206C3;
        Tue, 23 Jun 2020 20:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943029;
        bh=JDSh+1V572z9jZUQRWMKQO0oJiV9fKv2CkxQ59qd/bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CVQ9jo0N2G/D0xOUQG6XCV9Wmyz7bLnqZ85RJXomYjN6BEANBoJP2yu9u9BXwOXji
         3SBFN/iJmDajq3TMGnBoaIsBqLXMqMgjzHNu7+sTqgJiLZXqLYhwGJ9l6r35y8J6FK
         NJ5iky8kXhk1Eiq2SrE5/gbL3hGW+gBcFfZFcKdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Peter Chen <peter.chen@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 230/477] USB: host: ehci-mxc: Add error handling in ehci_mxc_drv_probe()
Date:   Tue, 23 Jun 2020 21:53:47 +0200
Message-Id: <20200623195418.452277467@linuxfoundation.org>
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

From: Tang Bin <tangbin@cmss.chinamobile.com>

[ Upstream commit d49292025f79693d3348f8e2029a8b4703be0f0a ]

The function ehci_mxc_drv_probe() does not perform sufficient error
checking after executing platform_get_irq(), thus fix it.

Fixes: 7e8d5cd93fac ("USB: Add EHCI support for MX27 and MX31 based boards")
Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20200513132647.5456-1-tangbin@cmss.chinamobile.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ehci-mxc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
index c9f91e6c72b6a..7f65c86047ddd 100644
--- a/drivers/usb/host/ehci-mxc.c
+++ b/drivers/usb/host/ehci-mxc.c
@@ -50,6 +50,8 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
 
 	hcd = usb_create_hcd(&ehci_mxc_hc_driver, dev, dev_name(dev));
 	if (!hcd)
-- 
2.25.1



