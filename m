Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B180414803B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbgAXLIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:08:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:44384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389717AbgAXLIy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:08:54 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 476FC20663;
        Fri, 24 Jan 2020 11:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864134;
        bh=65oIQUbtDm3SrnohFcdeYGu2gUSsLPXvueJeKXNf02s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KpFzNHEibMvaQeRSJ5qK5EdS1ZlNRlHN94vjkSYMd+OOqlR4obTEO9HOzO5Xc6cX/
         2LIN7O8O4xTKZQ4+oRdfaMbabGRENNRG6lr2Kx8Qqqek1lRFhcj3xVo7SCxQk2GB3Y
         42eF9Eg2lXElgu24e/aqVOTAXbq5WJ7T5aiORBis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Jian <liujian56@huawei.com>,
        Hamish Martin <hamish.martin@alliedtelesis.co.nz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 155/639] driver: uio: fix possible memory leak in __uio_register_device
Date:   Fri, 24 Jan 2020 10:25:25 +0100
Message-Id: <20200124093106.624509510@linuxfoundation.org>
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

[ Upstream commit 1a392b3de7c5747506b38fc14b2e79977d3c7770 ]

'idev' is malloced in __uio_register_device() and leak free it before
leaving from the uio_get_minor() error handing case, it will cause
memory leak.

Fixes: a93e7b331568 ("uio: Prevent device destruction while fds are open")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Reviewed-by: Hamish Martin <hamish.martin@alliedtelesis.co.nz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/uio/uio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 2762148c169df..e4b418757017f 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -938,8 +938,10 @@ int __uio_register_device(struct module *owner,
 	atomic_set(&idev->event, 0);
 
 	ret = uio_get_minor(idev);
-	if (ret)
+	if (ret) {
+		kfree(idev);
 		return ret;
+	}
 
 	idev->dev.devt = MKDEV(uio_major, idev->minor);
 	idev->dev.class = &uio_class;
-- 
2.20.1



