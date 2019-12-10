Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCC5111959D
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfLJVWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:22:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:34526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728212AbfLJVLg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:11:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDB2924697;
        Tue, 10 Dec 2019 21:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012295;
        bh=D8q4VDYYiohP4GpAY9Ud12Sbeab7HPPlzEHkpO3S0pM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EcAFZeRxSPDK58HXWDjKzDVGBuS5UdQtW2uwl9LKIMewzR/hTyAl++59+XbdnQREu
         u+3fOBFolR52r+XBmj2dGlBzu68nKeviy8eAy50SQy5Uel2ePe4A+uK94iZSGNqsew
         +61L6mWKdvi8bj3EP/Mt0hrUI4L/1VxuacNZSUe0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org, Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 234/350] xen/gntdev: Use select for DMA_SHARED_BUFFER
Date:   Tue, 10 Dec 2019 16:05:39 -0500
Message-Id: <20191210210735.9077-195-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

[ Upstream commit fa6614d8ef13c63aac52ad7c07c5e69ce4aba3dd ]

DMA_SHARED_BUFFER can not be enabled by the user (it represents a library
set in the kernel). The kconfig convention is to use select for such
symbols so they are turned on implicitly when the user enables a kconfig
that needs them.

Otherwise the XEN_GNTDEV_DMABUF kconfig is overly difficult to enable.

Fixes: 932d6562179e ("xen/gntdev: Add initial support for dma-buf UAPI")
Cc: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: xen-devel@lists.xenproject.org
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Reviewed-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 79cc75096f423..a50dadd010933 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -141,7 +141,8 @@ config XEN_GNTDEV
 
 config XEN_GNTDEV_DMABUF
 	bool "Add support for dma-buf grant access device driver extension"
-	depends on XEN_GNTDEV && XEN_GRANT_DMA_ALLOC && DMA_SHARED_BUFFER
+	depends on XEN_GNTDEV && XEN_GRANT_DMA_ALLOC
+	select DMA_SHARED_BUFFER
 	help
 	  Allows userspace processes and kernel modules to use Xen backed
 	  dma-buf implementation. With this extension grant references to
-- 
2.20.1

