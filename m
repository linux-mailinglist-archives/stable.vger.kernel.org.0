Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65753DA68A
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 16:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbhG2Ofl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 10:35:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235324AbhG2Ofk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 10:35:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE8AF60F4B;
        Thu, 29 Jul 2021 14:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627569336;
        bh=EVWeCG+dHdsvppMXTRfNm1+MmGhkBNdB/EmdeGAb1ww=;
        h=From:To:Cc:Subject:Date:From;
        b=dr7b5FHafIThX9AnJVXR9Yu/gH6w5QYu+6Ly7I1VT730LnEwy5qzSQ12Vrxl92Cp+
         Hai3iIyFg2Mh3O9zVlotMLD0eCHQ9r+lvEfWkTq6z73G0E4n+F+4e9axqBC1PpuwQe
         y2rNc5074qNqQ9C6ndpNliCi9NlOQMmJdEGycr5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Wolfram Sang <wsa@kernel.org>, linux-i2c@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH v2] i2c: dev: zero out array used for i2c reads from userspace
Date:   Thu, 29 Jul 2021 16:35:32 +0200
Message-Id: <20210729143532.47240-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1545; h=from:subject; bh=EVWeCG+dHdsvppMXTRfNm1+MmGhkBNdB/EmdeGAb1ww=; b=owGbwMvMwCRo6H6F97bub03G02pJDIlMezat6YzTL77zI3G5qf03Nd7wrTLVaw6kmIt/cWi3n2bC XPW7I5aFQZCJQVZMkeXLNp6j+ysOKXoZ2p6GmcPKBDKEgYtTACZSHsowv+r/u8kv4mtnndD/1sC37u 2eE7PO/2WYp1Yw4+TdTPdAV1mWa/2nIoVfZ/m5AAA=
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If an i2c driver happens to not provide the full amount of data that a
user asks for, it is possible that some uninitialized data could be sent
to userspace.  While all in-kernel drivers look to be safe, just be sure
by initializing the buffer to zero before it is passed to the i2c driver
so that any future drivers will not have this issue.

Also properly copy the amount of data recvieved to the userspace buffer,
as pointed out by Dan Carpenter.

Reported-by: Eric Dumazet <edumazet@google.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v2: Add copy_to_user() change as pointed out by Dan

 drivers/i2c/i2c-dev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index cb64fe649390..77f576e51652 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -141,7 +141,7 @@ static ssize_t i2cdev_read(struct file *file, char __user *buf, size_t count,
 	if (count > 8192)
 		count = 8192;
 
-	tmp = kmalloc(count, GFP_KERNEL);
+	tmp = kzalloc(count, GFP_KERNEL);
 	if (tmp == NULL)
 		return -ENOMEM;
 
@@ -150,7 +150,8 @@ static ssize_t i2cdev_read(struct file *file, char __user *buf, size_t count,
 
 	ret = i2c_master_recv(client, tmp, count);
 	if (ret >= 0)
-		ret = copy_to_user(buf, tmp, count) ? -EFAULT : ret;
+		if (copy_to_user(buf, tmp, ret))
+			ret = -EFAULT;
 	kfree(tmp);
 	return ret;
 }
-- 
2.32.0

