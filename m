Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F2613F75C
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388023AbgAPTLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:11:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:49816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387480AbgAPRAS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:00:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B9062467C;
        Thu, 16 Jan 2020 17:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194018;
        bh=+JWYpikP2XfRGIZwTlxZ+tio/c4gA2u4kGxorWRvbMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GW5AEPoU4PB5+Osfvgh6lfn77COFSJNSOjBYt/hMBwpA8o0fe46j6Vkj6JqB40ZNN
         reG3aUirjTzARZxhqIH/xhkGMEN7ypOCl3P0auv82JpWBQF2/m/uPzNwaZ/N6TYkvx
         bI43CETeGJHDOFAM44nKszkUq/sD6YrDJFwsWa/8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liu Jian <liujian56@huawei.com>,
        Hamish Martin <hamish.martin@alliedtelesis.co.nz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 139/671] driver: uio: fix possible memory leak in __uio_register_device
Date:   Thu, 16 Jan 2020 11:50:48 -0500
Message-Id: <20200116165940.10720-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 2762148c169d..e4b418757017 100644
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

