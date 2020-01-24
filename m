Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 085C9147BF1
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387660AbgAXJrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:47:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:47580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387657AbgAXJrl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:47:41 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76634208C4;
        Fri, 24 Jan 2020 09:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859261;
        bh=izpdMhvOgGI4GeHV7uNz5XinlZnCFeTSYzErDPQisXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2actTctMDTUQ0iAhAqYIhGNPs+PybxllnhfaMgmt/nqTS0gPIbkOv8FZCWYyzsE2K
         Yqy336/I63U/B2SafQ1UA/bhd++3uvwNrylGDnzjGa7JkRgw96CHUcK5hRevU2Ec7U
         D5A86OXuCMixTSlyreZcCTAkh3irMVWDwGUjYcK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Jian <liujian56@huawei.com>,
        Hamish Martin <hamish.martin@alliedtelesis.co.nz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 079/343] driver: uio: fix possible use-after-free in __uio_register_device
Date:   Fri, 24 Jan 2020 10:28:17 +0100
Message-Id: <20200124092930.296466829@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
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
index 4e9b0ff79b131..7c18536a3742a 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -944,6 +944,7 @@ int __uio_register_device(struct module *owner,
 		return ret;
 	}
 
+	device_initialize(&idev->dev);
 	idev->dev.devt = MKDEV(uio_major, idev->minor);
 	idev->dev.class = &uio_class;
 	idev->dev.parent = parent;
@@ -954,7 +955,7 @@ int __uio_register_device(struct module *owner,
 	if (ret)
 		goto err_device_create;
 
-	ret = device_register(&idev->dev);
+	ret = device_add(&idev->dev);
 	if (ret)
 		goto err_device_create;
 
@@ -986,9 +987,10 @@ int __uio_register_device(struct module *owner,
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



