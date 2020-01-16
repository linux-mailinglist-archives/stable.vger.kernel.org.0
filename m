Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 133DD13E737
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733301AbgAPRYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:24:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:58798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391748AbgAPRYY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:24:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6DA324690;
        Thu, 16 Jan 2020 17:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195463;
        bh=dzy2KhL75lDoksND+HhzTxU0ZmtY+fAKEeJElGLiyFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JXNqFbhqzN6N2aMhQVIA3PLsNCnEHKTkCvjvDmX7WRK7bUNVfNbcb5cHreVdxl2IT
         axasoSPsEwdih+zcp23EVd3hLKDnUDShXaud6dGX/NOfOvc9974Zgb/DT3gw269vcb
         keHR3zqAV6XC7wI5N9WSOkl98+3d8bHxeE9rhRBY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liu Jian <liujian56@huawei.com>,
        Hamish Martin <hamish.martin@alliedtelesis.co.nz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 071/371] driver: uio: fix possible memory leak in __uio_register_device
Date:   Thu, 16 Jan 2020 12:19:03 -0500
Message-Id: <20200116172403.18149-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
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
index fb5c9701b1fb..4e9b0ff79b13 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -939,8 +939,10 @@ int __uio_register_device(struct module *owner,
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

