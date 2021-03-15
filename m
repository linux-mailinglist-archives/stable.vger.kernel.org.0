Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0FF33B7BB
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbhCOOBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232745AbhCON7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B369964E89;
        Mon, 15 Mar 2021 13:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816761;
        bh=tfw9hM7u/vNj38cvdyB2pem0hkF9GvyGgV4TjHoKQ1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrxLhg9Mb3kyesczh1IZ0qXoVoPEDEk8d3V5FPx/ysRbl/0NsqWbK3Y0jSLwxGNs3
         vVq9aZRgfIq6wUKUmeeagKTDqgaITY+8t4LHRXCUJMDKM7RyaQf7AxAPe59blkSt4g
         fBJ9jZXdUYd6yZbdSiDqLw5colQHLFlSQ3OsZpLc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Qing <wangqing@vivo.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.10 099/290] s390/crypto: return -EFAULT if copy_to_user() fails
Date:   Mon, 15 Mar 2021 14:53:12 +0100
Message-Id: <20210315135545.268222714@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Wang Qing <wangqing@vivo.com>

commit 942df4be7ab40195e2a839e9de81951a5862bc5b upstream.

The copy_to_user() function returns the number of bytes remaining to be
copied, but we want to return -EFAULT if the copy doesn't complete.

Fixes: e06670c5fe3b ("s390: vfio-ap: implement VFIO_DEVICE_GET_INFO ioctl")
Signed-off-by: Wang Qing <wangqing@vivo.com>
Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://lore.kernel.org/r/1614600502-16714-1-git-send-email-wangqing@vivo.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/vfio_ap_ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1279,7 +1279,7 @@ static int vfio_ap_mdev_get_device_info(
 	info.num_regions = 0;
 	info.num_irqs = 0;
 
-	return copy_to_user((void __user *)arg, &info, minsz);
+	return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
 }
 
 static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,


