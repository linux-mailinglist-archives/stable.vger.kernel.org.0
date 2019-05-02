Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F91E11CCA
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbfEBPYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:24:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727379AbfEBPYq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:24:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 785CD214DA;
        Thu,  2 May 2019 15:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810686;
        bh=z3w+GXmfRL63o87fQ3jR4ajIseM2qG7Q05/kb7WzA4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bqpSzCYEptGMvU/KLZLv1xq67ZTSH73IfRYTvI9A6v2cChSsaG6qssTHSxtoiOFkI
         Icidn/iiHCdl11YwPSj39jseWjDwcHCP1VaaxXa4c0xAwYzmvyMBgn8HPU6nwl/jW0
         VbH0xji8IvBj8RjBxso0E0UP3YBauQyDnasdznvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mukesh Ojha <mojha@codeaurora.org>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.14 41/49] usb: u132-hcd: fix resource leak
Date:   Thu,  2 May 2019 17:21:18 +0200
Message-Id: <20190502143329.134914882@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143323.397051088@linuxfoundation.org>
References: <20190502143323.397051088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f276e002793cdb820862e8ea8f76769d56bba575 ]

if platform_driver_register fails, cleanup the allocated resource
gracefully.

Signed-off-by: Mukesh Ojha <mojha@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/usb/host/u132-hcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/host/u132-hcd.c b/drivers/usb/host/u132-hcd.c
index 65c0086e25ae..8d349230b2c7 100644
--- a/drivers/usb/host/u132-hcd.c
+++ b/drivers/usb/host/u132-hcd.c
@@ -3208,6 +3208,9 @@ static int __init u132_hcd_init(void)
 	printk(KERN_INFO "driver %s\n", hcd_name);
 	workqueue = create_singlethread_workqueue("u132");
 	retval = platform_driver_register(&u132_platform_driver);
+	if (retval)
+		destroy_workqueue(workqueue);
+
 	return retval;
 }
 
-- 
2.19.1



