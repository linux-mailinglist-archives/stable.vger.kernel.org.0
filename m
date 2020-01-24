Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB7614801E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730555AbgAXLHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:07:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:43234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729719AbgAXLHv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:07:51 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72C652071A;
        Fri, 24 Jan 2020 11:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864071;
        bh=Rebf2awFjclg80ipe+TI3GP5OMpaMciweXQVE69s/lY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LpqRviVKB/rpHNkvjeB930afV7kwVl07KVAqAB9331UkVspoU8dNBdslrcDUB42I6
         vYzEtSlr9pKwWw83rUsNaZEaHrDF728SRMcsJHKDrD63pbNea5MWxBjGavAuk4zVqX
         LKPA6Mw+VLFZ7KRU7KACOnZQtDiLoJHnFTP0us8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Jian <liujian56@huawei.com>,
        Hamish Martin <hamish.martin@alliedtelesis.co.nz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 156/639] driver: uio: fix possible use-after-free in __uio_register_device
Date:   Fri, 24 Jan 2020 10:25:26 +0100
Message-Id: <20200124093106.744914816@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit 221a1f4ac12d2ab46246c160b2e00d1b1160d5d9 ]

In uio_dev_add_attributes() error handing case, idev is used after
device_unregister(), in which 'idev' has been released, touch idev cause
use-after-free.

Fixes: a93e7b331568 ("uio: Prevent device destruction while fds are open")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Reviewed-by: Hamish Martin <hamish.martin@alliedtelesis.co.nz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/uio/uio.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index e4b418757017f..9c788748bdc65 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -943,6 +943,7 @@ int __uio_register_device(struct module *owner,
 		return ret;
 	}
 
+	device_initialize(&idev->dev);
 	idev->dev.devt = MKDEV(uio_major, idev->minor);
 	idev->dev.class = &uio_class;
 	idev->dev.parent = parent;
@@ -953,7 +954,7 @@ int __uio_register_device(struct module *owner,
 	if (ret)
 		goto err_device_create;
 
-	ret = device_register(&idev->dev);
+	ret = device_add(&idev->dev);
 	if (ret)
 		goto err_device_create;
 
@@ -985,9 +986,10 @@ int __uio_register_device(struct module *owner,
 err_request_irq:
 	uio_dev_del_attributes(idev);
 err_uio_dev_add_attributes:
-	device_unregister(&idev->dev);
+	device_del(&idev->dev);
 err_device_create:
 	uio_free_minor(idev);
+	put_device(&idev->dev);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(__uio_register_device);
-- 
2.20.1



